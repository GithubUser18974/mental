<?php

declare(strict_types=1);

namespace App\Modules\Tracking\Http\Resources;

use App\Modules\Tracking\Models\MoodEntry;
use App\Support\Time\Iso8601;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * The owner's own check-in (only ever returned to its owner).
 *
 * @property MoodEntry $resource
 */
final class MoodEntryResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $e = $this->resource;

        return [
            'id' => $e->id,
            'mood' => $e->mood->value,
            'score' => $e->score,
            'anxiety' => $e->anxiety,
            'stress' => $e->stress,
            'energy' => $e->energy,
            'notes' => $e->notes,
            'recorded_at' => Iso8601::format($e->recorded_at),
            'updated_at' => Iso8601::format($e->updated_at),
        ];
    }
}
