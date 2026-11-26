<?php

declare(strict_types=1);

use App\Modules\Auth\Models\User;
use App\Modules\Identity\Models\UserPreference;
use App\Modules\Tracking\Models\MoodEntry;
use App\Modules\Tracking\Models\SleepEntry;
use App\Modules\Tracking\Models\SymptomCategory;
use App\Modules\Tracking\Models\SymptomEntry;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Laravel\Sanctum\Sanctum;

beforeEach(function (): void {
    $this->me = User::factory()->create();
    Sanctum::actingAs($this->me);
});

function actAsUser(User $user): void
{
    forgetAuth();
    Sanctum::actingAs($user);
}

it('requires authentication', function (string $method, string $uri): void {
    forgetAuth();

    $this->withHeader('Authorization', 'Bearer invalid')->json($method, $uri)->assertUnauthorized();
})->with([
    ['GET', '/api/v1/tracking/moods'],
    ['POST', '/api/v1/tracking/moods'],
    ['GET', '/api/v1/tracking/symptoms'],
    ['POST', '/api/v1/tracking/sleep'],
    ['GET', '/api/v1/tracking/overview'],
    ['GET', '/api/v1/tracking/insights'],
    ['GET', '/api/v1/tracking/symptom-categories'],
]);

describe('check-ins (moods)', function (): void {
    it('saves a check-in with only a mood (every scale is optional)', function (): void {
        $this->postJson('/api/v1/tracking/moods', ['mood' => 'good'])
            ->assertCreated()
            ->assertJsonPath('message', 'Your check-in has been saved.')
            ->assertJsonPath('data.mood', 'good')
            ->assertJsonPath('data.score', null)
            ->assertJsonPath('data.notes', null);

        expect(MoodEntry::query()->sole()->user_id)->toBe($this->me->id);
    });

    it('saves a full check-in in the shape of SRS §8.9', function (): void {
        $this->postJson('/api/v1/tracking/moods', [
            'mood' => 'sad',
            'score' => 4,
            'anxiety' => 7,
            'stress' => 8,
            'energy' => 3,
            'notes' => '  Hard day at work.  ',
            'recorded_at' => '2026-11-12T10:00:00+02:00',
        ])
            ->assertCreated()
            ->assertJsonPath('data.score', 4)
            ->assertJsonPath('data.anxiety', 7)
            ->assertJsonPath('data.notes', 'Hard day at work.')
            ->assertJsonPath('data.recorded_at', '2026-11-12T08:00:00Z');
    });

    it('rejects invalid mood scores (SRS §13.3 #10)', function (array $payload, string $field): void {
        $this->postJson('/api/v1/tracking/moods', ['mood' => 'good', ...$payload])
            ->assertUnprocessable()
            ->assertJsonValidationErrors($field);

        expect(MoodEntry::query()->count())->toBe(0);
    })->with([
        'score 0' => [['score' => 0], 'score'],
        'score 11' => [['score' => 11], 'score'],
        'score text' => [['score' => 'high'], 'score'],
        'anxiety 12' => [['anxiety' => 12], 'anxiety'],
        'unknown mood' => [['mood' => 'ecstatic'], 'mood'],
        'missing mood' => [['mood' => null], 'mood'],
        'future' => [['recorded_at' => now()->addDay()->toIso8601String()], 'recorded_at'],
        'notes too long' => [['notes' => str_repeat('a', 2001)], 'notes'],
    ]);

    it('lists my check-ins newest first, filtered by local days in my timezone', function (): void {
        UserPreference::query()->create(['user_id' => $this->me->id, 'language' => 'en', 'timezone' => 'Africa/Cairo']);
        // 23:30 Cairo time on Nov 10 is 21:30 UTC — still Nov 10 locally.
        $late = MoodEntry::factory()->create(['user_id' => $this->me->id, 'recorded_at' => '2026-11-10T21:30:00Z']);
        $next = MoodEntry::factory()->create(['user_id' => $this->me->id, 'recorded_at' => '2026-11-11T08:00:00Z']);
        MoodEntry::factory()->create(['user_id' => $this->me->id, 'recorded_at' => '2026-11-09T08:00:00Z']);

        $ids = fn (string $q): array => collect($this->getJson('/api/v1/tracking/moods'.$q)->assertOk()->json('data'))->pluck('id')->all();

        expect($ids('?from=2026-11-10&to=2026-11-10'))->toBe([$late->id])
            ->and($ids('?from=2026-11-10'))->toBe([$next->id, $late->id])
            ->and($ids(''))->toHaveCount(3);

        $this->getJson('/api/v1/tracking/moods?from=2026-11-12&to=2026-11-01')
            ->assertUnprocessable()->assertJsonValidationErrors('to');
    });

    it('edits only the given fields, and deletes for good', function (): void {
        $entry = MoodEntry::factory()->create(['user_id' => $this->me->id, 'mood' => 'sad', 'score' => 3, 'stress' => 9]);

        $this->putJson("/api/v1/tracking/moods/{$entry->id}", ['mood' => 'neutral', 'score' => 5])
            ->assertOk()
            ->assertJsonPath('data.mood', 'neutral')
            ->assertJsonPath('data.score', 5)
            ->assertJsonPath('data.stress', 9);

        $this->deleteJson("/api/v1/tracking/moods/{$entry->id}")->assertNoContent();
        expect(DB::table('mood_entries')->where('id', $entry->id)->exists())->toBeFalse();
    });

    it('keeps private notes encrypted at rest', function (): void {
        $this->postJson('/api/v1/tracking/moods', ['mood' => 'sad', 'notes' => 'SECRET-NOTE-123'])->assertCreated();

        $raw = DB::table('mood_entries')->value('notes');
        expect($raw)->not->toContain('SECRET-NOTE-123')
            ->and(MoodEntry::query()->sole()->notes)->toBe('SECRET-NOTE-123');
    });
});

