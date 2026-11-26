<?php

declare(strict_types=1);

namespace App\Modules\Auth\Http\Controllers;

use App\Modules\Auth\Actions\RegisterUser;
use App\Modules\Auth\Http\Requests\RegisterRequest;
use App\Modules\Auth\Http\Resources\AuthTokenResource;
use App\Support\Http\ApiResponse;
use App\Support\Translation\Message;
use Illuminate\Http\JsonResponse;

final class RegisterController
{
    public function __invoke(RegisterRequest $request, RegisterUser $register): JsonResponse
    {
        $issued = $register($request->email(), $request->password(), $request->deviceName());

        return ApiResponse::created(new AuthTokenResource($issued), Message::get('auth::messages.registered'));
    }
}
