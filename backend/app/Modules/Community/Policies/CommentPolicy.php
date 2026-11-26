<?php

declare(strict_types=1);

namespace App\Modules\Community\Policies;

use App\Modules\Auth\Models\User;
use App\Modules\Community\Enums\ModerationStatus;
use App\Modules\Community\Models\Comment;
use Illuminate\Auth\Access\Response;

/**
 * Only the author may edit or delete a comment (FR-COM-004). Others' comments they can't
 * see → 404; visible comments by someone else → 403. Callers check the post first.
 */
final class CommentPolicy
{
    public function update(User $user, Comment $comment): Response
    {
        if (! $this->isAuthor($user, $comment)) {
            return $comment->moderation_status === ModerationStatus::Visible ? Response::deny() : Response::denyAsNotFound();
        }

        return $comment->moderation_status !== ModerationStatus::Removed ? Response::allow() : Response::denyAsNotFound();
    }

    public function delete(User $user, Comment $comment): Response
    {
        if (! $this->isAuthor($user, $comment)) {
            return $comment->moderation_status === ModerationStatus::Visible ? Response::deny() : Response::denyAsNotFound();
        }

        return Response::allow();
    }

    private function isAuthor(User $user, Comment $comment): bool
    {
        return $comment->author->user_id === $user->id;
    }
}