it("never exposes another member's entries (SRS §13.3 #3)", function (string $model, string $path): void {
    $other = User::factory()->create();
    $entry = $model::factory()->create(['user_id' => $other->id]);

    $this->getJson("/api/v1/tracking/{$path}/{$entry->id}")->assertNotFound();
    $this->putJson("/api/v1/tracking/{$path}/{$entry->id}", [])->assertNotFound();
    $this->deleteJson("/api/v1/tracking/{$path}/{$entry->id}")->assertNotFound();
    expect($this->getJson("/api/v1/tracking/{$path}")->json('data'))->toBe([])
        ->and($model::query()->find($entry->id))->not->toBeNull();
})->with([
    'mood' => [MoodEntry::class, 'moods'],
    'symptom' => [SymptomEntry::class, 'symptoms'],
    'sleep' => [SleepEntry::class, 'sleep'],
]);

it('404s unknown and malformed ids', function (): void {
    $this->getJson('/api/v1/tracking/moods/'.Str::uuid())->assertNotFound();
    $this->getJson('/api/v1/tracking/moods/not-a-uuid')->assertNotFound();
});

describe('symptoms', function (): void {
    it('lists the active symptom categories, localized', function (): void {
        SymptomCategory::query()->where('slug', 'sadness')->update(['is_active' => false]);

        $this->getJson('/api/v1/tracking/symptom-categories')
            ->assertOk()
            ->assertJsonCount(7, 'data')
            ->assertJsonPath('data.0', ['slug' => 'anxiety', 'name' => 'Anxiety', 'icon' => 'psychology_alt']);

        $this->getJson('/api/v1/tracking/symptom-categories', ['Accept-Language' => 'ar'])
            ->assertJsonPath('data.0.name', 'القلق');
    });

    it('records a symptom with severity, duration and notes', function (): void {
        $this->postJson('/api/v1/tracking/symptoms', [
            'category' => 'restlessness',
            'severity' => 6,
            'duration_minutes' => 90,
            'notes' => 'Before the meeting',
        ])
            ->assertCreated()
            ->assertJsonPath('data.category.slug', 'restlessness')
            ->assertJsonPath('data.severity', 6)
            ->assertJsonPath('data.duration_minutes', 90);

        expect(DB::table('symptom_entries')->value('notes'))->not->toContain('Before the meeting');
    });

    it('validates symptoms', function (array $payload, array $errors): void {
        SymptomCategory::query()->where('slug', 'sadness')->update(['is_active' => false]);

        $this->postJson('/api/v1/tracking/symptoms', $payload)
            ->assertUnprocessable()
            ->assertJsonValidationErrors($errors);
    })->with([
        'missing' => [[], ['category', 'severity']],
        'inactive category' => [['category' => 'sadness', 'severity' => 3], ['category']],
        'severity 0' => [['category' => 'anxiety', 'severity' => 0], ['severity']],
        'duration too long' => [['category' => 'anxiety', 'severity' => 3, 'duration_minutes' => 20000], ['duration_minutes']],
    ]);
});

describe('sleep', function (): void {
    it('records sleep', function (): void {
        $this->postJson('/api/v1/tracking/sleep', ['duration_minutes' => 450, 'quality' => 6])
            ->assertCreated()
            ->assertJsonPath('data.duration_minutes', 450)
            ->assertJsonPath('data.quality', 6);
    });

    it('validates sleep', function (array $payload, string $field): void {
        $this->postJson('/api/v1/tracking/sleep', $payload)
            ->assertUnprocessable()
            ->assertJsonValidationErrors($field);
    })->with([
        'missing duration' => [['quality' => 5], 'duration_minutes'],
        'over 24h' => [['duration_minutes' => 1441], 'duration_minutes'],
        'quality 11' => [['duration_minutes' => 400, 'quality' => 11], 'quality'],
    ]);
});
