<?php

declare(strict_types=1);

namespace App\Modules\Community\Http\Resources;

use App\Modules\Community\Models\PostMedia;
use App\Support\Time\Iso8601;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * `url` is a signed link valid for PostMedia::URL_TTL_MINUTES; refetch the post after it expires.
 *
 * @property PostMedia $resource
 */
final class MediaResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $expiresAt = now()->addMinutes(PostMedia::URL_TTL_MINUTES);

        return [
            'id' => $this->resource->id,
            'url' => $this->resource->temporaryUrl($expiresAt),
            'url_expires_at' => Iso8601::format($expiresAt),
            'mime' => $this->resource->mime,
            'width' => $this->resource->width,
            'height' => $this->resource->height,
        ];
    }
}
