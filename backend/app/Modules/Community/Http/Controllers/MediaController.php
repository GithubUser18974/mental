<?php

declare(strict_types=1);

namespace App\Modules\Community\Http\Controllers;

use App\Modules\Community\Actions\StorePostMedia;
use App\Modules\Community\Http\Requests\UploadMediaRequest;
use App\Modules\Community\Http\Resources\MediaResource;
use App\Modules\Community\Support\ViewerProfile;
use App\Support\Http\ApiResponse;
use Illuminate\Http\JsonResponse;

/**
 * Uploads one post image (sanitized). Attach it by id when creating/updating a post.
 */
final class MediaController
{
    public function __invoke(UploadMediaRequest $request, ViewerProfile $viewer, StorePostMedia $store): JsonResponse
    {
        $media = $store($viewer->require($request->user()), $request->uploadedImage());

        return ApiResponse::created(new MediaResource($media));
    }
}
