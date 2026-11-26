<?php

declare(strict_types=1);

namespace App\Modules\Medication\Actions;

use App\Modules\Medication\Enums\MedicationStatus;
use App\Modules\Medication\Models\Medication;
use App\Modules\Medication\Models\MedicationLog;
use App\Modules\Medication\Support\DoseCalendar;
use Carbon\CarbonImmutable;
use DateTimeZone;

/**
 * Scheduled doses of ACTIVE medications in a window, merged with what was logged —
 * the app's "today" list and the source for local reminders (FR-MED-003/004).
 * Paused and discontinued medications produce nothing (SRS §13.3 #7).
 *
 * Carries medication ids only: the app shows names from its own list and reminder
 * text stays generic (no medication names in notification previews).
 */
final class BuildDoses
{
    /**
     * @return list<array{medication_id: string, scheduled_at: CarbonImmutable, reminder: bool, log: MedicationLog|null}>
     */
    public function __invoke(string $userId, CarbonImmutable $fromUtc, CarbonImmutable $toUtc, DateTimeZone $tz): array
    {
        $medications = Medication::query()
            ->ownedBy($userId)
            ->where('status', MedicationStatus::Active->value)
            ->with('schedule')
            ->get();

        $logs = MedicationLog::query()
            ->where('user_id', $userId)
            ->whereIn('medication_id', $medications->modelKeys())
            ->whereBetween('scheduled_at', [$fromUtc, $toUtc])
            ->get()
            ->keyBy(fn (MedicationLog $log): string => $log->medication_id.'|'.$log->scheduled_at?->getTimestamp());

        $doses = [];
        foreach ($medications as $medication) {
            foreach (DoseCalendar::between($medication, $fromUtc, $toUtc, $tz) as $at) {
                $doses[] = [
                    'medication_id' => $medication->id,
                    'scheduled_at' => $at,
                    'reminder' => $medication->reminders_enabled,
                    'log' => $logs->get($medication->id.'|'.$at->getTimestamp()),
                ];
            }
        }

        usort($doses, static fn (array $a, array $b): int => $a['scheduled_at'] <=> $b['scheduled_at']);

        return $doses;
    }
}
