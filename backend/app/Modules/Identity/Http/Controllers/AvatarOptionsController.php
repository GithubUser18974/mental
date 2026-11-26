<?php

declare(strict_types=1);

namespace App\Modules\Identity\Http\Controllers;

use App\Modules\Identity\Support\AvatarCatalog;
use App\Support\Http\ApiResponse;
use Illuminate\Http\JsonResponse;

final class AvatarOptionsController
{
    public function __invoke(): JsonResponse
    {
        return ApiResponse::success([
            'icons' => AvatarCatalog::ICONS,
            'colors' => AvatarCatalog::COLORS,
            'avatars' => AvatarCatalog::all(),
        ]);
    }
}
