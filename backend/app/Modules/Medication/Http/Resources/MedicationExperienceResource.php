<?php

declare(strict_types=1);

namespace App\Modules\Medication\Http\Resources;

use App\Modules\Medication\Models\MedicationExperience;
use App\Support\Time\Iso8601;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * @property MedicationExperience $resource
 */
final class MedicationExperienceResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $e = $this->resource;

        return [
            'id' => $e->id,
            'medication_id' => $e->medication_id,
            'kind' => $e->kind->value,
            'description' => $e->description,
            'observed_on' => $e->observed_on->toDateString(),
            'created_at' => Iso8601::format($e->created_at),
        ];
    }
}
