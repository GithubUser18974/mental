<?php

declare(strict_types=1);

use App\Modules\Community\Enums\ModerationStatus;
use App\Modules\Community\Events\CommentCreated;
use App\Modules\Community\Models\Comment;
use App\Modules\Community\Models\Post;
use App\Modules\Identity\Models\AnonymousProfile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Str;

beforeEach(function (): void {
    $this->me = actAs(AnonymousProfile::factory()->create(['username' => 'SoftHarbor']));
    $this->author = AnonymousProfile::factory()->create(['username' => 'GentleWillow']);
    $this->post = Post::factory()->create(['author_profile_id' => $this->author->id]);
});

/** @return list<string> */
function commentIds(string $uri): array
{
    return collect(test()->getJson($uri)->assertOk()->json('data'))->pluck('id')->all();
}

it('requires authentication', function (string $method, string $uri): void {
    forgetAuth();

    $this->withHeader('Authorization', 'Bearer invalid')->json($method, $uri)->assertUnauthorized();
})->with([
    ['GET', '/api/v1/posts/'.Str::uuid().'/comments'],
    ['POST', '/api/v1/posts/'.Str::uuid().'/comments'],
    ['GET', '/api/v1/comments/'.Str::uuid().'/replies'],
    ['PUT', '/api/v1/comments/'.Str::uuid()],
    ['DELETE', '/api/v1/comments/'.Str::uuid()],
]);

it('adds a comment authored by my anonymous profile only', function (): void {
    Event::fake([CommentCreated::class]);

    $response = $this->postJson("/api/v1/posts/{$this->post->id}/comments", ['content' => '  You are not alone in this.  '])
        ->assertCreated()
        ->assertJsonPath('data.content', 'You are not alone in this.')
        ->assertJsonPath('data.author.username', 'SoftHarbor')
        ->assertJsonPath('data.is_own', true)
        ->assertJsonPath('data.is_post_author', false)
        ->assertJsonPath('data.replies_count', 0)
        ->assertJsonPath('data.parent_id', null);

    $json = $response->getContent();
    expect($json)->not->toContain($this->me->user->email)
        ->not->toContain((string) $this->me->user_id)
        ->and(array_keys($response->json('data.author')))->toBe(['id', 'username', 'avatar']);

    Event::assertDispatched(CommentCreated::class, fn (CommentCreated $e): bool => $e->recipientProfileIds === [$this->author->id]);
});

it('flattens replies to one level and notifies the post and comment authors', function (): void {
    Event::fake([CommentCreated::class]);
    $other = AnonymousProfile::factory()->create();
    $root = Comment::factory()->create(['post_id' => $this->post->id, 'author_profile_id' => $other->id]);
    $reply = Comment::factory()->replyTo($root)->create();

    $this->postJson("/api/v1/posts/{$this->post->id}/comments", ['content' => 'Same here', 'parent_id' => $reply->id])
        ->assertCreated()
        ->assertJsonPath('data.parent_id', $root->id)
        ->assertJsonMissingPath('data.replies_count');

    Event::assertDispatched(CommentCreated::class, fn (CommentCreated $e): bool => $e->recipientProfileIds === [$this->author->id, $reply->author_profile_id]);
});

it('does not notify me about my own activity', function (): void {
    Event::fake([CommentCreated::class]);
    actAs($this->author);

    $this->postJson("/api/v1/posts/{$this->post->id}/comments", ['content' => 'Thanks everyone'])
        ->assertCreated()
        ->assertJsonPath('data.is_post_author', true);

    Event::assertNotDispatched(CommentCreated::class);
});

it('rejects replies to comments on another post or that I cannot see', function (Closure $parent): void {
    $this->postJson("/api/v1/posts/{$this->post->id}/comments", ['content' => 'Hi', 'parent_id' => $parent($this->post)->id])
        ->assertUnprocessable()
        ->assertJsonValidationErrors('parent_id');
})->with([
    'other post' => fn (Post $p) => Comment::factory()->create(),
    'hidden' => fn (Post $p) => Comment::factory()->moderated(ModerationStatus::Hidden)->create(['post_id' => $p->id]),
    'deleted' => fn (Post $p) => tap(Comment::factory()->create(['post_id' => $p->id]))->delete(),
]);

it('refuses comments when the author turned them off', function (): void {
    $post = Post::factory()->create(['allow_comments' => false]);

    $this->postJson("/api/v1/posts/{$post->id}/comments", ['content' => 'Hi'])->assertForbidden();
    expect(Comment::query()->count())->toBe(0);
});

