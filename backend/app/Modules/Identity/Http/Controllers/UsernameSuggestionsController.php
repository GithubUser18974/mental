<?php

declare(strict_types=1);

namespace App\Modules\Identity\Http\Controllers;

use App\Modules\Identity\Support\UsernameGenerator;
use App\Support\Http\ApiResponse;
use Illuminate\Http\JsonResponse;

/**
 * "Shuffle" for onboarding: a few fresh, currently-available pseudonyms.
 */
final class UsernameSuggestionsController
{
    public function __invoke(UsernameGenerator $generator): JsonResponse
    {
        return ApiResponse::success(['usernames' => $generator->available(5)]);
    }
}
