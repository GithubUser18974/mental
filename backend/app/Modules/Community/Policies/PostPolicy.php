<?php

declare(strict_types=1);

namespace App\Modules\Community\Policies;

use App\Modules\Auth\Models\User;
use App\Modules\Community\Enums\ModerationStatus;
use App\Modules\Community\Enums\PostVisibility;
use App\Modules\Community\Models\Post;
use App\Modules\Community\Support\ViewerProfile;
use Illuminate\Auth\Access\Response;

/**
 * Posts others can't see behave as if they don't exist (404) — including posts by a
 * member who blocked the viewer or whom the viewer blocked (FR-COM-009). Only the author
 * may edit or delete, and never a post moderation has removed.
 */
final readonly class PostPolicy
{
    public function __construct(private ViewerProfile $viewer) {}

    public function view(User $user, Post $post): Response
    {
        if ($this->isAuthor($user, $post)) {
            return $post->moderation_status !== ModerationStatus::Removed ? Response::allow() : Response::denyAsNotFound();
        }

        $isPublic = $post->visibility === PostVisibility::Community && $post->moderation_status === ModerationStatus::Visible;

        return $isPublic && ! $this->viewer->isHiddenFrom($user, $post->author_profile_id)
            ? Response::allow()
            : Response::denyAsNotFound();
    }

    public function update(User $user, Post $post): Response
    {
        return $this->isAuthor($user, $post) && $post->moderation_status !== ModerationStatus::Removed
            ? Response::allow()
            : Response::deny();
    }

    public function delete(User $user, Post $post): Response
    {
        return $this->isAuthor($user, $post) ? Response::allow() : Response::deny();
    }

    private function isAuthor(User $user, Post $post): bool
    {
        return $this->viewer->for($user)?->id === $post->author_profile_id;
    }
}
