<?php

declare(strict_types=1);

namespace App\Modules\Tracking\Http\Resources;

use App\Modules\Tracking\Models\SleepEntry;
use App\Support\Time\Iso8601;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * @property SleepEntry $resource
 */
final class SleepEntryResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $e = $this->resource;

        return [
            'id' => $e->id,
            'duration_minutes' => $e->duration_minutes,
            'quality' => $e->quality,
            'recorded_at' => Iso8601::format($e->recorded_at),
            'updated_at' => Iso8601::format($e->updated_at),
        ];
    }
}
