<?php

declare(strict_types=1);

use App\Modules\Community\Enums\ContentWarning;
use App\Modules\Community\Enums\ModerationStatus;
use App\Modules\Community\Models\Post;
use App\Modules\Identity\Models\AnonymousProfile;
use Illuminate\Support\Facades\DB;
use Laravel\Sanctum\Sanctum;

beforeEach(function (): void {
    $this->me = AnonymousProfile::factory()->create(['username' => 'SoftHarbor']);
    Sanctum::actingAs($this->me->user);
});

/** @return list<string> */
function feedIds(string $query = ''): array
{
    return collect(test()->getJson('/api/v1/posts'.$query)->assertOk()->json('data'))->pluck('id')->all();
}

it('lists public posts newest first and excludes hidden, private, reviewed and deleted ones', function (): void {
    $old = Post::factory()->create(['created_at' => now()->subHours(2)]);
    $new = Post::factory()->create(['created_at' => now()->subHour()]);
    Post::factory()->onlyMe()->create();
    Post::factory()->moderated(ModerationStatus::Hidden)->create();
    Post::factory()->moderated(ModerationStatus::UnderReview)->create();
    tap(Post::factory()->create())->delete();

    expect(feedIds())->toBe([$new->id, $old->id]);
});

it('excludes even my own private posts from the community feed', function (): void {
    Post::factory()->onlyMe()->create(['author_profile_id' => $this->me->id]);

    expect(feedIds())->toBe([]);
});

it('filters by category and by hashtag', function (): void {
    $story = Post::factory()->inCategory('my-story')->create();
    Post::factory()->inCategory('questions')->create(); // no hashtags (factory skips SavePost)

    // Hashtags are parsed by SavePost, so create the tagged post through the API.
    $tagged = $this->postJson('/api/v1/posts', ['content' => 'Night routine #Sleep', 'category' => 'mental-wellness'])
        ->json('data.id');

    expect(feedIds('?category=my-story'))->toBe([$story->id])
        ->and(feedIds('?hashtag=sleep'))->toBe([$tagged])
        ->and(feedIds('?hashtag=%23SLEEP'))->toBe([$tagged]);
});

it('popular: highest score first within the last week, never posts with content warnings', function (): void {
    $low = Post::factory()->create(['score' => 3]);
    $high = Post::factory()->create(['score' => 40]);
    Post::factory()->withWarning(ContentWarning::SelfHarm)->create(['score' => 999]);
    Post::factory()->create(['score' => 500, 'created_at' => now()->subDays(8)]);

    expect(feedIds('?sort=popular'))->toBe([$high->id, $low->id]);

    // Warned posts still appear in the chronological feed (blurred client-side).
    expect(feedIds())->toHaveCount(4);
});

it('paginates with a cursor', function (): void {
    Post::factory()->count(5)->sequence(fn ($s) => ['created_at' => now()->subMinutes($s->index)])->create();

    $page1 = $this->getJson('/api/v1/posts?per_page=2')->assertOk();
    $page1->assertJsonCount(2, 'data')->assertJsonPath('meta.pagination.has_more', true);

    $page2 = $this->getJson('/api/v1/posts?per_page=2&cursor='.$page1->json('meta.pagination.next_cursor'));
    $page3 = $this->getJson('/api/v1/posts?per_page=2&cursor='.$page2->json('meta.pagination.next_cursor'));

    $all = [...$page1->json('data.*.id'), ...$page2->json('data.*.id'), ...$page3->json('data.*.id')];
    expect($all)->toHaveCount(5)->and(array_unique($all))->toHaveCount(5)
        ->and($page3->json('meta.pagination.has_more'))->toBeFalse();
});

it('validates feed parameters', function (): void {
    $this->getJson('/api/v1/posts?sort=trending&per_page=500&category=nope')
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['sort', 'per_page', 'category']);
});

it('lists a member\'s public posts, and my own profile includes my private ones', function (): void {
    $other = AnonymousProfile::factory()->create(['username' => 'GentleWillow']);
    $public = Post::factory()->create(['author_profile_id' => $other->id]);
    Post::factory()->onlyMe()->create(['author_profile_id' => $other->id]);
    $myPublic = Post::factory()->create(['author_profile_id' => $this->me->id]);
    $myPrivate = Post::factory()->onlyMe()->create(['author_profile_id' => $this->me->id]);

    expect(collect($this->getJson('/api/v1/profiles/gentlewillow/posts')->assertOk()->json('data'))->pluck('id')->all())
        ->toBe([$public->id]);

    expect(collect($this->getJson('/api/v1/profiles/SoftHarbor/posts')->json('data'))->pluck('id')->sort()->values()->all())
        ->toBe(collect([$myPublic->id, $myPrivate->id])->sort()->values()->all());
});

it('404s posts of unknown or suspended members', function (): void {
    $other = AnonymousProfile::factory()->create(['username' => 'GentleWillow']);
    $other->user->forceFill(['status' => 'suspended'])->save();

    $this->getJson('/api/v1/profiles/GentleWillow/posts')->assertNotFound();
    $this->getJson('/api/v1/profiles/NobodyHere/posts')->assertNotFound();
});

it('loads the feed with a constant number of queries (no N+1)', function (): void {
    Post::factory()->count(3)->create();
    $this->getJson('/api/v1/posts')->assertOk(); // warm-up: first request lazily creates settings rows
    DB::enableQueryLog();
    $this->getJson('/api/v1/posts')->assertOk();
    $few = count(DB::getQueryLog());

    Post::factory()->count(12)->create();
    DB::flushQueryLog();
    $this->getJson('/api/v1/posts')->assertOk();
    $many = count(DB::getQueryLog());

    expect($many)->toBe($few);
});
