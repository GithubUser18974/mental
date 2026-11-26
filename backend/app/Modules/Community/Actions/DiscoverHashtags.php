<?php

declare(strict_types=1);

namespace App\Modules\Community\Actions;

use App\Modules\Community\Enums\ModerationStatus;
use App\Modules\Community\Enums\PostVisibility;
use App\Modules\Community\Models\Hashtag;
use App\Modules\Community\Support\HashtagExtractor;
use App\Support\Database\LikePattern;
use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Query\JoinClause;

/**
 * Hashtag search and trending hashtags (FR-COM-008). Counts only public, visible,
 * non-deleted posts. Trending applies the same safety rule as the popular feed: posts
 * with a content warning never push a hashtag up (FR-COM-001 no amplification).
 */
final class DiscoverHashtags
{
    public const int SEARCH_LIMIT = 20;

    public const int TRENDING_LIMIT = 10;

    public const int TRENDING_WINDOW_DAYS = 7;

    /**
     * Hashtags containing the text, prefix matches first, then by popularity.
     *
     * @return Collection<int, Hashtag>
     */
    public function search(string $text): Collection
    {
        $needle = HashtagExtractor::normalize($text);
        if ($needle === '') {
            return new Collection;
        }

        return $this->withPublicPostCounts(Hashtag::query())
            ->where('hashtags.name', 'like', LikePattern::contains($needle))
            ->orderByRaw('CASE WHEN hashtags.name LIKE ? THEN 0 ELSE 1 END', [LikePattern::startsWith($needle)])
            ->orderByDesc('posts_count')
            ->orderBy('hashtags.name')
            ->limit(self::SEARCH_LIMIT)
            ->get();
    }

    /**
     * @return Collection<int, Hashtag>
     */
    public function trending(): Collection
    {
        return $this->withPublicPostCounts(Hashtag::query(), static function (JoinClause $posts): void {
            $posts->whereNull('posts.content_warning')
                ->where('posts.created_at', '>=', CarbonImmutable::now()->subDays(self::TRENDING_WINDOW_DAYS));
        })
            ->orderByDesc('posts_count')
            ->orderBy('hashtags.name')
            ->limit(self::TRENDING_LIMIT)
            ->get();
    }

    /**
     * @param  Builder<Hashtag>  $query
     * @param  (callable(JoinClause): void)|null  $postConditions
     * @return Builder<Hashtag>
     */
    private function withPublicPostCounts(Builder $query, ?callable $postConditions = null): Builder
    {
        return $query
            ->join('post_hashtags', 'post_hashtags.hashtag_id', '=', 'hashtags.id')
            ->join('posts', static function (JoinClause $posts) use ($postConditions): void {
                $posts->on('posts.id', '=', 'post_hashtags.post_id')
                    ->whereNull('posts.deleted_at')
                    ->where('posts.visibility', PostVisibility::Community->value)
                    ->where('posts.moderation_status', ModerationStatus::Visible->value);

                if ($postConditions !== null) {
                    $postConditions($posts);
                }
            })
            ->groupBy('hashtags.id', 'hashtags.name')
            ->select('hashtags.id', 'hashtags.name')
            ->selectRaw('count(posts.id) as posts_count');
    }
}
