<?php

declare(strict_types=1);

namespace App\Modules\Medication\Enums;

/**
 * FR-MED-002: once/several times daily (`daily` + times), specific weekdays (`weekly`),
 * custom every-N-days (`interval`), or no fixed times (`as_needed`, no reminders).
 * Temporary schedules use the medication's start / end dates.
 */
enum ScheduleType: string
{
    case Daily = 'daily';
    case Weekly = 'weekly';
    case Interval = 'interval';
    case AsNeeded = 'as_needed';
}
