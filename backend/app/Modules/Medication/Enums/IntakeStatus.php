<?php

declare(strict_types=1);

namespace App\Modules\Medication\Enums;

/**
 * FR-MED-004. `taken` and `delayed` (taken late) carry an actual intake time.
 */
enum IntakeStatus: string
{
    case Taken = 'taken';
    case Skipped = 'skipped';
    case Missed = 'missed';
    case Delayed = 'delayed';

    public function requiresTakenAt(): bool
    {
        return $this === self::Taken || $this === self::Delayed;
    }
}
