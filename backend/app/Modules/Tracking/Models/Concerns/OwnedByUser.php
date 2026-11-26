<?php

declare(strict_types=1);

namespace App\Modules\Tracking\Models\Concerns;

use Illuminate\Database\Eloquent\Builder;

/**
 * Private health records belong to one account. Every lookup goes through
 * `ownedBy($userId)` so another member's record is simply "not found" (404).
 */
trait OwnedByUser
{
    /**
     * @param  Builder<static>  $query
     * @return Builder<static>
     */
    public function scopeOwnedBy(Builder $query, string $userId): Builder
    {
        return $query->where($query->getModel()->qualifyColumn('user_id'), $userId);
    }
}
