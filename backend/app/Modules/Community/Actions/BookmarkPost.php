<?php

declare(strict_types=1);

namespace App\Modules\Community\Actions;

use App\Modules\Community\Models\Post;
use App\Modules\Community\Models\SavedPost;
use Carbon\CarbonImmutable;
use Illuminate\Support\Str;

/**
 * Private bookmarks (FR-COM-007). Both operations are idempotent.
 */
final class BookmarkPost
{
    public function save(Post $post, string $profileId): void
    {
        SavedPost::query()->insertOrIgnore([
            'id' => (string) Str::uuid7(),
            'profile_id' => $profileId,
            'post_id' => $post->id,
            'created_at' => CarbonImmutable::now(),
        ]);
    }

    public function unsave(Post $post, string $profileId): void
    {
        SavedPost::query()->where('profile_id', $profileId)->where('post_id', $post->id)->delete();
    }
}
