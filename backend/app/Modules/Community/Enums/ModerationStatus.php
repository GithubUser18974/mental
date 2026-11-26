<?php

declare(strict_types=1);

namespace App\Modules\Community\Enums;

/**
 * Moderation state (FR-COM-002), set by the safety workflow / moderators (T8).
 * Only `visible` posts appear to other members.
 */
enum ModerationStatus: string
{
    case Visible = 'visible';
    case UnderReview = 'under_review';
    case Hidden = 'hidden';
    case Removed = 'removed';
}
