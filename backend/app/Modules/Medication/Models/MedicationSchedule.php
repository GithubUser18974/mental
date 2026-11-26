<?php

declare(strict_types=1);

namespace App\Modules\Medication\Models;

use App\Modules\Medication\Enums\ScheduleType;
use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;

/**
 * When doses are due (FR-MED-002). `times` are local wall-clock "HH:MM".
 *
 * @property string $id
 * @property string $medication_id
 * @property ScheduleType $type
 * @property list<string> $times
 * @property list<int>|null $days_of_week
 * @property int|null $interval_days
 * @property CarbonImmutable $created_at
 * @property CarbonImmutable $updated_at
 */
#[Fillable(['type', 'times', 'days_of_week', 'interval_days'])]
class MedicationSchedule extends Model
{
    use HasUuids;

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'type' => ScheduleType::class,
            'times' => 'array',
            'days_of_week' => 'array',
            'interval_days' => 'integer',
        ];
    }
}
