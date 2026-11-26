<?php

declare(strict_types=1);

namespace App\Modules\Community\Http\Controllers;

use App\Modules\Community\Actions\DiscoverHashtags;
use App\Modules\Community\Http\Requests\SearchRequest;
use App\Modules\Community\Http\Resources\HashtagResource;
use App\Support\Http\ApiResponse;
use Illuminate\Http\JsonResponse;

/**
 * GET /search/hashtags?q= and GET /hashtags/trending (FR-COM-008).
 */
final class HashtagController
{
    public function __construct(private readonly DiscoverHashtags $hashtags) {}

    public function search(SearchRequest $request): JsonResponse
    {
        return ApiResponse::success(HashtagResource::collection($this->hashtags->search($request->text())));
    }

    public function trending(): JsonResponse
    {
        return ApiResponse::success(HashtagResource::collection($this->hashtags->trending()));
    }
}
