<?php

declare(strict_types=1);

use App\Modules\Community\Enums\ModerationStatus;
use App\Modules\Community\Models\Post;
use App\Modules\Community\Models\SavedPost;
use App\Modules\Identity\Models\AnonymousProfile;
use Illuminate\Support\Str;

beforeEach(function (): void {
    $this->me = actAs(AnonymousProfile::factory()->create(['username' => 'SoftHarbor']));
});

/** @return list<string> */
function savedIds(string $query = ''): array
{
    return collect(test()->getJson('/api/v1/saved-posts'.$query)->assertOk()->json('data'))->pluck('id')->all();
}

it('requires authentication', function (string $method, string $uri): void {
    forgetAuth();

    $this->withHeader('Authorization', 'Bearer invalid')->json($method, $uri)->assertUnauthorized();
})->with([
    ['GET', '/api/v1/saved-posts'],
    ['POST', '/api/v1/posts/'.Str::uuid().'/save'],
    ['DELETE', '/api/v1/posts/'.Str::uuid().'/save'],
]);

it('saves posts privately, newest saved first, idempotently', function (): void {
    [$a, $b] = Post::factory()->count(2)->create();

    $this->postJson("/api/v1/posts/{$a->id}/save")->assertNoContent();
    $this->travel(1)->minutes();
    $this->postJson("/api/v1/posts/{$b->id}/save")->assertNoContent();
    $this->postJson("/api/v1/posts/{$a->id}/save")->assertNoContent(); // again: no duplicate, keeps its place

    expect(SavedPost::query()->count())->toBe(2)
        ->and(savedIds())->toBe([$b->id, $a->id]);

    $this->getJson('/api/v1/saved-posts')->assertJsonPath('data.0.is_saved', true);
    $this->getJson("/api/v1/posts/{$a->id}")->assertJsonPath('data.is_saved', true);
});

it('unsaves (idempotently)', function (): void {
    $post = Post::factory()->create();
    $this->postJson("/api/v1/posts/{$post->id}/save")->assertNoContent();

    $this->deleteJson("/api/v1/posts/{$post->id}/save")->assertNoContent();
    $this->deleteJson("/api/v1/posts/{$post->id}/save")->assertNoContent();

    expect(savedIds())->toBe([]);
    $this->getJson("/api/v1/posts/{$post->id}")->assertJsonPath('data.is_saved', false);
});

it('never shows my saved posts to anyone else', function (): void {
    $post = Post::factory()->create();
    $this->postJson("/api/v1/posts/{$post->id}/save")->assertNoContent();

    actAs(AnonymousProfile::factory()->create());

    expect(savedIds())->toBe([]);
    $this->getJson("/api/v1/posts/{$post->id}")->assertJsonPath('data.is_saved', false);
    expect($this->getJson('/api/v1/profiles/SoftHarbor/posts')->getContent())->not->toContain($post->id);
});

it('drops saved posts that are no longer visible to me', function (): void {
    $visible = Post::factory()->create();
    $hidden = Post::factory()->create();
    $deleted = Post::factory()->create();
    $private = Post::factory()->create();
    $mineOnlyMe = Post::factory()->onlyMe()->create(['author_profile_id' => $this->me->id]);
    foreach ([$visible, $hidden, $deleted, $private, $mineOnlyMe] as $post) {
        $this->postJson("/api/v1/posts/{$post->id}/save")->assertNoContent();
    }

    $hidden->forceFill(['moderation_status' => ModerationStatus::Hidden])->save();
    $private->forceFill(['visibility' => 'only_me'])->save();
    $deleted->delete();

    expect(savedIds())->toEqualCanonicalizing([$visible->id, $mineOnlyMe->id]);
});

it('cannot save posts I cannot see (404)', function (): void {
    $post = Post::factory()->onlyMe()->create();

    $this->postJson("/api/v1/posts/{$post->id}/save")->assertNotFound();
    expect(SavedPost::query()->count())->toBe(0);
});

it('paginates saved posts with a cursor', function (): void {
    $posts = Post::factory()->count(3)->create();
    foreach ($posts as $post) {
        $this->postJson("/api/v1/posts/{$post->id}/save")->assertNoContent();
        $this->travel(1)->minutes();
    }

    $page1 = $this->getJson('/api/v1/saved-posts?per_page=2')->assertOk()->assertJsonCount(2, 'data');
    $page2 = $this->getJson('/api/v1/saved-posts?per_page=2&cursor='.$page1->json('meta.pagination.next_cursor'))
        ->assertJsonCount(1, 'data')
        ->assertJsonPath('meta.pagination.has_more', false);

    expect([...$page1->json('data.*.id'), ...$page2->json('data.*.id')])
        ->toBe($posts->reverse()->pluck('id')->values()->all());
});
