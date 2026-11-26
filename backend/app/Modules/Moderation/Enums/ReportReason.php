<?php

declare(strict_types=1);

namespace App\Modules\Moderation\Enums;

/**
 * Report reasons (FR-COM-010). Labels are localized in the app.
 */
enum ReportReason: string
{
    case Harassment = 'harassment';
    case DangerousMedicalAdvice = 'dangerous_medical_advice';
    case Spam = 'spam';
    case SelfHarmEncouragement = 'self_harm_encouragement';
    case SuicidalContent = 'suicidal_content';
    case Other = 'other';

    /**
     * Queue priority. Possible risk to someone's life is reviewed first (FR-SAFETY-001).
     */
    public function priority(): ReportPriority
    {
        return match ($this) {
            self::SuicidalContent, self::SelfHarmEncouragement => ReportPriority::Critical,
            self::DangerousMedicalAdvice, self::Harassment => ReportPriority::High,
            self::Spam, self::Other => ReportPriority::Normal,
        };
    }

    /**
     * Whether the reporter should be offered crisis-support resources (FR-SAFETY-002):
     * the content suggests someone may be in danger.
     */
    public function suggestsCrisis(): bool
    {
        return $this === self::SuicidalContent || $this === self::SelfHarmEncouragement;
    }
}
