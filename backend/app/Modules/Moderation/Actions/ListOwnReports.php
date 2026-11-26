<?php

declare(strict_types=1);

namespace App\Modules\Moderation\Actions;

use App\Modules\Moderation\Models\Report;
use Illuminate\Contracts\Pagination\CursorPaginator;

/**
 * The reports a member filed, newest first, so they can see their status.
 */
final class ListOwnReports
{
    public const int MAX_PER_PAGE = 50;

    /**
     * @return CursorPaginator<int, Report>
     */
    public function __invoke(string $reporterProfileId, int $perPage): CursorPaginator
    {
        return Report::query()
            ->where('reporter_profile_id', $reporterProfileId)
            ->orderByDesc('created_at')
            ->orderByDesc('id')
            ->cursorPaginate(max(1, min(self::MAX_PER_PAGE, $perPage)));
    }
}
