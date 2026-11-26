<?php

declare(strict_types=1);

namespace App\Modules\Identity\Http\Controllers;

use App\Modules\Auth\Models\User;
use App\Modules\Identity\Actions\EnsureIdentity;
use App\Modules\Identity\Http\Requests\UpdatePreferencesRequest;
use App\Modules\Identity\Http\Resources\OwnProfileResource;
use App\Support\Http\ApiResponse;
use App\Support\Translation\Message;
use Illuminate\Http\JsonResponse;

final class UpdatePreferencesController
{
    public function __invoke(UpdatePreferencesRequest $request, EnsureIdentity $ensureIdentity): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();
        $identity = $ensureIdentity($user);

        $identity->preferences->fill($request->changes())->save();

        return ApiResponse::success(new OwnProfileResource($identity), Message::get('identity::messages.preferences_updated'));
    }
}
