<?php

declare(strict_types=1);

namespace App\Modules\Identity\Http\Controllers;

use App\Modules\Auth\Models\User;
use App\Modules\Identity\Actions\EnsureIdentity;
use App\Modules\Identity\Http\Resources\OwnProfileResource;
use App\Support\Http\ApiResponse;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

final class ShowOwnProfileController
{
    public function __invoke(Request $request, EnsureIdentity $ensureIdentity): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();

        return ApiResponse::success(new OwnProfileResource($ensureIdentity($user)));
    }
}
