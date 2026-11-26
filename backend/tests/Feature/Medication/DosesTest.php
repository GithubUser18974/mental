<?php

declare(strict_types=1);

use App\Modules\Auth\Models\User;
use App\Modules\Identity\Models\UserPreference;
use App\Modules\Medication\Enums\MedicationStatus;
use App\Modules\Medication\Enums\ScheduleType;
use App\Modules\Medication\Models\Medication;
use App\Modules\Medication\Models\MedicationLog;
use App\Modules\Medication\Support\DoseCalendar;
use Carbon\CarbonImmutable;
use Laravel\Sanctum\Sanctum;

beforeEach(function (): void {
    $this->me = User::factory()->create();
    Sanctum::actingAs($this->me);
});

function useTimezone(User $user, string $tz): void
{
    UserPreference::query()->updateOrCreate(['user_id' => $user->id], ['language' => 'en', 'timezone' => $tz]);
}

/** @return list<string> */
function doseTimes(string $query): array
{
    return collect(test()->getJson('/api/v1/medications/doses'.$query)->assertOk()->json('data'))->pluck('scheduled_at')->all();
}

/** @return list<string> */
function calendar(Medication $m, string $from, string $to, string $tz): array
{
    return array_map(
        static fn (CarbonImmutable $d): string => $d->toIso8601ZuluString(),
        DoseCalendar::between($m->load('schedule'), CarbonImmutable::parse($from), CarbonImmutable::parse($to), new DateTimeZone($tz)),
    );
}

it("expands today's doses in my timezone, with reminders and logs", function (): void {
    useTimezone($this->me, 'Africa/Cairo'); // UTC+2 in November
    $this->travelTo(CarbonImmutable::parse('2026-11-26T10:00:00Z'));
    $m = Medication::factory()->scheduled(ScheduleType::Daily, ['08:00', '20:00'])->create(['user_id' => $this->me->id]);
    MedicationLog::factory()->create([
        'medication_id' => $m->id,
        'scheduled_at' => '2026-11-26T06:00:00Z',
        'status' => 'taken',
    ]);

    $data = $this->getJson('/api/v1/medications/doses')->assertOk()->json('data');

    expect(array_column($data, 'scheduled_at'))->toBe(['2026-11-26T06:00:00Z', '2026-11-26T18:00:00Z'])
        ->and($data[0]['medication_id'])->toBe($m->id)
        ->and($data[0]['reminder'])->toBeTrue()
        ->and($data[0]['log']['status'])->toBe('taken')
        ->and($data[1]['log'])->toBeNull()
        ->and(json_encode($data))->not->toContain($m->name);
});

it('follows weekdays, every-N-days and the start / end dates', function (): void {
    $weekly = Medication::factory()->scheduled(ScheduleType::Weekly, ['09:00'], [1, 3])->create(['start_date' => '2026-11-01']);
    // Mon 23 → Sun 29 November 2026.
    expect(calendar($weekly, '2026-11-23T00:00:00Z', '2026-11-30T00:00:00Z', 'UTC'))
        ->toBe(['2026-11-23T09:00:00Z', '2026-11-25T09:00:00Z']);

    $everyThird = Medication::factory()->scheduled(ScheduleType::Interval, ['09:00'], null, 3)->create(['start_date' => '2026-11-20']);
    expect(calendar($everyThird, '2026-11-20T00:00:00Z', '2026-11-28T00:00:00Z', 'UTC'))
        ->toBe(['2026-11-20T09:00:00Z', '2026-11-23T09:00:00Z', '2026-11-26T09:00:00Z']);

    $temporary = Medication::factory()->scheduled(ScheduleType::Daily, ['09:00'])->create(['start_date' => '2026-11-24', 'end_date' => '2026-11-25']);
    expect(calendar($temporary, '2026-11-22T00:00:00Z', '2026-11-28T00:00:00Z', 'UTC'))
        ->toBe(['2026-11-24T09:00:00Z', '2026-11-25T09:00:00Z']);
});

