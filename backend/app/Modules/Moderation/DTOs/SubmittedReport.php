<?php

declare(strict_types=1);

namespace App\Modules\Moderation\DTOs;

use App\Modules\Moderation\Models\Report;

final readonly class SubmittedReport
{
    public function __construct(public Report $report, public bool $created) {}
}
