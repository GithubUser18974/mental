<?php

declare(strict_types=1);

namespace App\Modules\Medication\Actions;

use App\Modules\Medication\Enums\IntakeStatus;
use App\Modules\Medication\Models\Medication;
use App\Modules\Medication\Models\MedicationLog;
use Illuminate\Support\Facades\DB;

/**
 * Records a dose (FR-MED-004). Logging the same scheduled dose again updates it, so a
 * member can change "skipped" to "taken" without duplicates.
 */
final class RecordIntake
{
    /**
     * @param  array{status: IntakeStatus, scheduled_at: mixed, taken_at: mixed, notes: string|null}  $data
     * @return array{0: MedicationLog, 1: bool} log and whether it was newly created
     */
    public function __invoke(Medication $medication, array $data): array
    {
        return DB::transaction(function () use ($medication, $data): array {
            $log = $data['scheduled_at'] === null
                ? null
                : MedicationLog::query()
                    ->where('medication_id', $medication->id)
                    ->where('scheduled_at', $data['scheduled_at'])
                    ->lockForUpdate()
                    ->first();

            $created = $log === null;
            $log ??= new MedicationLog;
            $log->fill([
                'scheduled_at' => $data['scheduled_at'],
                'taken_at' => $data['status']->requiresTakenAt() ? $data['taken_at'] : null,
                'status' => $data['status'],
                'notes' => $data['notes'],
            ]);
            $log->medication_id = $medication->id;
            $log->user_id = $medication->user_id;
            $log->save();

            return [$log, $created];
        });
    }
}
