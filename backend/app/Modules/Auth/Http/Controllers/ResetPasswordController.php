<?php

declare(strict_types=1);

namespace App\Modules\Auth\Http\Controllers;

use App\Modules\Auth\Actions\ResetPassword;
use App\Modules\Auth\Http\Requests\ResetPasswordRequest;
use App\Support\Http\ApiResponse;
use App\Support\Translation\Message;
use Illuminate\Http\JsonResponse;

final class ResetPasswordController
{
    public function __invoke(ResetPasswordRequest $request, ResetPassword $reset): JsonResponse
    {
        $reset($request->email(), $request->token(), $request->password());

        return ApiResponse::success(message: Message::get('auth::messages.password_reset'));
    }
}
