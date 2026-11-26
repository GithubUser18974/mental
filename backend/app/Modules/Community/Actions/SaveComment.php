<?php

declare(strict_types=1);

namespace App\Modules\Community\Actions;

use App\Modules\Community\Events\CommentCreated;
use App\Modules\Community\Models\Comment;
use App\Modules\Community\Models\Post;
use App\Modules\Identity\Models\AnonymousProfile;
use App\Modules\Identity\Services\SocialGraph;
use App\Support\Exceptions\ApiException;
use App\Support\Translation\Message;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

/**
 * Adds, edits and deletes comments (FR-COM-004).
 *
 * Threading is one level deep: replying to a reply attaches the new comment to the same
 * top-level comment, so threads stay readable on a phone.
 */
final readonly class SaveComment
{
    public function __construct(private RefreshPostScore $refreshScore, private SocialGraph $graph) {}

    public function create(Post $post, AnonymousProfile $author, string $content, ?string $parentId): Comment
    {
        if (! $post->allow_comments) {
            throw new ApiException(Message::get('community::messages.comments_disabled'), 403);
        }

        $repliedTo = $parentId !== null ? $this->replyTarget($post, $author, $parentId) : null;

        $comment = DB::transaction(function () use ($post, $author, $content, $repliedTo): Comment {
            $comment = Comment::query()->create([
                'post_id' => $post->id,
                'author_profile_id' => $author->id,
                'parent_id' => $repliedTo === null ? null : ($repliedTo->parent_id ?? $repliedTo->id),
                'content' => $content,
            ]);

            ($this->refreshScore)($post->id);

            return $comment;
        });

        $recipients = array_values(array_unique(array_filter(
            [$post->author_profile_id, $repliedTo?->author_profile_id],
            static fn (?string $id): bool => $id !== null && $id !== $author->id,
        )));
        if ($recipients !== []) {
            CommentCreated::dispatch($comment->id, $post->id, $recipients);
        }

        return $comment;
    }

    public function update(Comment $comment, string $content): Comment
    {
        $comment->content = $content;

        if ($comment->isDirty('content')) {
            $comment->edited_at = CarbonImmutable::now();
        }
        $comment->save();

        return $comment;
    }

    public function delete(Comment $comment): void
    {
        DB::transaction(function () use ($comment): void {
            $comment->delete();
            ($this->refreshScore)($comment->post_id);
        });
    }

    /**
     * The comment being replied to: on the same post and readable by the author.
     */
    private function replyTarget(Post $post, AnonymousProfile $author, string $parentId): Comment
    {
        $parent = Comment::query()->where('post_id', $post->id)->find($parentId);

        // Includes blocks: you can't reply to someone hidden from you (FR-COM-009).
        if (! $parent instanceof Comment || ! $parent->isVisibleTo($author->id, $this->graph->hiddenProfileIds($author->id))) {
            throw ValidationException::withMessages([
                'parent_id' => [Message::get('community::messages.comment_parent_invalid')],
            ]);
        }

        return $parent;
    }
}
