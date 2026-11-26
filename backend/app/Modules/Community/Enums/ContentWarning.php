<?php

declare(strict_types=1);

namespace App\Modules\Community\Enums;

/**
 * Author-selected content warnings (FR-COM-002). The app blurs the post behind the
 * localized label until the reader chooses to view it. Posts with a warning are never
 * boosted in the "popular" feed.
 */
enum ContentWarning: string
{
    case SelfHarm = 'self_harm';
    case Suicide = 'suicide';
    case EatingDisorder = 'eating_disorder';
    case SubstanceUse = 'substance_use';
    case AbuseTrauma = 'abuse_trauma';
    case Sensitive = 'sensitive';
}
