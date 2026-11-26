<?php

declare(strict_types=1);

namespace App\Modules\Moderation\Enums;

/**
 * Report lifecycle (FR-SAFETY-003). `open` → `reviewing` → `actioned` | `dismissed`.
 * Moderator transitions arrive with T8.1.
 */
enum ReportStatus: string
{
    case Open = 'open';
    case Reviewing = 'reviewing';
    case Actioned = 'actioned';
    case Dismissed = 'dismissed';

    public function isPending(): bool
    {
        return $this === self::Open || $this === self::Reviewing;
    }
}
