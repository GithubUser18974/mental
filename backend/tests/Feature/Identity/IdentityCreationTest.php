<?php

declare(strict_types=1);

use App\Modules\Auth\Models\User;
use App\Modules\Identity\Actions\EnsureIdentity;
use App\Modules\Identity\Models\AnonymousProfile;
use App\Modules\Identity\Models\UserPreference;
use App\Modules\Identity\Models\UserPrivacySetting;
use App\Modules\Identity\Support\AvatarCatalog;
use App\Modules\Identity\Support\UsernameGenerator;
use App\Modules\Identity\Support\UsernamePolicy;
use Random\Engine\Mt19937;
use Random\Randomizer;

function register(array $headers = []): User
{
    test()->postJson('/api/v1/auth/register', [
        'email' => 'new@example.com',
        'password' => 'calm-river-42',
        'password_confirmation' => 'calm-river-42',
        'age_confirmed' => true,
        'terms_accepted' => true,
    ], $headers)->assertCreated();

    return User::query()->sole();
}

it('creates an anonymous profile, preferences and privacy defaults on registration', function (): void {
    $user = register();

    $profile = AnonymousProfile::query()->where('user_id', $user->id)->sole();
    expect($profile->id)->not->toBe($user->id)
        ->and($profile->username)->toMatch('/^[A-Z][a-z]+[A-Z][a-z]+\d{2,4}$/')
        ->and(UsernamePolicy::isWellFormed($profile->username))->toBeTrue()
        ->and(AvatarCatalog::isValid($profile->avatar))->toBeTrue()
        ->and($profile->bio)->toBeNull()
        ->and($profile->setup_completed_at)->toBeNull();

    // The pseudonym is never derived from the email.
    expect(mb_strtolower($profile->username))->not->toContain('new');

    $preferences = UserPreference::query()->where('user_id', $user->id)->sole();
    expect($preferences->language)->toBe('en')->and($preferences->timezone)->toBe('UTC');

    $privacy = UserPrivacySetting::query()->where('user_id', $user->id)->sole();
    expect($privacy->profile_visibility->value)->toBe('public')
        ->and($privacy->follow_policy->value)->toBe('everyone')
        ->and($privacy->analytics_consent)->toBeFalse();
});

it('uses the request language as the initial language preference', function (): void {
    $user = register(['Accept-Language' => 'ar']);

    expect(UserPreference::query()->where('user_id', $user->id)->value('language'))->toBe('ar');
});

it('retries when a generated username is already taken', function (): void {
    $seeded = static fn (): UsernameGenerator => new UsernameGenerator(new Randomizer(new Mt19937(7)));

    // Pre-take the first name the seeded generator will produce.
    $firstName = $seeded()->generate();
    AnonymousProfile::factory()->create(['username' => $firstName]);

    app()->instance(UsernameGenerator::class, $seeded());
    $user = User::factory()->create();

    $profile = app(EnsureIdentity::class)($user)->profile;

    expect($profile->username)->not->toBe($firstName)
        ->and(UsernamePolicy::isWellFormed($profile->username))->toBeTrue();
});

it('is idempotent and never creates a second profile', function (): void {
    $user = User::factory()->create();

    $first = app(EnsureIdentity::class)($user);
    $second = app(EnsureIdentity::class)($user);

    expect($second->profile->id)->toBe($first->profile->id)
        ->and(AnonymousProfile::query()->where('user_id', $user->id)->count())->toBe(1);
});

it('rolls back the whole registration if the identity cannot be created', function (): void {
    app()->bind(EnsureIdentity::class, static fn () => throw new RuntimeException('boom'));

    $this->postJson('/api/v1/auth/register', [
        'email' => 'new@example.com',
        'password' => 'calm-river-42',
        'password_confirmation' => 'calm-river-42',
        'age_confirmed' => true,
        'terms_accepted' => true,
    ])->assertInternalServerError();

    expect(User::query()->count())->toBe(0);
});
