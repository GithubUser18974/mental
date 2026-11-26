<?php

declare(strict_types=1);

namespace App\Modules\Medication\Enums;

enum DosageUnit: string
{
    case Mg = 'mg';
    case Mcg = 'mcg';
    case G = 'g';
    case Ml = 'ml';
    case Drops = 'drops';
    case Tablet = 'tablet';
    case Capsule = 'capsule';
    case Puff = 'puff';
    case Patch = 'patch';
    case Unit = 'unit';
    case Other = 'other';
}
