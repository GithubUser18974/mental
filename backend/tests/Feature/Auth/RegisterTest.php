<?php

declare(strict_types=1);

use App\Modules\Auth\Enums\AccountStatus;
use App\Modules\Auth\Events\UserRegistered;
use App\Modules\Auth\Models\User;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Hash;

function registrationPayload(array $overrides = []): array
{
    return [
        'email' => 'New.Person@Example.com ',
        'password' => 'calm-river-42',
        'password_confirmation' => 'calm-river-42',
        'age_confirmed' => true,
        'terms_accepted' => true,
        'device_name' => 'Pixel 9a',
        ...$overrides,
    ];
}

it('registers an account and returns a usable bearer token', function (): void {
    Event::fake([UserRegistered::class]);

    $response = $this->postJson('/api/v1/auth/register', registrationPayload())
        ->assertCreated()
        ->assertJsonPath('success', true)
        ->assertJsonPath('message', 'Welcome! Your account has been created.')
        ->assertJsonPath('data.token_type', 'Bearer')
        ->assertJsonPath('data.account.email', 'new.person@example.com')
        ->assertJsonPath('data.account.status', 'active')
        ->assertJsonPath('data.account.email_verified', false);

    $user = User::query()->sole();
    expect($user->email)->toBe('new.person@example.com')
        ->and(Hash::check('calm-river-42', $user->password))->toBeTrue()
        ->and($user->status)->toBe(AccountStatus::Active)
        ->and($user->age_confirmed_at)->not->toBeNull()
        ->and($user->terms_accepted_at)->not->toBeNull()
        ->and($user->tokens()->sole()->name)->toBe('Pixel 9a');

    expect($response->json('data.token'))->toMatch('/^[0-9a-f-]{36}\|y_\w{40,}/')
        ->and($response->json('data.expires_at'))->toMatch('/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$/');

    Event::assertDispatched(UserRegistered::class, fn (UserRegistered $e): bool => $e->user->is($user));

    forgetAuth();
    $this->withToken($response->json('data.token'))
        ->getJson('/api/v1/auth/me')
        ->assertOk()
        ->assertJsonPath('data.id', $user->id);
});

it('never returns the password hash or remember token', function (): void {
    $body = $this->postJson('/api/v1/auth/register', registrationPayload())->getContent();

    $user = User::query()->sole();
    expect($body)->not->toContain($user->password)
        ->not->toContain('password')
        ->not->toContain('remember_token');
});

it('requires the 18+ confirmation and terms acceptance', function (): void {
    $this->postJson('/api/v1/auth/register', registrationPayload([
        'age_confirmed' => false,
        'terms_accepted' => null,
    ]))
        ->assertUnprocessable()
        ->assertJsonPath('errors.age_confirmed.0', 'You must be 18 or older to use this app.')
        ->assertJsonPath('errors.terms_accepted.0', 'Please accept the terms of use and privacy policy to continue.');

    expect(User::query()->count())->toBe(0);
});

it('enforces the password policy', function (array $overrides, string $field): void {
    $this->postJson('/api/v1/auth/register', registrationPayload($overrides))
        ->assertUnprocessable()
        ->assertJsonValidationErrors($field);
})->with([
    'too short' => [['password' => 'abc123', 'password_confirmation' => 'abc123'], 'password'],
    'no numbers' => [['password' => 'onlyletters', 'password_confirmation' => 'onlyletters'], 'password'],
    'no letters' => [['password' => '1234567890', 'password_confirmation' => '1234567890'], 'password'],
    'mismatch' => [['password_confirmation' => 'something-else-1'], 'password'],
    'bad email' => [['email' => 'not-an-email'], 'email'],
]);

it('rejects an email that is already registered, case-insensitively', function (): void {
    User::factory()->create(['email' => 'taken@example.com']);

    $this->postJson('/api/v1/auth/register', registrationPayload(['email' => 'TAKEN@example.com']))
        ->assertUnprocessable()
        ->assertJsonValidationErrors('email');

    expect(User::query()->count())->toBe(1);
});

it('localizes validation messages in Arabic', function (): void {
    $this->postJson('/api/v1/auth/register', registrationPayload(['email' => '', 'age_confirmed' => false]), [
        'Accept-Language' => 'ar',
    ])
        ->assertUnprocessable()
        ->assertJsonPath('message', 'يرجى مراجعة البيانات المدخلة.')
        ->assertJsonPath('errors.email.0', 'حقل البريد الإلكتروني مطلوب.')
        ->assertJsonPath('errors.age_confirmed.0', 'يجب أن يكون عمرك 18 عامًا أو أكثر لاستخدام هذا التطبيق.');
});
