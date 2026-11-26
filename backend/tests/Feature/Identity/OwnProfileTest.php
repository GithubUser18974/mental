<?php

declare(strict_types=1);

use App\Modules\Auth\Models\User;
use App\Modules\Identity\Models\AnonymousProfile;
use App\Modules\Identity\Support\UsernamePolicy;
use Laravel\Sanctum\Sanctum;

function signInWithProfile(array $profile = []): AnonymousProfile
{
    $p = AnonymousProfile::factory()->create($profile);
    Sanctum::actingAs($p->user);

    return $p;
}

it('requires authentication', function (string $method, string $uri): void {
    $this->json($method, $uri)->assertUnauthorized();
})->with([
    ['GET', '/api/v1/profile'],
    ['PUT', '/api/v1/profile'],
    ['PUT', '/api/v1/profile/preferences'],
    ['PUT', '/api/v1/profile/privacy'],
    ['GET', '/api/v1/profile/username-availability?username=abc'],
    ['GET', '/api/v1/profile/username-suggestions'],
    ['GET', '/api/v1/profile/avatar-options'],
    ['GET', '/api/v1/profiles/SomeoneElse'],
]);

it('shows the owner their profile, preferences and privacy — without account credentials', function (): void {
    $profile = signInWithProfile(['username' => 'QuietRiver12', 'avatar' => 'lotus-lavender']);

    $response = $this->getJson('/api/v1/profile')
        ->assertOk()
        ->assertJsonPath('data.profile.id', $profile->id)
        ->assertJsonPath('data.profile.username', 'QuietRiver12')
        ->assertJsonPath('data.profile.avatar', 'lotus-lavender')
        ->assertJsonPath('data.profile.setup_completed', false)
        ->assertJsonPath('data.profile.username_change_available_at', null)
        ->assertJsonPath('data.preferences', ['language' => 'en', 'timezone' => 'UTC'])
        ->assertJsonPath('data.privacy', [
            'profile_visibility' => 'public',
            'follow_policy' => 'everyone',
            'analytics_consent' => false,
        ]);

    expect($response->getContent())
        ->not->toContain($profile->user->email)
        ->not->toContain($profile->user_id);
});

it('creates the identity on demand for an account that has none', function (): void {
    Sanctum::actingAs(User::factory()->create());

    $this->getJson('/api/v1/profile')->assertOk()->assertJsonPath('data.profile.setup_completed', false);

    expect(AnonymousProfile::query()->count())->toBe(1);
});

it('updates username, avatar and bio and completes setup', function (): void {
    $profile = signInWithProfile();

    $this->putJson('/api/v1/profile', [
        'username' => 'GentleWillow',
        'avatar' => 'moon-sky',
        'bio' => '  Taking it one day at a time.  ',
    ])
        ->assertOk()
        ->assertJsonPath('message', 'Your profile has been updated.')
        ->assertJsonPath('data.profile.username', 'GentleWillow')
        ->assertJsonPath('data.profile.avatar', 'moon-sky')
        ->assertJsonPath('data.profile.bio', 'Taking it one day at a time.')
        ->assertJsonPath('data.profile.setup_completed', true);

    expect($profile->fresh()?->setup_completed_at)->not->toBeNull()
        ->and($profile->fresh()?->username_changed_at)->toBeNull('onboarding change must not start the cooldown');
});

it('accepts partial updates and clears the bio with an empty string', function (): void {
    signInWithProfile(['username' => 'StillMeadow7', 'bio' => 'old']);

    $this->putJson('/api/v1/profile', ['bio' => ''])
        ->assertOk()
        ->assertJsonPath('data.profile.username', 'StillMeadow7')
        ->assertJsonPath('data.profile.bio', null);
});

