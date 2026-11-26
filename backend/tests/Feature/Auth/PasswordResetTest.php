<?php

declare(strict_types=1);

use App\Modules\Auth\Database\Factories\UserFactory;
use App\Modules\Auth\Models\User;
use App\Modules\Auth\Notifications\ResetPasswordNotification;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Support\Facades\Notification;
use Illuminate\Support\Facades\Password;

it('sends a reset link and answers identically for unknown emails (no enumeration)', function (): void {
    Notification::fake();
    $user = User::factory()->create(['email' => 'calm@example.com']);

    $known = $this->postJson('/api/v1/auth/forgot-password', ['email' => 'CALM@example.com'])->assertOk();
    $unknown = $this->postJson('/api/v1/auth/forgot-password', ['email' => 'nobody@example.com'])->assertOk();

    expect($known->json())->toBe($unknown->json())
        ->and($known->json('message'))->toBe('If an account exists for this email, we’ve sent a link to reset the password.');

    Notification::assertSentTo($user, ResetPasswordNotification::class);
    Notification::assertSentTimes(ResetPasswordNotification::class, 1);
});

it('answers identically even when the broker throttles a repeat request', function (): void {
    Notification::fake();
    User::factory()->create(['email' => 'calm@example.com']);

    $first = $this->postJson('/api/v1/auth/forgot-password', ['email' => 'calm@example.com'])->assertOk();
    $second = $this->postJson('/api/v1/auth/forgot-password', ['email' => 'calm@example.com'])->assertOk();

    expect($second->json())->toBe($first->json());
    Notification::assertSentTimes(ResetPasswordNotification::class, 1);
});

it('queues a localized reset email that deep-links into the app', function (): void {
    Notification::fake();
    config(['auth.password_reset_url' => 'https://y.example/reset-password']);
    $user = User::factory()->create(['email' => 'calm@example.com']);

    $this->postJson('/api/v1/auth/forgot-password', ['email' => 'calm@example.com'], ['Accept-Language' => 'ar'])
        ->assertOk();

    Notification::assertSentTo($user, ResetPasswordNotification::class, function (ResetPasswordNotification $n) use ($user): bool {
        $mail = $n->toMail($user);

        return $n instanceof ShouldQueue
            && $n->locale === 'ar'
            && str_starts_with($n->resetUrl($user), 'https://y.example/reset-password?token=')
            && str_contains($n->resetUrl($user), 'email=calm%40example.com')
            && $mail->actionUrl === $n->resetUrl($user);
    });
});

it('resets the password with a valid token and signs out every device', function (): void {
    $user = User::factory()->create(['email' => 'calm@example.com']);
    $deviceToken = $user->createToken('phone')->plainTextToken;
    $resetToken = Password::broker()->createToken($user);

    $this->postJson('/api/v1/auth/reset-password', [
        'email' => 'calm@example.com',
        'token' => $resetToken,
        'password' => 'new-calm-river-7',
        'password_confirmation' => 'new-calm-river-7',
    ])
        ->assertOk()
        ->assertJsonPath('message', 'Your password has been reset. Please sign in again.');

    expect($user->tokens()->count())->toBe(0);

    forgetAuth();
    $this->withToken($deviceToken)->getJson('/api/v1/auth/me')->assertUnauthorized();

    $this->postJson('/api/v1/auth/login', ['email' => 'calm@example.com', 'password' => UserFactory::PASSWORD])
        ->assertUnprocessable();
    $this->postJson('/api/v1/auth/login', ['email' => 'calm@example.com', 'password' => 'new-calm-river-7'])
        ->assertOk();
});

it('rejects a reset token only once it has been used', function (): void {
    $user = User::factory()->create();
    $token = Password::broker()->createToken($user);
    $payload = ['email' => $user->email, 'token' => $token, 'password' => 'new-calm-river-7', 'password_confirmation' => 'new-calm-river-7'];

    $this->postJson('/api/v1/auth/reset-password', $payload)->assertOk();
    $this->postJson('/api/v1/auth/reset-password', $payload)
        ->assertUnprocessable()
        ->assertJsonPath('errors.token.0', 'This reset link is invalid or has expired. Please request a new one.');
});

it('gives the same error for a bad token and an unknown email', function (): void {
    $user = User::factory()->create();
    $base = ['token' => 'not-a-real-token', 'password' => 'new-calm-river-7', 'password_confirmation' => 'new-calm-river-7'];

    $badToken = $this->postJson('/api/v1/auth/reset-password', [...$base, 'email' => $user->email])->assertUnprocessable();
    $unknown = $this->postJson('/api/v1/auth/reset-password', [...$base, 'email' => 'nobody@example.com'])->assertUnprocessable();

    expect($badToken->json())->toBe($unknown->json());
});

it('applies the password policy on reset', function (): void {
    $user = User::factory()->create();

    $this->postJson('/api/v1/auth/reset-password', [
        'email' => $user->email,
        'token' => Password::broker()->createToken($user),
        'password' => 'short1',
        'password_confirmation' => 'short1',
    ])->assertUnprocessable()->assertJsonValidationErrors('password');
});

it('rate-limits reset requests per email', function (): void {
    Notification::fake();

    foreach (range(1, 3) as $_) {
        $this->postJson('/api/v1/auth/forgot-password', ['email' => 'calm@example.com'])->assertOk();
    }

    $this->postJson('/api/v1/auth/forgot-password', ['email' => 'calm@example.com'])->assertTooManyRequests();
});
