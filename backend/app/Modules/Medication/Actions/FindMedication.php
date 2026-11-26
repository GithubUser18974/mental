<?php

declare(strict_types=1);

namespace App\Modules\Medication\Actions;

use App\Modules\Medication\Models\Medication;
use App\Modules\Medication\Models\MedicationExperience;
use App\Modules\Medication\Models\MedicationLog;

/**
 * Owner-scoped lookups: another member's medication, log or experience is a 404
 * (SRS §13.3 #1).
 */
final class FindMedication
{
    public function __invoke(string $userId, string $id): Medication
    {
        return Medication::query()->ownedBy($userId)->with('schedule')->findOrFail($id);
    }

    public function log(Medication $medication, string $logId): MedicationLog
    {
        return MedicationLog::query()->where('medication_id', $medication->id)->findOrFail($logId);
    }

    public function experience(Medication $medication, string $experienceId): MedicationExperience
    {
        return MedicationExperience::query()->where('medication_id', $medication->id)->findOrFail($experienceId);
    }
}
