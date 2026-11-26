<?php

declare(strict_types=1);

use App\Modules\Community\Enums\ContentWarning;
use App\Modules\Community\Models\Post;
use App\Modules\Identity\Models\AnonymousProfile;

beforeEach(function (): void {
    $this->me = actAs(AnonymousProfile::factory()->create());
});

/** Create a post through the API so hashtags are parsed. */
function postAs(AnonymousProfile $author, string $content, ?string $warning = null): string
{
    actAs($author);
    $id = test()->postJson('/api/v1/posts', [
        'content' => $content,
        'category' => 'daily-thoughts',
        'content_warning' => $warning,
    ])->assertCreated()->json('data.id');
    actAs(test()->me);

    return $id;
}

/** @return list<string> */
function ids(string $uri): array
{
    return collect(test()->getJson($uri)->assertOk()->json('data'))->pluck('id')->all();
}

it('shows only posts from people I follow in the following feed', function (): void {
    $followed = AnonymousProfile::factory()->create();
    $fromFollowed = Post::factory()->create(['author_profile_id' => $followed->id]);
    Post::factory()->create();
    Post::factory()->onlyMe()->create(['author_profile_id' => $followed->id]);

    expect(ids('/api/v1/posts?following=1'))->toBe([]);

    $this->postJson("/api/v1/profiles/{$followed->id}/follow")->assertNoContent();
    expect(ids('/api/v1/posts?following=1'))->toBe([$fromFollowed->id])
        ->and(ids('/api/v1/posts?following=0'))->toHaveCount(2);
});

it('searches post text in Arabic and English, literally and case-insensitively', function (): void {
    $en = Post::factory()->create(['content' => 'Morning walks help my Anxiety a lot']);
    $ar = Post::factory()->create(['content' => 'أشعر بالقلق اليوم لكنني بخير']);
    Post::factory()->create(['content' => '100% tired today']);
    Post::factory()->onlyMe()->create(['content' => 'secret anxiety notes']);

    expect(ids('/api/v1/posts?q=anxiety'))->toBe([$en->id])
        ->and(ids('/api/v1/posts?q='.urlencode('بالقلق')))->toBe([$ar->id])
        ->and(ids('/api/v1/posts?q=0%25'))->toHaveCount(1)
        ->and(ids('/api/v1/posts?q=%25%25'))->toBe([]);
});

it('validates the post search text', function (): void {
    $this->getJson('/api/v1/posts?q=a')->assertUnprocessable()->assertJsonValidationErrors('q');
});

it('searches hashtags by text with public post counts, prefix matches first', function (): void {
    $author = AnonymousProfile::factory()->create();
    postAs($author, 'One #sleep');
    postAs($author, 'Two #sleep');
    postAs($author, 'Three #deepsleep');
    postAs($author, 'Four #walking');
    $private = postAs($author, 'Hidden #sleepless');
    Post::query()->whereKey($private)->update(['visibility' => 'only_me']);

    $this->getJson('/api/v1/search/hashtags?q=%23Sleep')
        ->assertOk()
        ->assertExactJson([
            'success' => true,
            'message' => 'Request completed successfully.',
            'data' => [
                ['name' => 'sleep', 'posts_count' => 2],
                ['name' => 'deepsleep', 'posts_count' => 1],
            ],
        ]);

    $this->getJson('/api/v1/search/hashtags')->assertUnprocessable()->assertJsonValidationErrors('q');
});

it('trends hashtags from the last week, never from posts with content warnings', function (): void {
    $author = AnonymousProfile::factory()->create();
    postAs($author, 'A #gratitude');
    postAs($author, 'B #gratitude');
    postAs($author, 'C #morning');
    postAs($author, 'Heavy #dark', ContentWarning::SelfHarm->value);
    postAs($author, 'Heavy again #dark', ContentWarning::SelfHarm->value);
    postAs($author, 'Heavy three #dark', ContentWarning::SelfHarm->value);
    $old = postAs($author, 'Old #throwback');
    Post::query()->whereKey($old)->update(['created_at' => now()->subDays(8)]);

    $names = collect($this->getJson('/api/v1/hashtags/trending')->assertOk()->json('data'))->pluck('name')->all();

    expect($names)->toBe(['gratitude', 'morning']);
});
