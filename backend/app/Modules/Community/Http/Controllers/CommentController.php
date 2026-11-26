<?php

declare(strict_types=1);

namespace App\Modules\Community\Http\Controllers;

use App\Modules\Community\Actions\BuildCommentThread;
use App\Modules\Community\Actions\SaveComment;
use App\Modules\Community\Http\Requests\CommentRequest;
use App\Modules\Community\Http\Requests\PageRequest;
use App\Modules\Community\Http\Resources\CommentResource;
use App\Modules\Community\Http\Resources\PostResource;
use App\Modules\Community\Models\Comment;
use App\Modules\Community\Models\Post;
use App\Modules\Community\Support\ViewerProfile;
use App\Support\Http\ApiResponse;
use App\Support\Translation\Message;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Gate;

/**
 * Comments on a post (FR-COM-004). Comment visibility follows the post: if the viewer
 * can't see the post, its comments don't exist for them (404).
 */
final class CommentController
{
    public function __construct(
        private readonly ViewerProfile $viewer,
        private readonly SaveComment $save,
        private readonly BuildCommentThread $thread,
    ) {}

    public function index(PageRequest $request, Post $post): JsonResponse
    {
        Gate::authorize('view', $post);
        $viewerId = $this->viewer->for($request->user())?->id;
        PostResource::setViewer($viewerId);

        return ApiResponse::success(CommentResource::collection($this->thread->topLevel($post, $viewerId, $request->perPage())));
    }

    public function store(CommentRequest $request, Post $post): JsonResponse
    {
        Gate::authorize('view', $post);
        $author = $this->viewer->require($request->user());

        $comment = $this->save->create($post, $author, $request->commentText(), $request->parentId());
        PostResource::setViewer($author->id);

        return ApiResponse::created($this->resource($comment, $post), Message::get('community::messages.comment_created'));
    }

    public function update(CommentRequest $request, Comment $comment): JsonResponse
    {
        $post = $this->visiblePostOf($comment);
        Gate::authorize('update', $comment);

        $comment = $this->save->update($comment, $request->commentText());
        PostResource::setViewer($comment->author_profile_id);

        return ApiResponse::success($this->resource($comment, $post), Message::get('community::messages.comment_updated'));
    }

    public function destroy(Comment $comment): Response
    {
        $this->visiblePostOf($comment);
        Gate::authorize('delete', $comment);

        $this->save->delete($comment);

        return ApiResponse::noContent();
    }

    private function visiblePostOf(Comment $comment): Post
    {
        $post = $comment->post()->first();
        abort_unless($post instanceof Post, 404);
        Gate::authorize('view', $post);

        return $post;
    }

    private function resource(Comment $comment, Post $post): CommentResource
    {
        $comment->load('author')->setRelation('post', $post);
        if ($comment->isTopLevel()) {
            $comment->loadCount(['replies' => fn ($q) => $q->visibleTo($comment->author_profile_id)]);
        }

        return new CommentResource($comment);
    }
}
