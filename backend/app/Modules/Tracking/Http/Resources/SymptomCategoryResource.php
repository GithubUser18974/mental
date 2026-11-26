<?php

declare(strict_types=1);

namespace App\Modules\Tracking\Http\Resources;

use App\Modules\Tracking\Models\SymptomCategory;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * @property SymptomCategory $resource
 */
final class SymptomCategoryResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'slug' => $this->resource->slug,
            'name' => $this->resource->localizedName(),
            'icon' => $this->resource->icon,
        ];
    }
}
