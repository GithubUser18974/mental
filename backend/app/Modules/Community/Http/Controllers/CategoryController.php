<?php

declare(strict_types=1);

namespace App\Modules\Community\Http\Controllers;

use App\Modules\Community\Http\Resources\CategoryResource;
use App\Modules\Community\Models\PostCategory;
use App\Support\Http\ApiResponse;
use Illuminate\Http\JsonResponse;

/**
 * Active categories in display order, localized (FR-COM-003).
 */
final class CategoryController
{
    public function __invoke(): JsonResponse
    {
        return ApiResponse::success(CategoryResource::collection(PostCategory::query()->active()->get()));
    }
}
