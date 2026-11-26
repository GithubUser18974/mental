<?php

declare(strict_types=1);

namespace App\Modules\Tracking\Http\Resources;

use App\Modules\Tracking\Models\SymptomEntry;
use App\Support\Time\Iso8601;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * @property SymptomEntry $resource
 */
final class SymptomEntryResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $e = $this->resource;

        return [
            'id' => $e->id,
            'category' => new SymptomCategoryResource($e->category),
            'severity' => $e->severity,
            'duration_minutes' => $e->duration_minutes,
            'notes' => $e->notes,
            'recorded_at' => Iso8601::format($e->recorded_at),
            'updated_at' => Iso8601::format($e->updated_at),
        ];
    }
}
