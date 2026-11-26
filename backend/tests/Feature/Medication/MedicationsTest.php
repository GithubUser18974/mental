<?php

declare(strict_types=1);

use App\Modules\Auth\Models\User;
use App\Modules\Medication\Enums\ScheduleType;
use App\Modules\Medication\Models\Medication;
use App\Modules\Medication\Models\MedicationLog;
use Illuminate\Support\Facades\DB;
use Laravel\Sanctum\Sanctum;

beforeEach(function (): void {
    $this->me = User::factory()->create();
    Sanctum::actingAs($this->me);
});

/** @param  array<string, mixed>  $overrides */
function medicationPayload(array $overrides = []): array
{
    return [
        'name' => 'Sertraline',
        'dosage' => '50',
        'unit' => 'mg',
        'start_date' => now()->subDays(10)->toDateString(),
        'schedule' => ['type' => 'daily', 'times' => ['20:00', '08:00']],
        ...$overrides,
    ];
}

it('requires authentication', function (string $method, string $uri): void {
    forgetAuth();

    $this->withHeader('Authorization', 'Bearer invalid')->json($method, $uri)->assertUnauthorized();
})->with([
    ['GET', '/api/v1/medications'],
    ['POST', '/api/v1/medications'],
    ['GET', '/api/v1/medications/doses'],
]);

it('adds a medication with a schedule; sensitive fields are encrypted at rest', function (): void {
    $this->postJson('/api/v1/medications', medicationPayload([
        'instructions' => 'With food',
        'clinician' => 'Dr. Example',
        'notes' => 'Started after a hard winter',
        'end_date' => now()->addMonths(3)->toDateString(),
    ]))
        ->assertCreated()
        ->assertJsonPath('message', 'Your medication has been added.')
        ->assertJsonPath('data.name', 'Sertraline')
        ->assertJsonPath('data.dosage', '50')
        ->assertJsonPath('data.unit', 'mg')
        ->assertJsonPath('data.status', 'active')
        ->assertJsonPath('data.is_current', true)
        ->assertJsonPath('data.reminders_enabled', true)
        ->assertJsonPath('data.schedule', ['type' => 'daily', 'times' => ['08:00', '20:00'], 'days_of_week' => null, 'interval_days' => null]);

    $row = (array) DB::table('medications')->first();
    foreach (['name' => 'Sertraline', 'instructions' => 'With food', 'clinician' => 'Dr. Example', 'notes' => 'hard winter', 'dosage' => '50'] as $column => $plain) {
        expect((string) $row[$column])->not->toContain($plain);
    }
    expect(Medication::query()->sole()->user_id)->toBe($this->me->id);
});

it('supports every schedule type (FR-MED-002)', function (array $schedule): void {
    $this->postJson('/api/v1/medications', medicationPayload(['schedule' => $schedule]))
        ->assertCreated()
        ->assertJsonPath('data.schedule.type', $schedule['type']);
})->with([
    'once daily' => [['type' => 'daily', 'times' => ['09:00']]],
    'several times a day' => [['type' => 'daily', 'times' => ['08:00', '14:00', '20:00']]],
    'specific weekdays' => [['type' => 'weekly', 'times' => ['08:00'], 'days_of_week' => [1, 3, 5]]],
    'every 3 days' => [['type' => 'interval', 'times' => ['08:00'], 'interval_days' => 3]],
    'as needed' => [['type' => 'as_needed']],
]);

it('rejects invalid medication records (SRS §13.3 #9)', function (array $overrides, array $errors): void {
    $this->postJson('/api/v1/medications', medicationPayload($overrides))
        ->assertUnprocessable()
        ->assertJsonValidationErrors($errors);

    expect(Medication::query()->count())->toBe(0);
})->with([
    'missing required' => [['name' => null, 'dosage' => null, 'unit' => null, 'start_date' => null, 'schedule' => null], ['name', 'dosage', 'unit', 'start_date', 'schedule']],
    'unknown unit' => [['unit' => 'spoonful'], ['unit']],
    'dosage not a number' => [['dosage' => 'a lot'], ['dosage']],
    'ends before it starts' => [['end_date' => now()->subDays(20)->toDateString()], ['end_date']],
    'bad time' => [['schedule' => ['type' => 'daily', 'times' => ['25:00']]], ['schedule.times.0']],
    'duplicate times' => [['schedule' => ['type' => 'daily', 'times' => ['08:00', '08:00']]], ['schedule.times.0']],
    'no times' => [['schedule' => ['type' => 'daily', 'times' => []]], ['schedule.times']],
    'weekly without days' => [['schedule' => ['type' => 'weekly', 'times' => ['08:00']]], ['schedule.days_of_week']],
    'bad weekday' => [['schedule' => ['type' => 'weekly', 'times' => ['08:00'], 'days_of_week' => [8]]], ['schedule.days_of_week.0']],
    'interval without days' => [['schedule' => ['type' => 'interval', 'times' => ['08:00']]], ['schedule.interval_days']],
    'as needed with times' => [['schedule' => ['type' => 'as_needed', 'times' => ['08:00']]], ['schedule.times']],
    'status on create' => [['status' => 'discontinued'], ['status']],
]);

