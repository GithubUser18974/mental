<?php

declare(strict_types=1);

namespace App\Modules\Auth\Http\Controllers;

use App\Modules\Auth\Models\User;
use App\Support\Http\ApiResponse;
use App\Support\Translation\Message;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

/**
 * Revokes only the token used for this request (this device).
 */
final class LogoutController
{
    public function __invoke(Request $request): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();
        $user->currentAccessToken()->delete();

        Log::info('auth.logout', ['user_id' => $user->id]);

        return ApiResponse::success(message: Message::get('auth::messages.logged_out'));
    }
}
