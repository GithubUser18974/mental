<?php

declare(strict_types=1);

namespace App\Modules\Community\Http\Controllers;

use App\Modules\Community\Actions\BuildCommentThread;
use App\Modules\Community\Http\Requests\PageRequest;
use App\Modules\Community\Http\Resources\CommentResource;
use App\Modules\Community\Http\Resources\PostResource;
use App\Modules\Community\Models\Comment;
use App\Modules\Community\Models\Post;
use App\Modules\Community\Support\ViewerProfile;
use App\Support\Http\ApiResponse;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Gate;

/**
 * GET /comments/{comment}/replies. The route binds deleted comments too, so a removed
 * top-level comment's replies stay reachable under its placeholder.
 */
final class CommentRepliesController
{
    public function __invoke(PageRequest $request, Comment $comment, ViewerProfile $viewer, BuildCommentThread $thread): JsonResponse
    {
        abort_unless($comment->isTopLevel(), 404);
        $post = $comment->post()->first();
        abort_unless($post instanceof Post, 404);
        Gate::authorize('view', $post);

        $viewerId = $viewer->for($request->user())?->id;
        PostResource::setViewer($viewerId);

        return ApiResponse::success(CommentResource::collection($thread->replies($comment, $post, $viewerId, $request->perPage())));
    }
}