it('validates profile fields', function (array $payload, string $field, ?string $message): void {
    signInWithProfile();
    AnonymousProfile::factory()->create(['username' => 'TakenName']);

    $response = $this->putJson('/api/v1/profile', $payload)->assertUnprocessable()->assertJsonValidationErrors($field);

    if ($message !== null) {
        $response->assertJsonPath("errors.{$field}.0", $message);
    }
})->with([
    'too short' => [['username' => 'ab'], 'username', 'Usernames are 3–20 characters, start with a letter, and use only letters, numbers and underscores.'],
    'starts with digit' => [['username' => '1calm'], 'username', null],
    'looks like an email' => [['username' => 'me@example.com'], 'username', null],
    'has spaces' => [['username' => 'calm river'], 'username', null],
    'reserved' => [['username' => 'Admin'], 'username', 'This username isn’t available. Please choose another one.'],
    'impersonation fragment' => [['username' => 'Y_Support_Team'], 'username', null],
    'taken (case-insensitive)' => [['username' => 'takenname'], 'username', 'This username is already taken.'],
    'unknown avatar' => [['avatar' => 'selfie-photo'], 'avatar', null],
    'bio too long' => [['bio' => str_repeat('a', 301)], 'bio', null],
]);

it('lets the owner keep or re-case their own username', function (): void {
    signInWithProfile(['username' => 'calmriver5']);

    $this->putJson('/api/v1/profile', ['username' => 'CalmRiver5'])
        ->assertOk()
        ->assertJsonPath('data.profile.username', 'CalmRiver5');
});

it('limits username changes after setup to once per cooldown period', function (): void {
    $this->freezeSecond();
    $profile = signInWithProfile(['username' => 'FirstName1']);
    $profile->forceFill(['setup_completed_at' => now()])->save();

    $this->putJson('/api/v1/profile', ['username' => 'SecondName2'])->assertOk();

    $availableAt = now()->addDays(UsernamePolicy::CHANGE_COOLDOWN_DAYS);
    $this->getJson('/api/v1/profile')
        ->assertJsonPath('data.profile.username_change_available_at', $availableAt->utc()->format('Y-m-d\TH:i:s\Z'));

    $this->putJson('/api/v1/profile', ['username' => 'ThirdName3'])
        ->assertUnprocessable()
        ->assertJsonPath('errors.username.0', 'You can change your username again on '.$availableAt->format('Y-m-d').'.');

    // Other fields can still be edited during the cooldown.
    $this->putJson('/api/v1/profile', ['bio' => 'still me'])->assertOk();

    $this->travel(UsernamePolicy::CHANGE_COOLDOWN_DAYS)->days();
    $this->putJson('/api/v1/profile', ['username' => 'ThirdName3'])->assertOk();
});

it('updates preferences with validation', function (): void {
    signInWithProfile();

    $this->putJson('/api/v1/profile/preferences', ['language' => 'ar', 'timezone' => 'Africa/Cairo'])
        ->assertOk()
        ->assertJsonPath('data.preferences', ['language' => 'ar', 'timezone' => 'Africa/Cairo']);

    $this->putJson('/api/v1/profile/preferences', ['language' => 'fr', 'timezone' => 'Mars/Olympus'])
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['language', 'timezone']);
});

it('updates privacy settings with validation', function (): void {
    signInWithProfile();

    $this->putJson('/api/v1/profile/privacy', [
        'profile_visibility' => 'private',
        'follow_policy' => 'nobody',
        'analytics_consent' => true,
    ])
        ->assertOk()
        ->assertJsonPath('message', 'Your privacy settings have been saved.')
        ->assertJsonPath('data.privacy', [
            'profile_visibility' => 'private',
            'follow_policy' => 'nobody',
            'analytics_consent' => true,
        ]);

    $this->putJson('/api/v1/profile/privacy', ['profile_visibility' => 'friends-only'])
        ->assertUnprocessable()
        ->assertJsonValidationErrors('profile_visibility');
});

it('localizes identity messages in Arabic', function (): void {
    signInWithProfile();

    $this->putJson('/api/v1/profile', ['username' => 'admin'], ['Accept-Language' => 'ar'])
        ->assertUnprocessable()
        ->assertJsonPath('errors.username.0', 'اسم المستخدم هذا غير متاح. يرجى اختيار اسم آخر.');
});
