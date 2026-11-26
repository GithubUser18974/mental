<?php

declare(strict_types=1);

namespace App\Modules\Auth\Http\Controllers;

use App\Modules\Auth\Actions\IssueAccessToken;
use App\Modules\Auth\Http\Resources\AuthTokenResource;
use App\Modules\Auth\Models\PersonalAccessToken;
use App\Modules\Auth\Models\User;
use App\Support\Http\ApiResponse;
use App\Support\Translation\Message;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/**
 * Exchanges the current (still valid) token for a new one with a fresh expiry.
 */
final class RefreshTokenController
{
    public function __invoke(Request $request, IssueAccessToken $issueToken): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();
        /** @var PersonalAccessToken $current */
        $current = $user->currentAccessToken();

        $issued = DB::transaction(static function () use ($user, $current, $issueToken) {
            $current->delete();

            return $issueToken($user, $current->name);
        });

        return ApiResponse::success(new AuthTokenResource($issued), Message::get('auth::messages.token_refreshed'));
    }
}
