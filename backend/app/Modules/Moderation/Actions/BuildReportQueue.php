<?php

declare(strict_types=1);

namespace App\Modules\Moderation\Actions;

use App\Modules\Moderation\Models\Report;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Support\Facades\DB;

/**
 * The moderation queue (SRS §5.3): pending reports grouped by target — one row per reported
 * item with how many distinct members reported it, its highest priority and its oldest
 * report — ordered critical first, then by most reporters, then oldest first.
 *
 * Read side only; moderator decisions and the admin screen arrive with T8.1 / T9.1.
 */
final class BuildReportQueue
{
    /**
     * @return Collection<int, Report> rows with target_type, target_id, reporters_count,
     *                                 top_priority, first_reported_at
     */
    public function __invoke(int $limit = 50): Collection
    {
        return Report::query()
            ->pending()
            ->select('target_type', 'target_id')
            ->selectRaw('count(distinct reporter_profile_id) as reporters_count')
            ->selectRaw('max(priority) as top_priority')
            ->selectRaw('min(created_at) as first_reported_at')
            ->groupBy('target_type', 'target_id')
            ->orderByDesc(DB::raw('max(priority)'))
            ->orderByDesc(DB::raw('count(distinct reporter_profile_id)'))
            ->orderBy(DB::raw('min(created_at)'))
            ->limit($limit)
            ->get();
    }
}
