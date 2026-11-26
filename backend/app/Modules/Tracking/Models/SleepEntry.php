<?php

declare(strict_types=1);

namespace App\Modules\Tracking\Models;

use App\Modules\Tracking\Database\Factories\SleepEntryFactory;
use App\Modules\Tracking\Models\Concerns\OwnedByUser;
use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * One night of sleep (FR-TRACK-001): duration and optional 1–10 quality. `recorded_at`
 * is the wake-up time; the night counts for that day.
 *
 * @property string $id
 * @property string $user_id
 * @property int $duration_minutes
 * @property int|null $quality
 * @property CarbonImmutable $recorded_at
 * @property CarbonImmutable $created_at
 * @property CarbonImmutable $updated_at
 */
#[Fillable(['user_id', 'duration_minutes', 'quality', 'recorded_at'])]
class SleepEntry extends Model
{
    /** @use HasFactory<SleepEntryFactory> */
    use HasFactory;

    use HasUuids;
    use OwnedByUser;

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'duration_minutes' => 'integer',
            'quality' => 'integer',
            'recorded_at' => 'immutable_datetime',
        ];
    }

    protected static function newFactory(): SleepEntryFactory
    {
        return SleepEntryFactory::new();
    }
}
