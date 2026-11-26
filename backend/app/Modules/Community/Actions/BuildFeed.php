<?php

declare(strict_types=1);

namespace App\Modules\Community\Actions;

use App\Modules\Community\DTOs\FeedFilters;
use App\Modules\Community\Enums\FeedSort;
use App\Modules\Community\Models\Post;
use App\Modules\Community\Support\HashtagExtractor;
use App\Modules\Identity\Services\SocialGraph;
use App\Support\Database\LikePattern;
use Carbon\CarbonImmutable;
use Illuminate\Contracts\Pagination\CursorPaginator;
use Illuminate\Database\Eloquent\Builder;

/**
 * Community feed queries (FR-COM-001/008). Only publicly visible posts (plus the viewer's
 * own, where noted), never soft-deleted ones, and never posts by members hidden from the
 * viewer by a block in either direction (FR-COM-009).
 *
 * Safety (FR-COM-001): "popular" is limited to the last week and never boosts posts with a
 * content warning — sensitive or crisis-related content is not amplified by ranking.
 */
final readonly class BuildFeed
{
    public const int DEFAULT_PER_PAGE = 20;

    public const int MAX_PER_PAGE = 50;

    public const int POPULAR_WINDOW_DAYS = 7;

    public function __construct(private SocialGraph $graph) {}

    /**
     * @return CursorPaginator<int, Post>
     */
    public function community(FeedFilters $filters, ?string $viewerProfileId): CursorPaginator
    {
        $query = $this->base($viewerProfileId)->publiclyVisible();

        if ($filters->categoryId !== null) {
            $query->where('posts.category_id', $filters->categoryId);
        }

        if ($filters->hashtag !== null && $filters->hashtag !== '') {
            $query->whereHas('hashtags', fn (Builder $q) => $q->where('name', HashtagExtractor::normalize($filters->hashtag)));
        }

        if ($filters->search !== null && $filters->search !== '') {
            $query->where('posts.content', 'ilike', LikePattern::contains($filters->search));
        }

        // FR-COM-001 "posts from followed users".
        if ($filters->followingOnly && $viewerProfileId !== null) {
            $query->whereIn('posts.author_profile_id', $this->graph->followedProfileIdsQuery($viewerProfileId));
        }

        if ($filters->sort === FeedSort::Popular) {
            $query->whereNull('posts.content_warning')
                ->where('posts.created_at', '>=', CarbonImmutable::now()->subDays(self::POPULAR_WINDOW_DAYS))
                ->orderByDesc('posts.score');
        }

        return $query->orderByDesc('posts.created_at')->orderByDesc('posts.id')->cursorPaginate($this->perPage($filters->perPage));
    }

    /**
     * A member's posts as seen by the viewer (own profile → includes "only me" posts).
     * Callers 404 hidden authors before getting here.
     *
     * @return CursorPaginator<int, Post>
     */
    public function byAuthor(string $authorProfileId, ?string $viewerProfileId, int $perPage): CursorPaginator
    {
        $query = $this->base($viewerProfileId)->where('posts.author_profile_id', $authorProfileId);

        $authorProfileId === $viewerProfileId
            ? $query->visibleTo($viewerProfileId)
            : $query->publiclyVisible();

        return $query->orderByDesc('posts.created_at')->orderByDesc('posts.id')->cursorPaginate($this->perPage($perPage));
    }

    /**
     * The viewer's private bookmarks (FR-COM-007), most recently saved first. Posts that
     * are no longer visible to them (deleted, hidden, made private, author blocked) drop
     * out silently.
     *
     * @return CursorPaginator<int, Post>
     */
    public function saved(string $viewerProfileId, int $perPage): CursorPaginator
    {
        return $this->base($viewerProfileId)
            ->join('saved_posts', 'saved_posts.post_id', '=', 'posts.id')
            ->where('saved_posts.profile_id', $viewerProfileId)
            ->visibleTo($viewerProfileId)
            ->addSelect(['saved_posts.created_at as saved_at', 'saved_posts.id as saved_id'])
            ->orderByDesc('saved_at')
            ->orderByDesc('saved_id')
            ->cursorPaginate($this->perPage($perPage));
    }

    /**
     * @return Builder<Post>
     */
    private function base(?string $viewerProfileId): Builder
    {
        $query = Post::query()
            ->select('posts.*')
            ->withEngagement($viewerProfileId)
            ->with(['author', 'category', 'media', 'hashtags']);

        if ($viewerProfileId !== null) {
            $query->whereNotIn('posts.author_profile_id', $this->graph->hiddenProfileIdsQuery($viewerProfileId));
        }

        return $query;
    }

    private function perPage(int $requested): int
    {
        return max(1, min(self::MAX_PER_PAGE, $requested > 0 ? $requested : self::DEFAULT_PER_PAGE));
    }
}