it('produces nothing for as-needed medications', function (): void {
    $asNeeded = Medication::factory()->scheduled(ScheduleType::AsNeeded, [])->create();

    expect(calendar($asNeeded, '2026-11-20T00:00:00Z', '2026-11-28T00:00:00Z', 'UTC'))->toBe([]);
});

it('stops doses and reminders as soon as a medication is discontinued or paused (SRS §13.3 #7)', function (): void {
    $this->travelTo(CarbonImmutable::parse('2026-11-26T05:00:00Z'));
    $m = Medication::factory()->scheduled(ScheduleType::Daily, ['08:00', '20:00'])->create(['user_id' => $this->me->id]);
    expect(doseTimes(''))->toHaveCount(2);

    $this->putJson("/api/v1/medications/{$m->id}", ['status' => 'discontinued'])->assertOk();
    expect(doseTimes(''))->toBe([]);

    $m->forceFill(['status' => MedicationStatus::Paused])->save();
    expect(doseTimes(''))->toBe([]);

    $m->forceFill(['status' => MedicationStatus::Active, 'reminders_enabled' => false])->save();
    expect(collect($this->getJson('/api/v1/medications/doses')->json('data'))->pluck('reminder')->unique()->all())->toBe([false]);
});

it('keeps wall-clock times across daylight-saving changes', function (): void {
    $m = Medication::factory()->scheduled(ScheduleType::Daily, ['08:00'])->create(['start_date' => '2026-01-01']);

    // Europe/London springs forward on 29 March 2026: 08:00 GMT → 08:00 BST.
    expect(calendar($m, '2026-03-28T00:00:00Z', '2026-03-31T00:00:00Z', 'Europe/London'))
        ->toBe(['2026-03-28T08:00:00Z', '2026-03-29T07:00:00Z', '2026-03-30T07:00:00Z']);

    // …and falls back on 25 October 2026.
    expect(calendar($m, '2026-10-24T00:00:00Z', '2026-10-27T00:00:00Z', 'Europe/London'))
        ->toBe(['2026-10-24T07:00:00Z', '2026-10-25T08:00:00Z', '2026-10-26T08:00:00Z']);
});

it('never skips or duplicates a dose at a time that DST removes or repeats', function (): void {
    $m = Medication::factory()->scheduled(ScheduleType::Daily, ['01:30'])->create(['start_date' => '2026-01-01']);

    // 01:30 doesn't exist on 29 March in London → moved forward, still exactly one dose.
    expect(calendar($m, '2026-03-29T00:00:00Z', '2026-03-29T23:00:00Z', 'Europe/London'))->toHaveCount(1);
    // 01:30 happens twice on 25 October → one dose.
    expect(calendar($m, '2026-10-24T23:00:00Z', '2026-10-25T23:00:00Z', 'Europe/London'))->toHaveCount(1);
});

it('follows me when my timezone changes', function (): void {
    $this->travelTo(CarbonImmutable::parse('2026-11-26T03:00:00Z'));
    Medication::factory()->scheduled(ScheduleType::Daily, ['08:00'])->create(['user_id' => $this->me->id]);

    useTimezone($this->me, 'Africa/Cairo');
    expect(doseTimes(''))->toBe(['2026-11-26T06:00:00Z']);

    useTimezone($this->me, 'Asia/Dubai');
    expect(doseTimes(''))->toBe(['2026-11-26T04:00:00Z']);
});

it('expands a range of days and validates it', function (): void {
    Medication::factory()->scheduled(ScheduleType::Daily, ['08:00'])->create(['user_id' => $this->me->id, 'start_date' => '2026-11-01']);

    expect(doseTimes('?from=2026-11-10&to=2026-11-12'))->toHaveCount(3);

    $this->getJson('/api/v1/medications/doses?from=2026-11-01&to=2026-12-31')
        ->assertUnprocessable()->assertJsonValidationErrors('to');
    $this->getJson('/api/v1/medications/doses?from=2026-11-12&to=2026-11-10')
        ->assertUnprocessable()->assertJsonValidationErrors('to');
});
