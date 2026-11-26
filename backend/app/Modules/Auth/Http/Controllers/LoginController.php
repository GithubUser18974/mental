<?php

declare(strict_types=1);

namespace App\Modules\Auth\Http\Controllers;

use App\Modules\Auth\Actions\AuthenticateUser;
use App\Modules\Auth\Http\Requests\LoginRequest;
use App\Modules\Auth\Http\Resources\AuthTokenResource;
use App\Support\Http\ApiResponse;
use App\Support\Translation\Message;
use Illuminate\Http\JsonResponse;

final class LoginController
{
    public function __invoke(LoginRequest $request, AuthenticateUser $authenticate): JsonResponse
    {
        $issued = $authenticate($request->email(), $request->password(), $request->deviceName());

        return ApiResponse::success(new AuthTokenResource($issued), Message::get('auth::messages.logged_in'));
    }
}
