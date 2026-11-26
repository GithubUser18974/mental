<?php

declare(strict_types=1);

namespace App\Modules\Identity\Http\Controllers;

use App\Modules\Identity\Http\Requests\UsernameAvailabilityRequest;
use App\Modules\Identity\Models\AnonymousProfile;
use App\Modules\Identity\Support\UsernamePolicy;
use App\Support\Http\ApiResponse;
use Illuminate\Http\JsonResponse;

/**
 * Live check while the user types a custom username (onboarding / edit profile).
 * The caller's own current username counts as available.
 */
final class UsernameAvailabilityController
{
    public function __invoke(UsernameAvailabilityRequest $request): JsonResponse
    {
        $username = $request->username();
        $ownProfileId = AnonymousProfile::query()
            ->where('user_id', $request->user()?->getAuthIdentifier())
            ->value('id');

        $reason = match (true) {
            ! UsernamePolicy::isWellFormed($username) => 'invalid',
            UsernamePolicy::isReserved($username) => 'reserved',
            UsernamePolicy::isTaken($username, is_string($ownProfileId) ? $ownProfileId : null) => 'taken',
            default => null,
        };

        return ApiResponse::success([
            'username' => $username,
            'available' => $reason === null,
            'reason' => $reason,
        ]);
    }
}
