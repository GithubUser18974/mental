<?php

declare(strict_types=1);

namespace App\Modules\Community\Http\Controllers;

use App\Modules\Community\Actions\BookmarkPost;
use App\Modules\Community\Actions\BuildFeed;
use App\Modules\Community\Http\Requests\PageRequest;
use App\Modules\Community\Http\Resources\PostResource;
use App\Modules\Community\Models\Post;
use App\Modules\Community\Support\ViewerProfile;
use App\Support\Http\ApiResponse;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Gate;

/**
 * Private bookmarks (FR-COM-007): only the owner can list them; never shown on profiles.
 */
final class SavedPostController
{
    public function __construct(private readonly ViewerProfile $viewer, private readonly BookmarkPost $bookmarks) {}

    public function index(PageRequest $request, BuildFeed $feed): JsonResponse
    {
        $profileId = $this->viewer->require($request->user())->id;
        PostResource::setViewer($profileId);

        return ApiResponse::success(PostResource::collection($feed->saved($profileId, $request->perPage())));
    }

    public function store(Request $request, Post $post): Response
    {
        Gate::authorize('view', $post);
        $this->bookmarks->save($post, $this->viewer->require($request->user())->id);

        return ApiResponse::noContent();
    }

    /** No visibility check: removing your own bookmark of a now-hidden post is harmless. */
    public function destroy(Request $request, Post $post): Response
    {
        $this->bookmarks->unsave($post, $this->viewer->require($request->user())->id);

        return ApiResponse::noContent();
    }
}