it('validates comment content', function (array $payload): void {
    $this->postJson("/api/v1/posts/{$this->post->id}/comments", $payload)
        ->assertUnprocessable()
        ->assertJsonValidationErrors('content');
})->with([
    'missing' => [[]],
    'blank' => [['content' => '   ']],
    'too long' => [['content' => str_repeat('a', 1001)]],
]);

it('hides comments of posts I cannot see (404)', function (Closure $makePost): void {
    $post = $makePost();
    $comment = Comment::factory()->create(['post_id' => $post->id, 'author_profile_id' => $this->me->id]);

    $this->getJson("/api/v1/posts/{$post->id}/comments")->assertNotFound();
    $this->postJson("/api/v1/posts/{$post->id}/comments", ['content' => 'Hi'])->assertNotFound();
    $this->getJson("/api/v1/comments/{$comment->id}/replies")->assertNotFound();
    $this->putJson("/api/v1/comments/{$comment->id}", ['content' => 'Edit'])->assertNotFound();
    $this->deleteJson("/api/v1/comments/{$comment->id}")->assertNotFound();
})->with([
    'only me' => fn () => Post::factory()->onlyMe()->create(),
    'hidden by moderation' => fn () => Post::factory()->moderated(ModerationStatus::Hidden)->create(),
    'deleted' => fn () => tap(Post::factory()->create())->delete(),
]);

it('lists top-level comments oldest first with visible reply counts', function (): void {
    $first = Comment::factory()->create(['post_id' => $this->post->id, 'created_at' => now()->subMinutes(5)]);
    $second = Comment::factory()->create(['post_id' => $this->post->id, 'created_at' => now()->subMinutes(1)]);
    Comment::factory()->replyTo($first)->count(2)->create();
    Comment::factory()->replyTo($first)->moderated(ModerationStatus::Hidden)->create();
    Comment::factory()->moderated(ModerationStatus::UnderReview)->create(['post_id' => $this->post->id]);
    $mineInReview = Comment::factory()->moderated(ModerationStatus::UnderReview)
        ->create(['post_id' => $this->post->id, 'author_profile_id' => $this->me->id]);
    Comment::factory()->moderated(ModerationStatus::Removed)
        ->create(['post_id' => $this->post->id, 'author_profile_id' => $this->me->id]);

    $data = $this->getJson("/api/v1/posts/{$this->post->id}/comments")->assertOk()->json('data');

    expect(collect($data)->pluck('id')->all())->toBe([$first->id, $second->id, $mineInReview->id])
        ->and($data[0]['replies_count'])->toBe(2)
        ->and($data[2]['moderation_status'])->toBe('under_review')
        ->and($data[0])->not->toHaveKey('moderation_status');
});

it('keeps a removed comment with visible replies as an anonymous placeholder', function (): void {
    $root = Comment::factory()->create(['post_id' => $this->post->id, 'content' => 'SECRET ORIGINAL']);
    $reply = Comment::factory()->replyTo($root)->create();
    $root->delete();
    $lonely = tap(Comment::factory()->create(['post_id' => $this->post->id]))->delete();

    $response = $this->getJson("/api/v1/posts/{$this->post->id}/comments")->assertOk();

    expect($response->json('data'))->toHaveCount(1)
        ->and($response->json('data.0.id'))->toBe($root->id)
        ->and($response->json('data.0.is_removed'))->toBeTrue()
        ->and($response->json('data.0.content'))->toBeNull()
        ->and($response->json('data.0.author'))->toBeNull()
        ->and($response->json('data.0.replies_count'))->toBe(1)
        ->and($response->getContent())->not->toContain('SECRET ORIGINAL')->not->toContain($lonely->id);

    expect(commentIds("/api/v1/comments/{$root->id}/replies"))->toBe([$reply->id]);
});

it('lists replies oldest first with a cursor', function (): void {
    $root = Comment::factory()->create(['post_id' => $this->post->id]);
    Comment::factory()->replyTo($root)->count(3)
        ->sequence(fn ($s) => ['created_at' => now()->subMinutes(10 - $s->index)])->create();

    $page1 = $this->getJson("/api/v1/comments/{$root->id}/replies?per_page=2")->assertOk()
        ->assertJsonCount(2, 'data')->assertJsonPath('meta.pagination.has_more', true);
    $page2 = $this->getJson("/api/v1/comments/{$root->id}/replies?per_page=2&cursor=".$page1->json('meta.pagination.next_cursor'))
        ->assertJsonCount(1, 'data')->assertJsonPath('meta.pagination.has_more', false);

    $ids = [...$page1->json('data.*.id'), ...$page2->json('data.*.id')];
    expect($ids)->toBe(Comment::query()->where('parent_id', $root->id)->orderBy('created_at')->pluck('id')->all());
});

