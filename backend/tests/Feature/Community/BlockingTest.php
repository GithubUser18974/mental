<?php

declare(strict_types=1);

use App\Modules\Community\Models\Comment;
use App\Modules\Community\Models\Post;
use App\Modules\Identity\Models\AnonymousProfile;

/*
| FR-COM-009 / BR-008 / SRS §13.3: once either member blocks the other, neither sees the
| other's content anywhere, and neither can interact with the other.
*/

beforeEach(function (): void {
    $this->me = AnonymousProfile::factory()->create(['username' => 'SoftHarbor']);
    $this->them = AnonymousProfile::factory()->create(['username' => 'LoudStorm']);
    $this->theirPost = Post::factory()->create(['author_profile_id' => $this->them->id, 'content' => 'Their words']);
    $this->myPost = Post::factory()->create(['author_profile_id' => $this->me->id, 'content' => 'My words']);
});

/** Block in the given direction, then act as me. */
function blockBetween(string $direction): void
{
    [$blocker, $blocked] = $direction === 'i blocked them' ? [test()->me, test()->them] : [test()->them, test()->me];
    actAs($blocker);
    test()->postJson("/api/v1/profiles/{$blocked->id}/block")->assertNoContent();
    actAs(test()->me);
}

dataset('direction', ['i blocked them', 'they blocked me']);

it('removes their posts from my feeds and searches', function (string $direction): void {
    blockBetween($direction);

    $ids = fn (string $uri): array => collect($this->getJson($uri)->assertOk()->json('data'))->pluck('id')->all();

    expect($ids('/api/v1/posts'))->toBe([$this->myPost->id])
        ->and($ids('/api/v1/posts?sort=popular'))->not->toContain($this->theirPost->id)
        ->and($ids('/api/v1/posts?q=words'))->toBe([$this->myPost->id]);
})->with('direction');

it('404s their post, profile posts and every interaction with it', function (string $direction): void {
    blockBetween($direction);
    $post = $this->theirPost->id;

    $this->getJson("/api/v1/posts/{$post}")->assertNotFound();
    $this->getJson('/api/v1/profiles/LoudStorm/posts')->assertNotFound();
    $this->getJson("/api/v1/posts/{$post}/comments")->assertNotFound();
    $this->postJson("/api/v1/posts/{$post}/comments", ['content' => 'Hi'])->assertNotFound();
    $this->postJson("/api/v1/posts/{$post}/reactions", ['type' => 'support'])->assertNotFound();
    $this->postJson("/api/v1/posts/{$post}/save")->assertNotFound();
})->with('direction');

it('stops them interacting with my posts too', function (string $direction): void {
    blockBetween($direction);
    actAs($this->them);

    $this->getJson("/api/v1/posts/{$this->myPost->id}")->assertNotFound();
    $this->postJson("/api/v1/posts/{$this->myPost->id}/comments", ['content' => 'Hi'])->assertNotFound();
    $this->postJson("/api/v1/posts/{$this->myPost->id}/reactions", ['type' => 'proud'])->assertNotFound();
})->with('direction');

it('hides their comments on other posts, keeping replies under a placeholder', function (string $direction): void {
    $post = Post::factory()->create();
    $theirRoot = Comment::factory()->create(['post_id' => $post->id, 'author_profile_id' => $this->them->id, 'content' => 'THEIR ROOT']);
    $reply = Comment::factory()->replyTo($theirRoot)->create();
    $theirLonely = Comment::factory()->create(['post_id' => $post->id, 'author_profile_id' => $this->them->id]);
    $theirReply = Comment::factory()->replyTo(Comment::factory()->create(['post_id' => $post->id]))
        ->create(['author_profile_id' => $this->them->id]);

    blockBetween($direction);

    $response = $this->getJson("/api/v1/posts/{$post->id}/comments")->assertOk();
    $byId = collect($response->json('data'))->keyBy('id');

    expect($byId->keys()->all())->not->toContain($theirLonely->id)
        ->and($byId[$theirRoot->id]['is_removed'])->toBeTrue()
        ->and($byId[$theirRoot->id]['author'])->toBeNull()
        ->and($response->getContent())->not->toContain('THEIR ROOT')->not->toContain('LoudStorm');

    $replies = fn (string $rootId): array => collect($this->getJson("/api/v1/comments/{$rootId}/replies")->json('data'))->pluck('id')->all();
    expect($replies($theirRoot->id))->toBe([$reply->id])
        ->and($replies($theirReply->parent_id))->toBe([]);

    // Can't reply to them either.
    $this->postJson("/api/v1/posts/{$post->id}/comments", ['content' => 'Hey', 'parent_id' => $theirLonely->id])
        ->assertUnprocessable();
})->with('direction');

it('drops their posts from my saved list', function (string $direction): void {
    actAs($this->me);
    $this->postJson("/api/v1/posts/{$this->theirPost->id}/save")->assertNoContent();

    blockBetween($direction);

    expect($this->getJson('/api/v1/saved-posts')->assertOk()->json('data'))->toBe([]);
})->with('direction');

it('restores everything after unblocking', function (): void {
    blockBetween('i blocked them');
    $this->deleteJson("/api/v1/profiles/{$this->them->id}/block")->assertNoContent();

    $this->getJson("/api/v1/posts/{$this->theirPost->id}")->assertOk();
    expect($this->getJson('/api/v1/posts')->json('data'))->toHaveCount(2);
});
