<?php

declare(strict_types=1);

namespace App\Modules\Medication\Http\Controllers;

use App\Modules\Auth\Models\User;
use App\Modules\Identity\Services\AccountPreferences;
use App\Modules\Medication\Actions\BuildDoses;
use App\Modules\Medication\Http\Requests\DoseWindowRequest;
use App\Modules\Medication\Http\Resources\DoseResource;
use App\Support\Http\ApiResponse;
use Illuminate\Http\JsonResponse;

/**
 * GET /medications/doses — scheduled doses of active medications for local days, with
 * their logs; the app's daily list and source of local reminders.
 */
final class DoseController
{
    public function __invoke(DoseWindowRequest $request, BuildDoses $doses, AccountPreferences $preferences): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();
        $tz = $preferences->timezone($user->id);
        [$from, $to] = $request->utcWindow($tz);

        return ApiResponse::success(DoseResource::collection($doses($user->id, $from, $to, $tz)));
    }
}