it('404s the replies endpoint for a reply', function (): void {
    $reply = Comment::factory()->replyTo(Comment::factory()->create(['post_id' => $this->post->id]))->create();

    $this->getJson("/api/v1/comments/{$reply->id}/replies")->assertNotFound();
});

it('lets me edit and delete only my own comments', function (): void {
    $mine = Comment::factory()->create(['post_id' => $this->post->id, 'author_profile_id' => $this->me->id]);
    $theirs = Comment::factory()->create(['post_id' => $this->post->id]);
    $theirsHidden = Comment::factory()->moderated(ModerationStatus::Hidden)->create(['post_id' => $this->post->id]);

    $this->putJson("/api/v1/comments/{$mine->id}", ['content' => 'Edited with care'])
        ->assertOk()
        ->assertJsonPath('data.content', 'Edited with care')
        ->assertJsonPath('data.edited', true);

    // SRS §13.3: users cannot edit or delete another user's content.
    $this->putJson("/api/v1/comments/{$theirs->id}", ['content' => 'Hacked'])->assertForbidden();
    $this->deleteJson("/api/v1/comments/{$theirs->id}")->assertForbidden();
    $this->putJson("/api/v1/comments/{$theirsHidden->id}", ['content' => 'Hacked'])->assertNotFound();
    expect($theirs->fresh()?->content)->not->toBe('Hacked');

    $this->deleteJson("/api/v1/comments/{$mine->id}")->assertNoContent();
    $this->deleteJson("/api/v1/comments/{$mine->id}")->assertNotFound();
    $this->putJson("/api/v1/comments/{$mine->id}", ['content' => 'Back?'])->assertNotFound();
    expect(Comment::withTrashed()->find($mine->id)?->deleted_at)->not->toBeNull();
});

it('does not mark a comment edited when the text is unchanged', function (): void {
    $mine = Comment::factory()->create(['post_id' => $this->post->id, 'author_profile_id' => $this->me->id, 'content' => 'Same']);

    $this->putJson("/api/v1/comments/{$mine->id}", ['content' => 'Same'])->assertOk()->assertJsonPath('data.edited', false);
});

it('counts visible comments on the post and feeds them into the popular score', function (): void {
    $this->postJson("/api/v1/posts/{$this->post->id}/comments", ['content' => 'One'])->assertCreated();
    $id = $this->postJson("/api/v1/posts/{$this->post->id}/comments", ['content' => 'Two'])->json('data.id');
    Comment::factory()->moderated(ModerationStatus::Hidden)->create(['post_id' => $this->post->id]);

    // The author's own comment doesn't raise the score.
    actAs($this->author);
    $this->postJson("/api/v1/posts/{$this->post->id}/comments", ['content' => 'Thank you'])->assertCreated();

    expect($this->post->fresh()?->score)->toBe(4);
    $this->getJson("/api/v1/posts/{$this->post->id}")->assertJsonPath('data.comments_count', 3);

    actAs($this->me);
    $this->deleteJson("/api/v1/comments/{$id}")->assertNoContent();
    expect($this->post->fresh()?->score)->toBe(2);
});

it('404s malformed ids instead of erroring', function (): void {
    $this->getJson('/api/v1/posts/not-a-uuid/comments')->assertNotFound();
    $this->putJson('/api/v1/comments/123', ['content' => 'x'])->assertNotFound();
    $this->getJson('/api/v1/posts/not-a-uuid')->assertNotFound();
});

it('loads comments with a constant number of queries (no N+1)', function (): void {
    Comment::factory()->count(2)->create(['post_id' => $this->post->id]);
    $this->getJson("/api/v1/posts/{$this->post->id}/comments")->assertOk(); // warm-up
    DB::enableQueryLog();
    $this->getJson("/api/v1/posts/{$this->post->id}/comments")->assertOk();
    $few = count(DB::getQueryLog());

    $more = Comment::factory()->count(8)->create(['post_id' => $this->post->id]);
    Comment::factory()->replyTo($more->first())->count(3)->create();
    DB::flushQueryLog();
    $this->getJson("/api/v1/posts/{$this->post->id}/comments")->assertOk();

    expect(count(DB::getQueryLog()))->toBe($few);
});
