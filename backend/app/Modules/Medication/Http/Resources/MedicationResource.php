<?php

declare(strict_types=1);

namespace App\Modules\Medication\Http\Resources;

use App\Modules\Medication\Models\Medication;
use App\Support\Time\Iso8601;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * The owner's own medication record (never returned to anyone else).
 *
 * @property Medication $resource
 */
final class MedicationResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $m = $this->resource;
        $schedule = $m->schedule;

        return [
            'id' => $m->id,
            'name' => $m->name,
            'dosage' => $m->dosage,
            'unit' => $m->unit->value,
            'start_date' => $m->start_date->toDateString(),
            'end_date' => $m->end_date?->toDateString(),
            'instructions' => $m->instructions,
            'clinician' => $m->clinician,
            'notes' => $m->notes,
            'reminders_enabled' => $m->reminders_enabled,
            'status' => $m->status->value,
            'is_current' => $m->isCurrent(CarbonImmutable::now()),
            'discontinued_at' => $m->discontinued_at === null ? null : Iso8601::format($m->discontinued_at),
            'schedule' => $schedule === null ? null : [
                'type' => $schedule->type->value,
                'times' => $schedule->times,
                'days_of_week' => $schedule->days_of_week,
                'interval_days' => $schedule->interval_days,
            ],
            'created_at' => Iso8601::format($m->created_at),
            'updated_at' => Iso8601::format($m->updated_at),
        ];
    }
}
