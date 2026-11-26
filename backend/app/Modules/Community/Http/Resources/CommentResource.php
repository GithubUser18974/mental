<?php

declare(strict_types=1);

namespace App\Modules\Community\Http\Resources;

use App\Modules\Community\Models\Comment;
use App\Support\Time\Iso8601;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * A comment as seen by the requesting member. The author appears only as their anonymous
 * profile. A deleted or moderated comment kept as a thread placeholder exposes neither
 * its text nor its author (`is_removed: true`).
 *
 * Requires the `post` relation (set by BuildCommentThread / the controller) for the
 * "post author" badge. The viewer comes from PostResource::setViewer().
 *
 * @property Comment $resource
 */
final class CommentResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $comment = $this->resource;
        $viewer = $request->attributes->get(PostResource::VIEWER_ATTRIBUTE);
        $viewer = is_string($viewer) ? $viewer : null;
        $visible = $comment->isVisibleTo($viewer);
        $isOwn = $visible && $comment->isAuthoredBy($viewer);

        return [
            'id' => $comment->id,
            'post_id' => $comment->post_id,
            'parent_id' => $comment->parent_id,
            'is_removed' => ! $visible,
            'author' => $visible ? [
                'id' => $comment->author->id,
                'username' => $comment->author->username,
                'avatar' => $comment->author->avatar,
            ] : null,
            'content' => $visible ? $comment->content : null,
            'is_own' => $isOwn,
            'is_post_author' => $visible && $comment->author_profile_id === $comment->post->author_profile_id,
            'moderation_status' => $this->when($isOwn, fn (): string => $comment->moderation_status->value),
            'replies_count' => $this->when($comment->isTopLevel(), fn (): int => (int) $comment->replies_count),
            'edited' => $visible && $comment->edited_at !== null,
            'created_at' => Iso8601::format($comment->created_at),
        ];
    }
}
