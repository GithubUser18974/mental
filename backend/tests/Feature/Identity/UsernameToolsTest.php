<?php

declare(strict_types=1);

use App\Modules\Identity\Models\AnonymousProfile;
use App\Modules\Identity\Support\AvatarCatalog;
use App\Modules\Identity\Support\UsernamePolicy;
use Laravel\Sanctum\Sanctum;

beforeEach(function (): void {
    $this->me = AnonymousProfile::factory()->create(['username' => 'MyOwnName']);
    Sanctum::actingAs($this->me->user);
    AnonymousProfile::factory()->create(['username' => 'TakenName']);
});

it('reports username availability with a reason', function (string $username, bool $available, ?string $reason): void {
    $this->getJson('/api/v1/profile/username-availability?username='.urlencode($username))
        ->assertOk()
        ->assertJsonPath('data.available', $available)
        ->assertJsonPath('data.reason', $reason);
})->with([
    'free' => ['BrandNew42', true, null],
    'taken, different case' => ['TAKENNAME', false, 'taken'],
    'own current name' => ['myownname', true, null],
    'reserved' => ['moderator', false, 'reserved'],
    'invalid' => ['no spaces allowed', false, 'invalid'],
]);

it('suggests distinct, valid, available usernames', function (): void {
    $names = $this->getJson('/api/v1/profile/username-suggestions')
        ->assertOk()
        ->json('data.usernames');

    expect($names)->toHaveCount(5)
        ->and(array_unique($names))->toHaveCount(5);

    foreach ($names as $name) {
        expect(UsernamePolicy::isAvailable($name))->toBeTrue();
    }
});

it('lists the generated avatar options', function (): void {
    $this->getJson('/api/v1/profile/avatar-options')
        ->assertOk()
        ->assertJsonCount(count(AvatarCatalog::ICONS) * count(AvatarCatalog::COLORS), 'data.avatars')
        ->assertJsonPath('data.icons', AvatarCatalog::ICONS)
        ->assertJsonPath('data.colors', AvatarCatalog::COLORS);
});

it('rate-limits availability checks', function (): void {
    foreach (range(1, 30) as $i) {
        $this->getJson('/api/v1/profile/username-availability?username=Name'.$i)->assertOk();
    }

    $this->getJson('/api/v1/profile/username-availability?username=OneMore')->assertTooManyRequests();
});
