<?php

declare(strict_types=1);

namespace App\Modules\Auth\Http\Controllers;

use App\Modules\Auth\Actions\SendPasswordResetLink;
use App\Modules\Auth\Http\Requests\ForgotPasswordRequest;
use App\Support\Http\ApiResponse;
use App\Support\Translation\Message;
use Illuminate\Http\JsonResponse;

/**
 * Always answers the same way, whether or not the email has an account.
 */
final class ForgotPasswordController
{
    public function __invoke(ForgotPasswordRequest $request, SendPasswordResetLink $send): JsonResponse
    {
        $send($request->email());

        return ApiResponse::success(message: Message::get('auth::messages.reset_link_sent'));
    }
}
