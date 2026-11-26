<?php

declare(strict_types=1);

use App\Modules\Auth\Enums\AccountStatus;
use App\Modules\Community\Enums\ModerationStatus;
use App\Modules\Community\Models\Post;
use App\Modules\Community\Models\PostMedia;
use App\Modules\Identity\Models\AnonymousProfile;
use Illuminate\Support\Str;

function mediaFor(AnonymousProfile $profile, ?string $postId = null): PostMedia
{
    return PostMedia::query()->create([
        'uploader_profile_id' => $profile->id,
        'post_id' => $postId,
        'disk' => 'local',
        'path' => 'post-media/test/'.Str::uuid().'.jpg',
        'mime' => 'image/jpeg',
        'width' => 800,
        'height' => 600,
        'size_bytes' => 1234,
    ]);
}

beforeEach(function (): void {
    $this->me = actAs(AnonymousProfile::factory()->create(['username' => 'SoftHarbor']));
});

it('requires authentication', function (string $method, string $uri): void {
    forgetAuth();
    $this->app['auth']->forgetGuards();

    $this->withHeader('Authorization', 'Bearer invalid')->json($method, $uri)->assertUnauthorized();
})->with([
    ['GET', '/api/v1/posts'],
    ['POST', '/api/v1/posts'],
    ['GET', '/api/v1/categories'],
    ['GET', '/api/v1/profile/interests'],
    ['POST', '/api/v1/media'],
    ['GET', '/api/v1/profiles/SoftHarbor/posts'],
]);

it('creates a post authored by the anonymous profile, with hashtags', function (): void {
    $response = $this->postJson('/api/v1/posts', [
        'content' => '  Small win today: I went for a walk. #Recovery #خطوة_صغيرة  ',
        'category' => 'recovery-journey',
        'content_warning' => null,
        'allow_comments' => false,
    ])
        ->assertCreated()
        ->assertJsonPath('message', 'Your post has been shared.')
        ->assertJsonPath('data.author', ['id' => $this->me->id, 'username' => 'SoftHarbor', 'avatar' => $this->me->avatar])
        ->assertJsonPath('data.category.slug', 'recovery-journey')
        ->assertJsonPath('data.content', 'Small win today: I went for a walk. #Recovery #خطوة_صغيرة')
        ->assertJsonPath('data.hashtags', ['recovery', 'خطوة_صغيرة'])
        ->assertJsonPath('data.allow_comments', false)
        ->assertJsonPath('data.visibility', 'community')
        ->assertJsonPath('data.is_own', true)
        ->assertJsonPath('data.moderation_status', 'visible')
        ->assertJsonPath('data.edited', false);

    $post = Post::query()->sole();
    expect($post->author_profile_id)->toBe($this->me->id);

    // Community responses never carry account identity.
    expect($response->getContent())
        ->not->toContain($this->me->user_id)
        ->not->toContain($this->me->user->email)
        ->not->toContain('user_id');
});

it('validates post input', function (array $payload, array $errors): void {
    $this->postJson('/api/v1/posts', $payload)->assertUnprocessable()->assertJsonValidationErrors($errors);
})->with([
    'missing everything' => [[], ['content', 'category']],
    'blank content' => [['content' => '   ', 'category' => 'my-story'], ['content']],
    'too long' => [['content' => str_repeat('a', 2001), 'category' => 'my-story'], ['content']],
    'unknown category' => [['content' => 'hi', 'category' => 'politics'], ['category']],
    'unknown warning' => [['content' => 'hi', 'category' => 'my-story', 'content_warning' => 'gore'], ['content_warning']],
    'bad visibility' => [['content' => 'hi', 'category' => 'my-story', 'visibility' => 'friends'], ['visibility']],
    'too many images' => [['content' => 'hi', 'category' => 'my-story', 'media_ids' => array_map(static fn () => (string) Str::uuid(), range(1, 5))], ['media_ids']],
]);

it('rejects a deactivated category', function (): void {
    App\Modules\Community\Models\PostCategory::query()->where('slug', 'questions')->update(['is_active' => false]);

    $this->postJson('/api/v1/posts', ['content' => 'hi', 'category' => 'questions'])
        ->assertUnprocessable()
        ->assertJsonValidationErrors('category');
});

it('attaches the author\'s own uploads in order', function (): void {
    $first = mediaFor($this->me);
    $second = mediaFor($this->me);

    $this->postJson('/api/v1/posts', [
        'content' => 'With photos',
        'category' => 'daily-thoughts',
        'media_ids' => [$second->id, $first->id],
    ])
        ->assertCreated()
        ->assertJsonPath('data.media.0.id', $second->id)
        ->assertJsonPath('data.media.1.id', $first->id)
        ->assertJsonPath('data.media.0.width', 800);

    expect($first->fresh()?->position)->toBe(1);
});

it('never attaches another member\'s image or one already used on another post', function (): void {
    $stranger = AnonymousProfile::factory()->create();
    $strangersImage = mediaFor($stranger);
    $myUsedImage = mediaFor($this->me, Post::factory()->create(['author_profile_id' => $this->me->id])->id);

    foreach ([$strangersImage, $myUsedImage] as $media) {
        $this->postJson('/api/v1/posts', ['content' => 'x', 'category' => 'my-story', 'media_ids' => [$media->id]])
            ->assertUnprocessable()
            ->assertJsonPath('errors.media_ids.0', 'One or more images can’t be attached. Please upload them again.');
    }

    expect($strangersImage->fresh()?->post_id)->toBeNull();
});

