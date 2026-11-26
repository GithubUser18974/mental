<?php

declare(strict_types=1);

namespace App\Modules\Tracking\Jobs;

use App\Modules\Tracking\Actions\ComputeInsights;
use App\Modules\Tracking\Models\TrackingInsight;
use Carbon\CarbonImmutable;
use Illuminate\Contracts\Queue\ShouldBeUnique;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;

/**
 * Recomputes a member's insights after their data changes (FR-TRACK-005). Queued (heavy
 * work never blocks requests), idempotent, unique per account so a burst of edits runs
 * once, dispatched after commit. The payload is an account id only — no health data.
 */
final class RefreshInsights implements ShouldBeUnique, ShouldQueue
{
    use Queueable;

    public int $tries = 3;

    /** @var list<int> */
    public array $backoff = [10, 60];

    public int $uniqueFor = 60;

    public function __construct(public readonly string $userId)
    {
        $this->afterCommit();
    }

    public function uniqueId(): string
    {
        return $this->userId;
    }

    public function handle(ComputeInsights $compute): void
    {
        TrackingInsight::query()->updateOrCreate(
            ['user_id' => $this->userId],
            ['items' => $compute($this->userId), 'computed_at' => CarbonImmutable::now()],
        );
    }
}
