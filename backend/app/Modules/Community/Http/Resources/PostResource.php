<?php

declare(strict_types=1);

namespace App\Modules\Community\Http\Resources;

use App\Modules\Community\Models\Post;
use App\Modules\Community\Models\PostMedia;
use App\Support\Time\Iso8601;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * A post as seen by the requesting member. Explicit whitelist: the author appears ONLY as
 * their anonymous profile (id, username, avatar) — never user ids, emails or account data.
 *
 * Engagement fields (reactions, comments_count, is_saved) need the post loaded through
 * Post::withEngagement($viewer) — otherwise they read as zero / false.
 *
 * @property Post $resource
 */
final class PostResource extends JsonResource
{
    /** Request attribute holding the viewer's anonymous profile id (set by controllers). */
    public const string VIEWER_ATTRIBUTE = 'community.viewer_profile_id';

    /**
     * Stored on the base request (`request()`) — the one resources are rendered with —
     * not on a FormRequest copy.
     */
    public static function setViewer(?string $profileId): void
    {
        request()->attributes->set(self::VIEWER_ATTRIBUTE, $profileId);
    }

    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $post = $this->resource;
        $viewer = $request->attributes->get(self::VIEWER_ATTRIBUTE);
        $isOwn = $post->isAuthoredBy(is_string($viewer) ? $viewer : null);
        $counts = $post->reactionCounts();

        return [
            'id' => $post->id,
            'author' => [
                'id' => $post->author->id,
                'username' => $post->author->username,
                'avatar' => $post->author->avatar,
            ],
            'category' => new CategoryResource($post->category),
            'content' => $post->content,
            'hashtags' => $post->hashtags->pluck('name')->values()->all(),
            'content_warning' => $post->content_warning?->value,
            'allow_comments' => $post->allow_comments,
            'visibility' => $post->visibility->value,
            'media' => $post->media->map(static fn (PostMedia $m): MediaResource => new MediaResource($m))->all(),
            // Counts only, never who reacted (FR-COM-005). Loaded by Post::withEngagement().
            'reactions' => [
                'counts' => $counts,
                'total' => array_sum($counts),
                'mine' => $post->viewerReaction()?->value,
            ],
            'comments_count' => (int) $post->comments_count,
            // Private bookmark state of the viewer (FR-COM-007).
            'is_saved' => $post->isSavedByViewer(),
            'is_own' => $isOwn,
            // The author may see moderation state of their own post; others only ever get visible posts.
            'moderation_status' => $this->when($isOwn, fn (): string => $post->moderation_status->value),
            'edited' => $post->edited_at !== null,
            'created_at' => Iso8601::format($post->created_at),
            'updated_at' => Iso8601::format($post->updated_at),
        ];
    }
}
