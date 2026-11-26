<?php

declare(strict_types=1);

namespace App\Modules\Community\Http\Controllers;

use App\Modules\Community\Actions\BuildFeed;
use App\Modules\Community\Http\Requests\FeedRequest;
use App\Modules\Community\Http\Resources\PostResource;
use App\Modules\Community\Support\ViewerProfile;
use App\Modules\Identity\Models\AnonymousProfile;
use App\Support\Http\ApiResponse;
use Illuminate\Http\JsonResponse;

/**
 * GET /profiles/{username}/posts — a member's public posts (FR-PRO-001). On your own
 * profile this also includes your "only me" posts. 404 when a block exists either way.
 */
final class ProfilePostsController
{
    public function __invoke(FeedRequest $request, string $username, ViewerProfile $viewer, BuildFeed $feed): JsonResponse
    {
        $author = AnonymousProfile::query()->active()->withUsername($username)->firstOrFail();
        abort_if($viewer->isHiddenFrom($request->user(), $author->id), 404);

        $viewerId = $viewer->for($request->user())?->id;
        PostResource::setViewer($viewerId);

        return ApiResponse::success(PostResource::collection($feed->byAuthor($author->id, $viewerId, $request->perPage())));
    }
}
