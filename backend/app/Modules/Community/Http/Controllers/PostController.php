<?php

declare(strict_types=1);

namespace App\Modules\Community\Http\Controllers;

use App\Modules\Community\Actions\SavePost;
use App\Modules\Community\Http\Requests\PostRequest;
use App\Modules\Community\Http\Resources\PostResource;
use App\Modules\Community\Models\Post;
use App\Modules\Community\Support\ViewerProfile;
use App\Support\Http\ApiResponse;
use App\Support\Translation\Message;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\Facades\Log;

final class PostController
{
    public function __construct(private readonly ViewerProfile $viewer, private readonly SavePost $save) {}

    public function store(PostRequest $request): JsonResponse
    {
        $author = $this->viewer->require($request->user());
        $post = $this->save->create($author, $request->postData());

        PostResource::setViewer($author->id);

        return ApiResponse::created($this->resource($post, $author->id), Message::get('community::messages.post_created'));
    }

    public function show(Request $request, Post $post): JsonResponse
    {
        Gate::authorize('view', $post);
        $viewerId = $this->viewer->for($request->user())?->id;
        PostResource::setViewer($viewerId);

        return ApiResponse::success($this->resource($post, $viewerId));
    }

    public function update(PostRequest $request, Post $post): JsonResponse
    {
        Gate::authorize('view', $post);
        Gate::authorize('update', $post);

        $post = $this->save->update($post, $request->postData());
        PostResource::setViewer($post->author_profile_id);

        return ApiResponse::success($this->resource($post, $post->author_profile_id), Message::get('community::messages.post_updated'));
    }

    public function destroy(Post $post): Response
    {
        Gate::authorize('view', $post);
        Gate::authorize('delete', $post);

        $post->delete();
        Log::info('community.post_deleted', ['post_id' => $post->id]);

        return ApiResponse::noContent();
    }

    private function resource(Post $post, ?string $viewerId): PostResource
    {
        return new PostResource(
            Post::query()
                ->withEngagement($viewerId)
                ->with(['author', 'category', 'media', 'hashtags'])
                ->findOrFail($post->id),
        );
    }
}
