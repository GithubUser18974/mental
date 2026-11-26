<?php

declare(strict_types=1);

namespace App\Modules\Community\Http\Controllers;

use App\Modules\Community\Actions\ReactToPost;
use App\Modules\Community\Http\Requests\ReactionRequest;
use App\Modules\Community\Models\Post;
use App\Modules\Community\Support\ViewerProfile;
use App\Support\Http\ApiResponse;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Gate;

/**
 * POST /posts/{post}/reactions sets (or changes) the viewer's reaction and returns the
 * fresh counts; DELETE removes it (FR-COM-005).
 */
final class ReactionController
{
    public function __construct(private readonly ViewerProfile $viewer, private readonly ReactToPost $react) {}

    public function store(ReactionRequest $request, Post $post): JsonResponse
    {
        Gate::authorize('view', $post);
        $profile = $this->viewer->require($request->user());

        $this->react->set($post, $profile->id, $request->reactionType());

        return ApiResponse::success($this->react->summary($post, $profile->id));
    }

    public function destroy(Request $request, Post $post): Response
    {
        Gate::authorize('view', $post);

        $this->react->remove($post, $this->viewer->require($request->user())->id);

        return ApiResponse::noContent();
    }
}
