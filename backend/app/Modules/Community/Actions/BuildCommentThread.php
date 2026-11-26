<?php

declare(strict_types=1);

namespace App\Modules\Community\Actions;

use App\Modules\Community\Models\Comment;
use App\Modules\Community\Models\Post;
use App\Modules\Identity\Services\SocialGraph;
use Illuminate\Contracts\Pagination\CursorPaginator;
use Illuminate\Database\Eloquent\Builder;

/**
 * Comment listings, oldest first (a conversation reads top to bottom).
 *
 * A deleted, moderated or blocked-author top-level comment that still has visible replies
 * is kept as a placeholder ("This comment isn't available") so the replies keep their
 * context. Its text and author are never returned. Comments by members hidden from the
 * viewer by a block are otherwise left out entirely (FR-COM-009).
 */
final readonly class BuildCommentThread
{
    public const int DEFAULT_PER_PAGE = 20;

    public const int MAX_PER_PAGE = 50;

    public function __construct(private SocialGraph $graph) {}

    /**
     * @return CursorPaginator<int, Comment>
     */
    public function topLevel(Post $post, ?string $viewerProfileId, int $perPage): CursorPaginator
    {
        $hidden = $this->hidden($viewerProfileId);

        $visibleReplies = static function (Builder $replies) use ($viewerProfileId, $hidden): Builder {
            /** @var Builder<Comment> $replies */
            return $replies->visibleTo($viewerProfileId, $hidden);
        };

        $page = Comment::query()
            ->withTrashed()
            ->where('post_id', $post->id)
            ->whereNull('parent_id')
            ->where(
                /** @param Builder<Comment> $q */
                fn (Builder $q) => $q->visibleTo($viewerProfileId, $hidden)->orWhereHas('replies', $visibleReplies),
            )
            ->withCount(['replies' => $visibleReplies])
            ->with('author')
            ->orderBy('created_at')
            ->orderBy('id')
            ->cursorPaginate($this->perPage($perPage));

        return $this->prepare($page, $post, $hidden);
    }

    /**
     * @return CursorPaginator<int, Comment>
     */
    public function replies(Comment $root, Post $post, ?string $viewerProfileId, int $perPage): CursorPaginator
    {
        $hidden = $this->hidden($viewerProfileId);

        $page = Comment::query()
            ->where('parent_id', $root->id)
            ->visibleTo($viewerProfileId, $hidden)
            ->with('author')
            ->orderBy('created_at')
            ->orderBy('id')
            ->cursorPaginate($this->perPage($perPage));

        return $this->prepare($page, $post, $hidden);
    }

    /**
     * @return list<string>
     */
    private function hidden(?string $viewerProfileId): array
    {
        return $viewerProfileId === null ? [] : $this->graph->hiddenProfileIds($viewerProfileId);
    }

    /**
     * Attaches the already-loaded post (for the "author" badge) and flags placeholders.
     *
     * @param  CursorPaginator<int, Comment>  $page
     * @param  list<string>  $hidden
     * @return CursorPaginator<int, Comment>
     */
    private function prepare(CursorPaginator $page, Post $post, array $hidden): CursorPaginator
    {
        foreach ($page->items() as $comment) {
            $comment->setRelation('post', $post);
            $comment->authorHiddenFromViewer = in_array($comment->author_profile_id, $hidden, true);
        }

        return $page;
    }

    private function perPage(int $requested): int
    {
        return max(1, min(self::MAX_PER_PAGE, $requested > 0 ? $requested : self::DEFAULT_PER_PAGE));
    }
}