it('shows a public post to any member', function (): void {
    $post = Post::factory()->create(['content' => 'Hello']);

    $this->getJson('/api/v1/posts/'.$post->id)
        ->assertOk()
        ->assertJsonPath('data.content', 'Hello')
        ->assertJsonPath('data.is_own', false)
        ->assertJsonMissingPath('data.moderation_status');
});

it('treats posts others cannot see as non-existent (404)', function (string $case): void {
    $other = AnonymousProfile::factory()->create();
    $post = match ($case) {
        'only me' => Post::factory()->onlyMe()->create(['author_profile_id' => $other->id]),
        'hidden by moderators' => Post::factory()->moderated(ModerationStatus::Hidden)->create(['author_profile_id' => $other->id]),
        'under review' => Post::factory()->moderated(ModerationStatus::UnderReview)->create(['author_profile_id' => $other->id]),
        'deleted' => tap(Post::factory()->create(['author_profile_id' => $other->id]))->delete(),
    };

    $this->getJson('/api/v1/posts/'.$post->id)->assertNotFound();
    $this->putJson('/api/v1/posts/'.$post->id, ['content' => 'x'])->assertNotFound();
    $this->deleteJson('/api/v1/posts/'.$post->id)->assertNotFound();
})->with(['only me', 'hidden by moderators', 'under review', 'deleted']);

it('lets authors see their own private and under-review posts, but not removed ones', function (): void {
    $private = Post::factory()->onlyMe()->create(['author_profile_id' => $this->me->id]);
    $review = Post::factory()->moderated(ModerationStatus::UnderReview)->create(['author_profile_id' => $this->me->id]);
    $removed = Post::factory()->moderated(ModerationStatus::Removed)->create(['author_profile_id' => $this->me->id]);

    $this->getJson('/api/v1/posts/'.$private->id)->assertOk()->assertJsonPath('data.visibility', 'only_me');
    $this->getJson('/api/v1/posts/'.$review->id)->assertOk()->assertJsonPath('data.moderation_status', 'under_review');
    $this->getJson('/api/v1/posts/'.$removed->id)->assertNotFound();
});

it('lets the author edit; marks edited and re-syncs hashtags', function (): void {
    $post = Post::factory()->create(['author_profile_id' => $this->me->id, 'content' => 'Old #old']);
    $this->putJson('/api/v1/posts/'.$post->id, ['content' => 'Old #old'])->assertOk(); // create hashtag link

    $this->putJson('/api/v1/posts/'.$post->id, [
        'content' => 'New thoughts #new',
        'category' => 'questions',
        'visibility' => 'only_me',
    ])
        ->assertOk()
        ->assertJsonPath('message', 'Your post has been updated.')
        ->assertJsonPath('data.content', 'New thoughts #new')
        ->assertJsonPath('data.hashtags', ['new'])
        ->assertJsonPath('data.category.slug', 'questions')
        ->assertJsonPath('data.visibility', 'only_me')
        ->assertJsonPath('data.edited', true);
});

it('does not mark a post edited when only settings change', function (): void {
    $post = Post::factory()->create(['author_profile_id' => $this->me->id]);

    $this->putJson('/api/v1/posts/'.$post->id, ['allow_comments' => false])
        ->assertOk()
        ->assertJsonPath('data.edited', false);
});

it('forbids editing or deleting someone else\'s post (SRS §13.3 #8)', function (): void {
    $post = Post::factory()->create();

    $this->putJson('/api/v1/posts/'.$post->id, ['content' => 'hijacked'])->assertForbidden();
    $this->deleteJson('/api/v1/posts/'.$post->id)->assertForbidden();

    expect($post->fresh()?->content)->not->toBe('hijacked');
});

it('soft-deletes and then hides the post everywhere (SRS §13.3 #6)', function (): void {
    $post = Post::factory()->create(['author_profile_id' => $this->me->id]);

    $this->deleteJson('/api/v1/posts/'.$post->id)->assertNoContent();

    expect(Post::withTrashed()->find($post->id)?->deleted_at)->not->toBeNull();
    $this->getJson('/api/v1/posts/'.$post->id)->assertNotFound();
    expect(collect($this->getJson('/api/v1/posts')->json('data'))->pluck('id'))->not->toContain($post->id);
    expect(collect($this->getJson('/api/v1/profiles/SoftHarbor/posts')->json('data'))->pluck('id'))->not->toContain($post->id);
});

it('blocks suspended accounts from posting', function (): void {
    $this->me->user->forceFill(['status' => AccountStatus::Suspended])->save();

    $this->postJson('/api/v1/posts', ['content' => 'hi', 'category' => 'my-story'])->assertForbidden();
});

it('rate-limits post creation', function (): void {
    foreach (range(1, 20) as $i) {
        $this->postJson('/api/v1/posts', ['content' => 'post '.$i, 'category' => 'daily-thoughts'])->assertCreated();
    }

    $this->postJson('/api/v1/posts', ['content' => 'one more', 'category' => 'daily-thoughts'])->assertTooManyRequests();
});
