<?php

declare(strict_types=1);

namespace App\Modules\Identity\Http\Controllers;

use App\Modules\Identity\Actions\ListConnections;
use App\Modules\Identity\Http\Requests\ConnectionListRequest;
use App\Modules\Identity\Http\Resources\ProfileCardResource;
use App\Modules\Identity\Support\CurrentProfile;
use App\Support\Http\ApiResponse;
use Illuminate\Http\JsonResponse;

/**
 * The signed-in member's own lists: GET /profile/followers, /profile/following,
 * /profile/blocks. Only the owner can see them.
 */
final class ConnectionListController
{
    public function __construct(private readonly CurrentProfile $current, private readonly ListConnections $lists) {}

    public function followers(ConnectionListRequest $request): JsonResponse
    {
        $me = $this->current->require($request->user())->id;

        return ApiResponse::success(ProfileCardResource::collection($this->lists->followers($me, $request->perPage())));
    }

    public function following(ConnectionListRequest $request): JsonResponse
    {
        $me = $this->current->require($request->user())->id;

        return ApiResponse::success(ProfileCardResource::collection($this->lists->following($me, $request->perPage())));
    }

    public function blocked(ConnectionListRequest $request): JsonResponse
    {
        $me = $this->current->require($request->user())->id;

        return ApiResponse::success(ProfileCardResource::collection($this->lists->blocked($me, $request->perPage())));
    }
}
