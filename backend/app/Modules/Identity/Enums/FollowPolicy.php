<?php

declare(strict_types=1);

namespace App\Modules\Identity\Enums;

/**
 * Who may follow this profile (FR-ONB-003 "follow permissions"). Enforced by follows in T2.3.
 */
enum FollowPolicy: string
{
    case Everyone = 'everyone';
    case Nobody = 'nobody';
}
