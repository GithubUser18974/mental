<?php

declare(strict_types=1);

use App\Modules\Community\Enums\ModerationStatus;
use App\Modules\Community\Enums\ReactionType;
use App\Modules\Community\Events\PostReacted;
use App\Modules\Community\Models\Post;
use App\Modules\Community\Models\PostReaction;
use App\Modules\Identity\Models\AnonymousProfile;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Str;

beforeEach(function (): void {
    $this->me = actAs(AnonymousProfile::factory()->create());
    $this->author = AnonymousProfile::factory()->create();
    $this->post = Post::factory()->create(['author_profile_id' => $this->author->id]);
});

it('requires authentication', function (string $method): void {
    forgetAuth();

    $this->withHeader('Authorization', 'Bearer invalid')
        ->json($method, '/api/v1/posts/'.Str::uuid().'/reactions')
        ->assertUnauthorized();
})->with(['POST', 'DELETE']);

it('adds a supportive reaction and returns counts without revealing who reacted', function (): void {
    Event::fake([PostReacted::class]);
    PostReaction::factory()->create(['post_id' => $this->post->id, 'type' => ReactionType::Support]);

    $response = $this->postJson("/api/v1/posts/{$this->post->id}/reactions", ['type' => 'understand'])
        ->assertOk()
        ->assertJsonPath('data.mine', 'understand')
        ->assertJsonPath('data.total', 2)
        ->assertJsonPath('data.counts', [
            'understand' => 1, 'support' => 1, 'not_alone' => 0, 'proud' => 0, 'thank_you' => 0,
        ]);

    expect(array_keys($response->json('data')))->toBe(['counts', 'total', 'mine'])
        ->and($response->getContent())->not->toContain($this->me->id);

    Event::assertDispatched(PostReacted::class, fn (PostReacted $e): bool => $e->postAuthorProfileId === $this->author->id
        && $e->type === ReactionType::Understand);
});

it('keeps one reaction per member per post — choosing another replaces it', function (): void {
    Event::fake([PostReacted::class]);

    $this->postJson("/api/v1/posts/{$this->post->id}/reactions", ['type' => 'understand'])->assertOk();
    $this->postJson("/api/v1/posts/{$this->post->id}/reactions", ['type' => 'proud'])
        ->assertOk()
        ->assertJsonPath('data.mine', 'proud')
        ->assertJsonPath('data.total', 1);
    $this->postJson("/api/v1/posts/{$this->post->id}/reactions", ['type' => 'proud'])->assertOk();

    expect(PostReaction::query()->where('post_id', $this->post->id)->count())->toBe(1);
    Event::assertDispatchedTimes(PostReacted::class, 1);
});

it('removes my reaction (idempotently)', function (): void {
    $this->postJson("/api/v1/posts/{$this->post->id}/reactions", ['type' => 'support'])->assertOk();

    $this->deleteJson("/api/v1/posts/{$this->post->id}/reactions")->assertNoContent();
    $this->deleteJson("/api/v1/posts/{$this->post->id}/reactions")->assertNoContent();

    expect(PostReaction::query()->count())->toBe(0);
});

it('shows reaction counts and my reaction on posts in the feed and details', function (): void {
    PostReaction::factory()->count(2)->create(['post_id' => $this->post->id, 'type' => ReactionType::NotAlone]);
    $this->postJson("/api/v1/posts/{$this->post->id}/reactions", ['type' => 'thank_you'])->assertOk();

    $this->getJson('/api/v1/posts')
        ->assertJsonPath('data.0.reactions.total', 3)
        ->assertJsonPath('data.0.reactions.counts.not_alone', 2)
        ->assertJsonPath('data.0.reactions.mine', 'thank_you');

    actAs(AnonymousProfile::factory()->create());
    $this->getJson("/api/v1/posts/{$this->post->id}")
        ->assertJsonPath('data.reactions.total', 3)
        ->assertJsonPath('data.reactions.mine', null);
});

it('raises the popular score, but not for reactions on my own post', function (): void {
    Event::fake([PostReacted::class]);

    $this->postJson("/api/v1/posts/{$this->post->id}/reactions", ['type' => 'support'])->assertOk();
    expect($this->post->fresh()?->score)->toBe(1);

    actAs($this->author);
    $this->postJson("/api/v1/posts/{$this->post->id}/reactions", ['type' => 'proud'])->assertOk();
    expect($this->post->fresh()?->score)->toBe(1);
    Event::assertDispatchedTimes(PostReacted::class, 1); // no notification about yourself

    actAs($this->me);
    $this->deleteJson("/api/v1/posts/{$this->post->id}/reactions")->assertNoContent();
    expect($this->post->fresh()?->score)->toBe(0);
});

it('rejects unknown reaction types', function (array $payload): void {
    $this->postJson("/api/v1/posts/{$this->post->id}/reactions", $payload)
        ->assertUnprocessable()
        ->assertJsonValidationErrors('type');
})->with([
    'missing' => [[]],
    'like' => [['type' => 'like']],
]);

it('cannot react to posts I cannot see (404)', function (Closure $makePost): void {
    $post = $makePost();

    $this->postJson("/api/v1/posts/{$post->id}/reactions", ['type' => 'support'])->assertNotFound();
    $this->deleteJson("/api/v1/posts/{$post->id}/reactions")->assertNotFound();
    expect(PostReaction::query()->count())->toBe(0);
})->with([
    'only me' => fn () => Post::factory()->onlyMe()->create(),
    'under review' => fn () => Post::factory()->moderated(ModerationStatus::UnderReview)->create(),
    'deleted' => fn () => tap(Post::factory()->create())->delete(),
]);
