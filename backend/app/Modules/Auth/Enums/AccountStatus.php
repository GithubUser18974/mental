<?php

declare(strict_types=1);

namespace App\Modules\Auth\Enums;

enum AccountStatus: string
{
    case Active = 'active';

    /** Set by moderation (T8). */
    case Suspended = 'suspended';

    /** Account closed / pending deletion (T10). */
    case Deactivated = 'deactivated';

    public function canSignIn(): bool
    {
        return $this === self::Active;
    }
}
