<?php

declare(strict_types=1);

namespace App\Modules\Medication\Models;

use App\Modules\Medication\Database\Factories\MedicationLogFactory;
use App\Modules\Medication\Enums\IntakeStatus;
use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * One recorded dose (FR-MED-004).
 *
 * @property string $id
 * @property string $medication_id
 * @property string $user_id
 * @property CarbonImmutable|null $scheduled_at
 * @property CarbonImmutable|null $taken_at
 * @property IntakeStatus $status
 * @property string|null $notes
 * @property CarbonImmutable $created_at
 * @property CarbonImmutable $updated_at
 */
#[Fillable(['scheduled_at', 'taken_at', 'status', 'notes'])]
class MedicationLog extends Model
{
    /** @use HasFactory<MedicationLogFactory> */
    use HasFactory;

    use HasUuids;

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'status' => IntakeStatus::class,
            'notes' => 'encrypted',
            'scheduled_at' => 'immutable_datetime',
            'taken_at' => 'immutable_datetime',
        ];
    }

    protected static function newFactory(): MedicationLogFactory
    {
        return MedicationLogFactory::new();
    }
}
