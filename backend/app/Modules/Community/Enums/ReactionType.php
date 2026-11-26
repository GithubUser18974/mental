<?php

declare(strict_types=1);

namespace App\Modules\Community\Enums;

/**
 * Supportive reactions (FR-COM-005) — used instead of plain "likes". A member has at most
 * one active reaction per post. Labels are localized in the app.
 */
enum ReactionType: string
{
    case Understand = 'understand';      // "I understand you"
    case Support = 'support';            // "Sending support"
    case NotAlone = 'not_alone';         // "You're not alone"
    case Proud = 'proud';                // "Proud of you"
    case ThankYou = 'thank_you';         // "Thank you for sharing"
}
