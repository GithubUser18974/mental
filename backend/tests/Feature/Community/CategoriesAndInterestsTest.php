<?php

declare(strict_types=1);

use App\Modules\Community\Models\PostCategory;
use App\Modules\Identity\Models\AnonymousProfile;
use Laravel\Sanctum\Sanctum;

beforeEach(function (): void {
    Sanctum::actingAs(AnonymousProfile::factory()->create()->user);
});

it('lists the seven SRS categories in order, localized', function (): void {
    $this->getJson('/api/v1/categories')
        ->assertOk()
        ->assertJsonCount(7, 'data')
        ->assertJsonPath('data.0', [
            'slug' => 'my-story',
            'name' => 'My Story',
            'description' => 'Personal mental health experiences',
            'icon' => 'auto_stories',
        ])
        ->assertJsonPath('data.6.slug', 'mental-wellness');

    $this->getJson('/api/v1/categories', ['Accept-Language' => 'ar'])
        ->assertJsonPath('data.1.name', 'أحتاج دعمًا');
});

it('hides deactivated categories', function (): void {
    PostCategory::query()->where('slug', 'questions')->update(['is_active' => false]);

    $slugs = collect($this->getJson('/api/v1/categories')->json('data'))->pluck('slug');

    expect($slugs)->not->toContain('questions')->and($slugs)->toHaveCount(6);
});

it('saves and returns topics of interest', function (): void {
    $this->getJson('/api/v1/profile/interests')->assertOk()->assertJsonCount(0, 'data');

    $this->putJson('/api/v1/profile/interests', ['categories' => ['recovery-journey', 'my-story']])
        ->assertOk()
        ->assertJsonPath('message', 'Your interests have been saved.')
        ->assertJsonPath('data.*.slug', ['my-story', 'recovery-journey']);

    $this->putJson('/api/v1/profile/interests', ['categories' => []])->assertOk()->assertJsonCount(0, 'data');
});

it('rejects unknown or inactive categories as interests', function (): void {
    PostCategory::query()->where('slug', 'questions')->update(['is_active' => false]);

    $this->putJson('/api/v1/profile/interests', ['categories' => ['questions', 'nope']])
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['categories.0', 'categories.1']);
});
