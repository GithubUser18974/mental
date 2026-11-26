<?php

declare(strict_types=1);

namespace App\Modules\Moderation\Database\Factories;

use App\Modules\Identity\Models\AnonymousProfile;
use App\Modules\Moderation\Enums\ReportReason;
use App\Modules\Moderation\Enums\ReportStatus;
use App\Modules\Moderation\Enums\ReportTargetType;
use App\Modules\Moderation\Models\Report;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

/**
 * @extends Factory<Report>
 */
final class ReportFactory extends Factory
{
    protected $model = Report::class;

    /**
     * @return array<model-property<Report>, mixed>
     */
    public function definition(): array
    {
        return [
            'reporter_profile_id' => AnonymousProfile::factory(),
            'target_type' => ReportTargetType::Post,
            'target_id' => (string) Str::uuid7(),
            'reason' => ReportReason::Spam,
            'priority' => ReportReason::Spam->priority(),
        ];
    }

    public function reason(ReportReason $reason): static
    {
        return $this->state(['reason' => $reason, 'priority' => $reason->priority()]);
    }

    public function status(ReportStatus $status): static
    {
        return $this->state(['status' => $status]);
    }
}