it('lists current and past medications separately (FR-MED-006)', function (): void {
    $current = Medication::factory()->scheduled()->create(['user_id' => $this->me->id]);
    $stopped = Medication::factory()->scheduled()->discontinued()->create(['user_id' => $this->me->id]);
    $ended = Medication::factory()->scheduled()->create([
        'user_id' => $this->me->id,
        'start_date' => now()->subDays(30)->toDateString(),
        'end_date' => now()->subDays(2)->toDateString(),
    ]);
    Medication::factory()->scheduled()->create(); // someone else's

    $ids = fn (string $q): array => collect($this->getJson('/api/v1/medications'.$q)->assertOk()->json('data'))->pluck('id')->sort()->values()->all();

    expect($ids(''))->toBe([$current->id])
        ->and($ids('?status=past'))->toBe(collect([$stopped->id, $ended->id])->sort()->values()->all())
        ->and($ids('?status=all'))->toHaveCount(3);
});

it('edits partially, keeping the schedule unless one is sent', function (): void {
    $id = $this->postJson('/api/v1/medications', medicationPayload())->json('data.id');

    $this->putJson("/api/v1/medications/{$id}", ['dosage' => '75', 'reminders_enabled' => false])
        ->assertOk()
        ->assertJsonPath('data.dosage', '75')
        ->assertJsonPath('data.reminders_enabled', false)
        ->assertJsonPath('data.schedule.times', ['08:00', '20:00']);

    $this->putJson("/api/v1/medications/{$id}", ['schedule' => ['type' => 'weekly', 'times' => ['09:30'], 'days_of_week' => [7, 1]]])
        ->assertOk()
        ->assertJsonPath('data.schedule', ['type' => 'weekly', 'times' => ['09:30'], 'days_of_week' => [1, 7], 'interval_days' => null]);
});

it('discontinues and reactivates', function (): void {
    $id = $this->postJson('/api/v1/medications', medicationPayload())->json('data.id');

    $this->putJson("/api/v1/medications/{$id}", ['status' => 'discontinued'])
        ->assertOk()
        ->assertJsonPath('data.status', 'discontinued')
        ->assertJsonPath('data.is_current', false);
    expect(Medication::query()->find($id)?->discontinued_at)->not->toBeNull();

    $this->putJson("/api/v1/medications/{$id}", ['status' => 'active'])->assertOk();
    expect(Medication::query()->find($id)?->discontinued_at)->toBeNull();
});

it('deletes a medication with everything recorded for it', function (): void {
    $medication = Medication::factory()->scheduled()->create(['user_id' => $this->me->id]);
    MedicationLog::factory()->create(['medication_id' => $medication->id]);

    $this->deleteJson("/api/v1/medications/{$medication->id}")->assertNoContent();

    expect(DB::table('medications')->count())->toBe(0)
        ->and(DB::table('medication_schedules')->count())->toBe(0)
        ->and(DB::table('medication_logs')->count())->toBe(0);
});

it("never exposes another member's medications (SRS §13.3 #1)", function (): void {
    $theirs = Medication::factory()->scheduled()->create();
    $log = MedicationLog::factory()->create(['medication_id' => $theirs->id]);

    $this->getJson("/api/v1/medications/{$theirs->id}")->assertNotFound();
    $this->putJson("/api/v1/medications/{$theirs->id}", ['dosage' => '1'])->assertNotFound();
    $this->deleteJson("/api/v1/medications/{$theirs->id}")->assertNotFound();
    $this->getJson("/api/v1/medications/{$theirs->id}/logs")->assertNotFound();
    $this->postJson("/api/v1/medications/{$theirs->id}/logs", ['status' => 'skipped'])->assertNotFound();
    $this->deleteJson("/api/v1/medications/{$theirs->id}/logs/{$log->id}")->assertNotFound();
    $this->getJson("/api/v1/medications/{$theirs->id}/experiences")->assertNotFound();
    $this->postJson("/api/v1/medications/{$theirs->id}/experiences", ['kind' => 'general', 'description' => 'Hi'])->assertNotFound();
    expect($this->getJson('/api/v1/medications/doses')->json('data'))->toBe([])
        ->and(Medication::query()->find($theirs->id)?->dosage)->not->toBe('1');
});

