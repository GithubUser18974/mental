<?php

declare(strict_types=1);

namespace App\Modules\Moderation\Enums;

/**
 * Moderation queue priority (SRS §5.3 report prioritization). Stored as a number so the
 * queue can sort on it; higher = reviewed first.
 */
enum ReportPriority: int
{
    case Normal = 1;
    case High = 2;
    case Critical = 3;

    public function label(): string
    {
        return strtolower($this->name);
    }
}
