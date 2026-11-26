<?php

declare(strict_types=1);

namespace App\Modules\Identity\Http\Controllers;

use App\Modules\Auth\Models\User;
use App\Modules\Identity\Actions\EnsureIdentity;
use App\Modules\Identity\Actions\UpdateProfile;
use App\Modules\Identity\Http\Requests\UpdateProfileRequest;
use App\Modules\Identity\Http\Resources\OwnProfileResource;
use App\Support\Http\ApiResponse;
use App\Support\Translation\Message;
use Illuminate\Http\JsonResponse;

final class UpdateProfileController
{
    public function __invoke(UpdateProfileRequest $request, EnsureIdentity $ensureIdentity, UpdateProfile $update): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();
        $identity = $ensureIdentity($user);

        $update($identity->profile, $request->changes());

        return ApiResponse::success(new OwnProfileResource($identity), Message::get('identity::messages.profile_updated'));
    }
}
