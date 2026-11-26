<?php

declare(strict_types=1);

namespace App\Modules\Medication\Actions;

use App\Modules\Medication\Enums\MedicationStatus;
use App\Modules\Medication\Models\Medication;
use Carbon\CarbonImmutable;
use Illuminate\Contracts\Pagination\CursorPaginator;
use Illuminate\Database\Eloquent\Builder;

/**
 * Current or past medications (FR-MED-006). Names are encrypted, so ordering is by
 * when they were added (newest first); the app sorts by name on the device.
 */
final class ListMedications
{
    /**
     * @return CursorPaginator<int, Medication>
     */
    public function __invoke(string $userId, string $filter, CarbonImmutable $today, int $perPage): CursorPaginator
    {
        $query = Medication::query()->ownedBy($userId)->with('schedule');
        $date = $today->toDateString();

        if ($filter === 'current') {
            $query->where('status', '!=', MedicationStatus::Discontinued->value)
                ->where(fn (Builder $q) => $q->whereNull('end_date')->orWhere('end_date', '>=', $date));
        } elseif ($filter === 'past') {
            $query->where(fn (Builder $q) => $q
                ->where('status', MedicationStatus::Discontinued->value)
                ->orWhere('end_date', '<', $date));
        }

        return $query->orderByDesc('created_at')->orderByDesc('id')->cursorPaginate(max(1, min(100, $perPage)));
    }
}
