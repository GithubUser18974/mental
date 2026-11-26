<?php

declare(strict_types=1);

namespace App\Modules\Identity\Http\Controllers;

use App\Modules\Auth\Models\User;
use App\Modules\Identity\Actions\EnsureIdentity;
use App\Modules\Identity\Http\Requests\UpdatePrivacyRequest;
use App\Modules\Identity\Http\Resources\OwnProfileResource;
use App\Support\Http\ApiResponse;
use App\Support\Translation\Message;
use Illuminate\Http\JsonResponse;

final class UpdatePrivacyController
{
    public function __invoke(UpdatePrivacyRequest $request, EnsureIdentity $ensureIdentity): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();
        $identity = $ensureIdentity($user);

        $identity->privacy->fill($request->changes())->save();

        return ApiResponse::success(new OwnProfileResource($identity), Message::get('identity::messages.privacy_updated'));
    }
}
