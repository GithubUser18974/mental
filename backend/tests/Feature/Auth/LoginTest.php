<?php

declare(strict_types=1);

use App\Modules\Auth\Database\Factories\UserFactory;
use App\Modules\Auth\Models\User;
use Carbon\CarbonImmutable;

it('signs in with email and password and returns an expiring token', function (): void {
    $this->freezeSecond();
    $user = User::factory()->create(['email' => 'calm@example.com']);

    $this->postJson('/api/v1/auth/login', [
        'email' => '  CALM@example.com',
        'password' => UserFactory::PASSWORD,
        'device_name' => 'iPhone',
    ])
        ->assertOk()
        ->assertJsonPath('message', 'Welcome back.')
        ->assertJsonPath('data.account.id', $user->id)
        ->assertJsonPath('data.expires_at', CarbonImmutable::now()->addDays(30)->utc()->format('Y-m-d\TH:i:s\Z'));

    expect($user->fresh()?->last_login_at?->equalTo(now()))->toBeTrue()
        ->and($user->tokens()->sole()->expires_at?->equalTo(now()->addDays(30)))->toBeTrue();
});

it('gives the same answer for a wrong password and an unknown email (no enumeration)', function (): void {
    User::factory()->create(['email' => 'calm@example.com']);

    $wrongPassword = $this->postJson('/api/v1/auth/login', ['email' => 'calm@example.com', 'password' => 'wrong-pass-1'])
        ->assertUnprocessable();
    $unknownEmail = $this->postJson('/api/v1/auth/login', ['email' => 'nobody@example.com', 'password' => 'wrong-pass-1'])
        ->assertUnprocessable();

    expect($wrongPassword->json())->toBe($unknownEmail->json())
        ->and($wrongPassword->json('errors.email.0'))->toBe('The email or password is incorrect.');
});

it('blocks suspended and deactivated accounts without issuing a token', function (string $state): void {
    $user = User::factory()->{$state}()->create();

    $this->postJson('/api/v1/auth/login', ['email' => $user->email, 'password' => UserFactory::PASSWORD])
        ->assertForbidden()
        ->assertExactJson([
            'success' => false,
            'message' => 'This account can’t be used right now. Please contact support.',
        ]);

    expect($user->tokens()->count())->toBe(0);
})->with(['suspended', 'deactivated']);

it('does not reveal suspension to someone without the password', function (): void {
    $user = User::factory()->suspended()->create();

    $this->postJson('/api/v1/auth/login', ['email' => $user->email, 'password' => 'wrong-pass-1'])
        ->assertUnprocessable()
        ->assertJsonValidationErrors('email');
});

it('rate-limits repeated attempts for the same account (brute-force protection)', function (): void {
    $user = User::factory()->create();

    foreach (range(1, 5) as $_) {
        $this->postJson('/api/v1/auth/login', ['email' => $user->email, 'password' => 'wrong-pass-1'])
            ->assertUnprocessable();
    }

    $this->postJson('/api/v1/auth/login', ['email' => $user->email, 'password' => UserFactory::PASSWORD])
        ->assertTooManyRequests()
        ->assertHeader('Retry-After');
});

it('validates required fields', function (): void {
    $this->postJson('/api/v1/auth/login', [])
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['email', 'password']);
});
