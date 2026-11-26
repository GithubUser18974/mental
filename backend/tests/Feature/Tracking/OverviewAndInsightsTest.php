<?php

declare(strict_types=1);

use App\Modules\Auth\Models\User;
use App\Modules\Tracking\Actions\ComputeInsights;
use App\Modules\Tracking\Jobs\RefreshInsights;
use App\Modules\Tracking\Models\MoodEntry;
use App\Modules\Tracking\Models\SleepEntry;
use App\Modules\Tracking\Models\SymptomCategory;
use App\Modules\Tracking\Models\SymptomEntry;
use App\Modules\Tracking\Models\TrackingInsight;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Queue;
use Laravel\Sanctum\Sanctum;

beforeEach(function (): void {
    $this->travelTo(now()->setTime(12, 0));
    $this->me = User::factory()->create();
    Sanctum::actingAs($this->me);
});

/** One check-in per day for the given day offsets (0 = today). */
function checkIns(User $user, array $daysAgo, array $attributes = []): void
{
    foreach ($daysAgo as $days) {
        MoodEntry::factory()->create([
            'user_id' => $user->id,
            'recorded_at' => now()->subDays($days),
            ...$attributes,
        ]);
    }
}

describe('overview', function (): void {
    it('summarizes my latest check-in, streak, last 7 days, averages and symptoms', function (): void {
        checkIns($this->me, [0, 1, 2], ['mood' => 'good', 'score' => 7, 'stress' => 4]);
        checkIns($this->me, [5], ['mood' => 'sad', 'score' => 3, 'stress' => 8]);
        SleepEntry::factory()->create(['user_id' => $this->me->id, 'duration_minutes' => 480, 'quality' => 7, 'recorded_at' => now()]);
        $anxiety = SymptomCategory::query()->where('slug', 'anxiety')->value('id');
        SymptomEntry::factory()->count(2)->create(['user_id' => $this->me->id, 'category_id' => $anxiety, 'severity' => 6]);

        // Another member's data never leaks into my overview.
        checkIns(User::factory()->create(), [0, 1, 2, 3, 4, 5, 6], ['score' => 1]);

        $data = $this->getJson('/api/v1/tracking/overview')->assertOk()->json('data');

        expect($data['latest']['mood'])->toBe('good')
            ->and($data['streak_days'])->toBe(3)
            ->and($data['total_check_ins'])->toBe(4)
            ->and($data['last_7_days'])->toHaveCount(7)
            ->and(end($data['last_7_days']))->toEqual(['date' => now()->format('Y-m-d'), 'mood' => 'good', 'score' => 7])
            ->and($data['last_7_days'][3]['mood'])->toBeNull()
            ->and($data['averages']['last_7_days']['score'])->toEqual(6)
            ->and($data['averages']['last_7_days']['sleep_hours'])->toEqual(8)
            ->and($data['top_symptoms'][0]['category']['slug'])->toBe('anxiety')
            ->and($data['top_symptoms'][0]['count'])->toBe(2);
    });

    it('is empty but well-formed for a new member', function (): void {
        $this->getJson('/api/v1/tracking/overview')
            ->assertOk()
            ->assertJsonPath('data.latest', null)
            ->assertJsonPath('data.streak_days', 0)
            ->assertJsonPath('data.total_check_ins', 0)
            ->assertJsonPath('data.top_symptoms', []);
    });

    it('keeps the streak alive until the day is over', function (): void {
        checkIns($this->me, [1, 2]);

        $this->getJson('/api/v1/tracking/overview')->assertJsonPath('data.streak_days', 2);
    });
});

describe('insights', function (): void {
    it('queues a refresh (ids only) whenever entries change', function (): void {
        Queue::fake();

        $id = $this->postJson('/api/v1/tracking/moods', ['mood' => 'good', 'notes' => 'private'])->json('data.id');
        $this->deleteJson("/api/v1/tracking/moods/{$id}")->assertNoContent();

        Queue::assertPushed(RefreshInsights::class, fn (RefreshInsights $job): bool => $job->userId === $this->me->id);
        Queue::assertPushed(RefreshInsights::class, function (RefreshInsights $job): bool {
            expect(serialize($job))->not->toContain('private');

            return true;
        });
    });

    it('reports trends, frequent mood and sleep patterns once there is enough data', function (): void {
        checkIns($this->me, [1, 2, 3, 4], ['mood' => 'good', 'score' => 7, 'stress' => 3]);
        checkIns($this->me, [16, 17, 18, 19], ['mood' => 'sad', 'score' => 4, 'stress' => 7]);
        foreach ([1, 2, 3] as $d) {
            SleepEntry::factory()->create(['user_id' => $this->me->id, 'duration_minutes' => 480, 'recorded_at' => now()->subDays($d)]);
        }
        foreach ([16, 17, 18] as $d) {
            SleepEntry::factory()->create(['user_id' => $this->me->id, 'duration_minutes' => 300, 'recorded_at' => now()->subDays($d)]);
        }

        $keys = array_column(app(ComputeInsights::class)($this->me->id), 'key');

        expect($keys)->toContain('mood_trend_up', 'stress_trend_down', 'frequent_mood', 'sleep_mood', 'milestone_first');
    });

    it('says nothing about trends from too little data', function (): void {
        checkIns($this->me, [1, 20], ['score' => 9]);

        expect(array_column(app(ComputeInsights::class)($this->me->id), 'key'))->toBe(['milestone_first']);
    });

    it('celebrates a 7-day check-in streak without implying recovery', function (): void {
        checkIns($this->me, [0, 1, 2, 3, 4, 5, 6]);

        expect(array_column(app(ComputeInsights::class)($this->me->id), 'key'))->toContain('milestone_streak');
    });

    it('returns readable, non-diagnostic observations with a disclaimer, in my language', function (string $lang): void {
        checkIns($this->me, [1, 2, 3, 4], ['mood' => 'very_good', 'score' => 8, 'stress' => 2]);
        checkIns($this->me, [16, 17, 18, 19], ['mood' => 'sad', 'score' => 3, 'stress' => 8]);
        RefreshInsights::dispatchSync($this->me->id);

        $response = $this->getJson('/api/v1/tracking/insights', ['Accept-Language' => $lang])
            ->assertOk()
            ->assertJsonPath('data.refreshing', false);

        $text = strtolower(implode(' ', array_column($response->json('data.items'), 'text')));
        expect($response->json('data.items'))->not->toBeEmpty()
            ->and($response->json('data.disclaimer'))->not->toBeEmpty()
            ->and($text)->not->toContain(':recent')->not->toContain(':mood');

        if ($lang === 'en') {
            expect($text)->toContain('very good')
                ->not->toContain('diagnos')->not->toContain('disorder')->not->toContain('because')
                ->not->toContain('caused')->not->toContain('treatment')->not->toContain('recover')
                ->and($response->json('data.disclaimer'))->toContain('aren’t a medical assessment');
        }
    })->with(['en', 'ar']);

    it('stores insights encrypted and only for their owner', function (): void {
        checkIns($this->me, [1]);
        RefreshInsights::dispatchSync($this->me->id);

        expect(DB::table('tracking_insights')->value('items'))->not->toContain('milestone_first');

        $other = User::factory()->create();
        forgetAuth();
        Sanctum::actingAs($other);
        Queue::fake();
        $this->getJson('/api/v1/tracking/insights')
            ->assertOk()
            ->assertJsonPath('data.items', [])
            ->assertJsonPath('data.refreshing', true);
        expect(TrackingInsight::query()->find($other->id))->toBeNull();
    });
});
