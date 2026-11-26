<?php

declare(strict_types=1);

use App\Modules\Auth\Enums\AccountStatus;
use App\Modules\Auth\Models\User;

/**
 * @return array{0: User, 1: string}
 */
function userWithToken(string $device = 'phone'): array
{
    $user = User::factory()->create();

    return [$user, $user->createToken($device, ['*'], now()->addDay())->plainTextToken];
}

it('requires authentication for session endpoints', function (string $method, string $uri): void {
    $this->json($method, $uri)
        ->assertUnauthorized()
        ->assertExactJson(['success' => false, 'message' => 'Please sign in to continue.']);
})->with([
    ['GET', '/api/v1/auth/me'],
    ['POST', '/api/v1/auth/refresh'],
    ['POST', '/api/v1/auth/logout'],
    ['POST', '/api/v1/auth/logout-all'],
]);

it('returns only the signed-in user\'s own account', function (): void {
    [$user, $token] = userWithToken();
    User::factory()->create(['email' => 'other@example.com']);

    $this->withToken($token)->getJson('/api/v1/auth/me')
        ->assertOk()
        ->assertExactJson([
            'success' => true,
            'message' => 'Request completed successfully.',
            'data' => [
                'id' => $user->id,
                'email' => $user->email,
                'email_verified' => false,
                'status' => 'active',
                'created_at' => $user->created_at->utc()->format('Y-m-d\TH:i:s\Z'),
            ],
        ]);
});

it('logout revokes only the current device token', function (): void {
    [$user, $phone] = userWithToken('phone');
    $tablet = $user->createToken('tablet')->plainTextToken;

    $this->withToken($phone)->postJson('/api/v1/auth/logout')
        ->assertOk()
        ->assertJsonPath('message', 'You have been signed out.');

    forgetAuth();
    $this->withToken($phone)->getJson('/api/v1/auth/me')->assertUnauthorized();
    forgetAuth();
    $this->withToken($tablet)->getJson('/api/v1/auth/me')->assertOk();
});

it('logout-all revokes every token of the account but not other accounts', function (): void {
    [$user, $phone] = userWithToken('phone');
    $tablet = $user->createToken('tablet')->plainTextToken;
    [, $otherToken] = userWithToken();

    $this->withToken($phone)->postJson('/api/v1/auth/logout-all')
        ->assertOk()
        ->assertJsonPath('message', 'You have been signed out on all devices.');

    expect($user->tokens()->count())->toBe(0);

    foreach ([$phone, $tablet] as $revoked) {
        forgetAuth();
        $this->withToken($revoked)->getJson('/api/v1/auth/me')->assertUnauthorized();
    }

    forgetAuth();
    $this->withToken($otherToken)->getJson('/api/v1/auth/me')->assertOk();
});

it('refresh swaps the current token for a new one with a fresh expiry', function (): void {
    [$user, $old] = userWithToken('phone');

    $new = $this->withToken($old)->postJson('/api/v1/auth/refresh')
        ->assertOk()
        ->assertJsonPath('data.token_type', 'Bearer')
        ->json('data.token');

    expect($new)->not->toBe($old)
        ->and($user->tokens()->sole()->name)->toBe('phone');

    forgetAuth();
    $this->withToken($old)->getJson('/api/v1/auth/me')->assertUnauthorized();
    forgetAuth();
    $this->withToken($new)->getJson('/api/v1/auth/me')->assertOk();
});

it('rejects expired tokens', function (): void {
    $user = User::factory()->create();
    $token = $user->createToken('phone', ['*'], now()->addMinute())->plainTextToken;

    $this->travel(2)->minutes();

    $this->withToken($token)->getJson('/api/v1/auth/me')->assertUnauthorized();
});

it('blocks a suspended account that still holds a valid token', function (): void {
    [$user, $token] = userWithToken();
    $user->forceFill(['status' => AccountStatus::Suspended])->save();

    $this->withToken($token)->getJson('/api/v1/auth/me')
        ->assertForbidden()
        ->assertJsonPath('message', 'This account can’t be used right now. Please contact support.');
});
