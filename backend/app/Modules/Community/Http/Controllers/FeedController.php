<?php

declare(strict_types=1);

namespace App\Modules\Community\Http\Controllers;

use App\Modules\Community\Actions\BuildFeed;
use App\Modules\Community\Http\Requests\FeedRequest;
use App\Modules\Community\Http\Resources\PostResource;
use App\Modules\Community\Support\ViewerProfile;
use App\Support\Http\ApiResponse;
use Illuminate\Http\JsonResponse;

/**
 * GET /posts — the community feed (recent | popular), filterable by category, hashtag,
 * followed members, and post text (`q`, FR-COM-008).
 */
final class FeedController
{
    public function __invoke(FeedRequest $request, ViewerProfile $viewer, BuildFeed $feed): JsonResponse
    {
        $viewerId = $viewer->for($request->user())?->id;
        PostResource::setViewer($viewerId);

        return ApiResponse::success(PostResource::collection($feed->community($request->filters(), $viewerId)));
    }
}
