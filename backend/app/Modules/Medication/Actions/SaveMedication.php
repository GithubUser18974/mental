<?php

declare(strict_types=1);

namespace App\Modules\Medication\Actions;

use App\Modules\Medication\Enums\MedicationStatus;
use App\Modules\Medication\Models\Medication;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;

/**
 * Creates / updates a medication and its schedule (FR-MED-001/002). Discontinuing stamps
 * `discontinued_at` — from then on no doses or reminders are produced (FR-MED-003).
 */
final class SaveMedication
{
    /**
     * @param  array<string, mixed>  $data
     * @param  array<string, mixed>  $schedule
     */
    public function create(string $userId, array $data, array $schedule): Medication
    {
        return DB::transaction(function () use ($userId, $data, $schedule): Medication {
            $medication = new Medication;
            $medication->fill($data);
            $medication->user_id = $userId; // never from input
            $this->stampStatus($medication);
            $medication->save();
            $medication->schedule()->create($schedule);

            return $medication->load('schedule');
        });
    }

    /**
     * @param  array<string, mixed>  $data
     * @param  array<string, mixed>|null  $schedule  null = unchanged
     */
    public function update(Medication $medication, array $data, ?array $schedule): Medication
    {
        return DB::transaction(function () use ($medication, $data, $schedule): Medication {
            $medication->fill($data);
            $this->stampStatus($medication);
            $medication->save();

            if ($schedule !== null) {
                $medication->schedule()->updateOrCreate([], $schedule);
            }

            return $medication->load('schedule');
        });
    }

    private function stampStatus(Medication $medication): void
    {
        if (! $medication->isDirty('status') && $medication->exists) {
            return;
        }

        $medication->discontinued_at = $medication->status === MedicationStatus::Discontinued
            ? CarbonImmutable::now()
            : null;
    }
}
