<?php

declare(strict_types=1);

namespace App\Modules\Tracking\Actions;

use App\Modules\Tracking\Jobs\RefreshInsights;
use App\Modules\Tracking\Models\MoodEntry;
use App\Modules\Tracking\Models\SleepEntry;
use App\Modules\Tracking\Models\SymptomEntry;
use Carbon\CarbonImmutable;
use Illuminate\Contracts\Pagination\CursorPaginator;
use Illuminate\Database\Eloquent\Builder;

/**
 * Owner-scoped CRUD for private tracking entries (FR-TRACK-001/003/006, BR-005/007).
 *
 * Every lookup is `ownedBy($userId)` → another member's entry is a 404. Every change
 * schedules an insights refresh (queued, ids only — no health data in the payload).
 *
 * @template TEntry of MoodEntry|SymptomEntry|SleepEntry
 */
final class TrackingEntries
{
    /**
     * Newest first, optionally limited to a UTC range.
     *
     * @param  class-string<TEntry>  $model
     * @return CursorPaginator<int, TEntry>
     */
    public function list(
        string $model,
        string $userId,
        ?CarbonImmutable $from,
        ?CarbonImmutable $to,
        int $perPage,
    ): CursorPaginator {
        /** @var Builder<TEntry> $query */
        $query = $model::query()->ownedBy($userId);

        if ($model === SymptomEntry::class) {
            $query->with('category');
        }
        if ($from !== null) {
            $query->where('recorded_at', '>=', $from);
        }
        if ($to !== null) {
            $query->where('recorded_at', '<', $to);
        }

        return $query->orderByDesc('recorded_at')->orderByDesc('id')->cursorPaginate($perPage);
    }

    /**
     * @param  class-string<TEntry>  $model
     * @return TEntry
     */
    public function find(string $model, string $userId, string $id): MoodEntry|SymptomEntry|SleepEntry
    {
        /** @var TEntry */
        return $model::query()->ownedBy($userId)->findOrFail($id);
    }

    /**
     * @param  class-string<TEntry>  $model
     * @param  array<string, mixed>  $data
     * @return TEntry
     */
    public function create(string $model, string $userId, array $data): MoodEntry|SymptomEntry|SleepEntry
    {
        $entry = new $model;
        $entry->fill($data);
        $entry->user_id = $userId; // never from input
        $entry->save();
        RefreshInsights::dispatch($userId);

        return $entry;
    }

    /**
     * @param  TEntry  $entry
     * @param  array<string, mixed>  $data
     * @return TEntry
     */
    public function update(MoodEntry|SymptomEntry|SleepEntry $entry, array $data): MoodEntry|SymptomEntry|SleepEntry
    {
        $entry->fill($data)->save();
        RefreshInsights::dispatch($entry->user_id);

        return $entry;
    }

    /**
     * Permanent delete — private health data isn't kept once the member removes it.
     *
     * @param  TEntry  $entry
     */
    public function delete(MoodEntry|SymptomEntry|SleepEntry $entry): void
    {
        $entry->delete();
        RefreshInsights::dispatch($entry->user_id);
    }
}
