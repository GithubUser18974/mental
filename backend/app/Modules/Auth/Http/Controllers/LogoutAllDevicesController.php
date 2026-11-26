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
 * FR-AUTH-003: log out from all devices — revokes every token of the account.
 */
final class LogoutAllDevicesController
{
    public function __invoke(Request $request): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();
        $revoked = $user->tokens()->delete();

        Log::info('auth.logout_all', ['user_id' => $user->id, 'revoked' => $revoked]);

        return ApiResponse::success(message: Message::get('auth::messages.logged_out_all'));
    }
}
