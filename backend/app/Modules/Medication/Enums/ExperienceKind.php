<?php

declare(strict_types=1);

namespace App\Modules\Medication\Enums;

/**
 * FR-MED-005: perceived benefits, side effects, physical / emotional changes, general.
 */
enum ExperienceKind: string
{
    case Benefit = 'benefit';
    case SideEffect = 'side_effect';
    case Change = 'change';
    case General = 'general';
}
