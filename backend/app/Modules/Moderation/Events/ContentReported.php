<?php

declare(strict_types=1);

namespace App\Modules\Moderation\Events;

use App\Modules\Moderation\Enums\ReportPriority;
use App\Modules\Moderation\Enums\ReportTargetType;
use Illuminate\Foundation\Events\Dispatchable;

/**
 * A new report entered the moderation queue. The safety workflow (T8.1) listens to
 * alert moderators about critical reports (possible suicide / self-harm risk).
 * Ids only — never the reporter's identity or the details text.
 */
final readonly class ContentReported
{
    use Dispatchable;

    public function __construct(
        public string $reportId,
        public ReportTargetType $targetType,
        public string $targetId,
        public ReportPriority $priority,
    ) {}
}
