<?php

declare(strict_types=1);

use App\Modules\Identity\Enums\ProfileVisibility;
use App\Modules\Identity\Models\AnonymousProfile;
use App\Modules\Identity\Models\UserPrivacySetting;
use Laravel\Sanctum\Sanctum;

beforeEach(function (): void {
    Sanctum::actingAs(AnonymousProfile::factory()->create()->user);

    $this->other = AnonymousProfile::factory()->create([
        'username' => 'GentleWillow',
        'avatar' => 'leaf-mint',
        'bio' => 'Learning to be kind to myself.',
    ]);
});

it('shows another member\'s public profile by username, case-insensitively', function (): void {
    $this->getJson('/api/v1/profiles/gentlewillow')
        ->assertOk()
        ->assertExactJson([
            'success' => true,
            'message' => 'Request completed successfully.',
            'data' => [
                'id' => $this->other->id,
                'username' => 'GentleWillow',
                'avatar' => 'leaf-mint',
                'bio' => 'Learning to be kind to myself.',
                'is_private' => false,
                'joined_on' => $this->other->created_at->format('Y-m-d'),
                'stats' => ['followers' => 0, 'following' => 0],
                'relationship' => [
                    'is_self' => false,
                    'is_following' => false,
                    'follows_you' => false,
                    'is_blocked' => false,
                    'can_follow' => true,
                ],
            ],
        ]);
});

it('never exposes account identifiers or credentials (SRS §13.3 #4)', function (): void {
    $user = $this->other->user;
    $user->createToken('phone');

    $body = $this->getJson('/api/v1/profiles/GentleWillow')->assertOk()->getContent();

    expect($body)
        ->not->toContain($user->id)
        ->not->toContain($user->email)
        ->not->toContain('user_id')
        ->not->toContain('email')
        ->not->toContain('password')
        ->not->toContain('token')
        ->not->toContain('status');
});

it('hides the bio of a private profile', function (): void {
    UserPrivacySetting::query()->create([
        'user_id' => $this->other->user_id,
        'profile_visibility' => ProfileVisibility::Private,
    ]);

    $this->getJson('/api/v1/profiles/GentleWillow')
        ->assertOk()
        ->assertJsonPath('data.bio', null)
        ->assertJsonPath('data.is_private', true)
        ->assertJsonPath('data.username', 'GentleWillow');
});

it('returns 404 for unknown usernames and for suspended or deactivated accounts alike', function (?string $state): void {
    if ($state !== null) {
        $this->other->user->forceFill(['status' => $state])->save();
    }

    $username = $state === null ? 'NobodyHere' : 'GentleWillow';

    $this->getJson('/api/v1/profiles/'.$username)
        ->assertNotFound()
        ->assertExactJson(['success' => false, 'message' => 'The requested resource was not found.']);
})->with([
    'unknown' => [null],
    'suspended' => ['suspended'],
    'deactivated' => ['deactivated'],
]);

it('does not let one user read another user\'s own-profile settings', function (): void {
    // GET /profile is always "me": there is no id parameter to tamper with.
    $response = $this->getJson('/api/v1/profile')->assertOk();

    expect($response->json('data.profile.id'))->not->toBe($this->other->id);
});
