<?php

declare(strict_types=1);

namespace App\Modules\Community\DTOs;

use App\Modules\Community\Actions\BuildFeed;
use App\Modules\Community\Enums\FeedSort;

/**
 * Feed / post-search options from GET /posts and GET /search/posts.
 */
final readonly class FeedFilters
{
    public function __construct(
        public FeedSort $sort = FeedSort::Recent,
        public ?string $categoryId = null,
        public ?string $hashtag = null,
        public bool $followingOnly = false,
        public ?string $search = null,
        public int $perPage = BuildFeed::DEFAULT_PER_PAGE,
    ) {}
}
