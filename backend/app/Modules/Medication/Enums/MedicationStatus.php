<?php

declare(strict_types=1);

namespace App\Modules\Medication\Enums;

/**
 * `active` → reminders run; `paused` → kept but no reminders; `discontinued` → a past
 * medication, reminders stop immediately (FR-MED-003, SRS §13.3 #7).
 */
enum MedicationStatus: string
{
    case Active = 'active';
    case Paused = 'paused';
    case Discontinued = 'discontinued';
}