describe('intake logs (FR-MED-004)', function (): void {
    beforeEach(function (): void {
        $this->medication = Medication::factory()->scheduled(ScheduleType::Daily, ['08:00'])->create(['user_id' => $this->me->id]);
    });

    it('records a taken dose, and logging the same dose again updates it', function (): void {
        $scheduled = now()->setTime(8, 0)->toIso8601String();

        $this->postJson("/api/v1/medications/{$this->medication->id}/logs", ['status' => 'skipped', 'scheduled_at' => $scheduled])
            ->assertCreated()
            ->assertJsonPath('data.status', 'skipped')
            ->assertJsonPath('data.taken_at', null);

        $this->postJson("/api/v1/medications/{$this->medication->id}/logs", [
            'status' => 'delayed',
            'scheduled_at' => $scheduled,
            'taken_at' => now()->setTime(9, 15)->toIso8601String(),
            'notes' => 'Forgot until after breakfast',
        ])
            ->assertOk()
            ->assertJsonPath('data.status', 'delayed');

        expect(MedicationLog::query()->count())->toBe(1)
            ->and(DB::table('medication_logs')->value('notes'))->not->toContain('breakfast');
    });

    it('records as-needed doses without a schedule time', function (): void {
        $this->postJson("/api/v1/medications/{$this->medication->id}/logs", ['status' => 'taken', 'taken_at' => now()->toIso8601String()])
            ->assertCreated()
            ->assertJsonPath('data.scheduled_at', null);
    });

    it('validates intake logs', function (array $payload, string $field): void {
        $this->postJson("/api/v1/medications/{$this->medication->id}/logs", $payload)
            ->assertUnprocessable()
            ->assertJsonValidationErrors($field);
    })->with([
        'unknown status' => [['status' => 'forgot'], 'status'],
        'taken without time' => [['status' => 'taken'], 'taken_at'],
        'skipped with time' => [['status' => 'skipped', 'taken_at' => '2026-11-26T08:00:00Z'], 'taken_at'],
        'taken in the future' => [['status' => 'taken', 'taken_at' => now()->addDay()->toIso8601String()], 'taken_at'],
    ]);

    it('lists intake history newest first and deletes a log', function (): void {
        $old = MedicationLog::factory()->create(['medication_id' => $this->medication->id, 'scheduled_at' => now()->subDays(2)]);
        $new = MedicationLog::factory()->create(['medication_id' => $this->medication->id, 'scheduled_at' => now()->subDay()]);

        expect(collect($this->getJson("/api/v1/medications/{$this->medication->id}/logs")->json('data'))->pluck('id')->all())
            ->toBe([$new->id, $old->id]);

        $this->deleteJson("/api/v1/medications/{$this->medication->id}/logs/{$old->id}")->assertNoContent();
        expect(MedicationLog::query()->count())->toBe(1);
    });
});

describe('experiences (FR-MED-005)', function (): void {
    it('records private experiences, dated today by default', function (): void {
        $medication = Medication::factory()->scheduled()->create(['user_id' => $this->me->id]);

        $this->postJson("/api/v1/medications/{$medication->id}/experiences", ['kind' => 'side_effect', 'description' => 'Felt dizzy in the morning'])
            ->assertCreated()
            ->assertJsonPath('data.kind', 'side_effect')
            ->assertJsonPath('data.observed_on', now()->toDateString());

        expect(DB::table('medication_experiences')->value('description'))->not->toContain('dizzy');

        $id = $this->getJson("/api/v1/medications/{$medication->id}/experiences")->assertJsonCount(1, 'data')->json('data.0.id');
        $this->deleteJson("/api/v1/medications/{$medication->id}/experiences/{$id}")->assertNoContent();
    });

    it('validates experiences', function (): void {
        $medication = Medication::factory()->scheduled()->create(['user_id' => $this->me->id]);

        $this->postJson("/api/v1/medications/{$medication->id}/experiences", ['kind' => 'miracle', 'description' => ''])
            ->assertUnprocessable()
            ->assertJsonValidationErrors(['kind', 'description']);
    });
});
