<?php

declare(strict_types=1);

namespace App\Modules\Medication\Http\Resources;

use App\Modules\Medication\Models\MedicationLog;
use App\Support\Time\Iso8601;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * A scheduled dose with its log (if recorded). Ids only — no medication name.
 *
 * @property array{medication_id: string, scheduled_at: CarbonImmutable, reminder: bool, log: MedicationLog|null} $resource
 */
final class DoseResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $dose = $this->resource;

        return [
            'medication_id' => $dose['medication_id'],
            'scheduled_at' => Iso8601::format($dose['scheduled_at']),
            'reminder' => $dose['reminder'],
            'log' => $dose['log'] === null ? null : new MedicationLogResource($dose['log']),
        ];
    }
}
