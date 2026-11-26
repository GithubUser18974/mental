<?php

declare(strict_types=1);

namespace App\Modules\Medication\Http\Resources;

use App\Modules\Medication\Models\MedicationLog;
use App\Support\Time\Iso8601;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * @property MedicationLog $resource
 */
final class MedicationLogResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $log = $this->resource;

        return [
            'id' => $log->id,
            'medication_id' => $log->medication_id,
            'status' => $log->status->value,
            'scheduled_at' => $log->scheduled_at === null ? null : Iso8601::format($log->scheduled_at),
            'taken_at' => $log->taken_at === null ? null : Iso8601::format($log->taken_at),
            'notes' => $log->notes,
            'created_at' => Iso8601::format($log->created_at),
        ];
    }
}
