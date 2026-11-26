<?php

declare(strict_types=1);

namespace App\Modules\Medication\Models;

use App\Modules\Medication\Database\Factories\MedicationFactory;
use App\Modules\Medication\Enums\DosageUnit;
use App\Modules\Medication\Enums\MedicationStatus;
use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;

/**
 * A member-maintained medication record (FR-MED-001) — not a prescription.
 *
 * @property string $id
 * @property string $user_id
 * @property string $name
 * @property string $dosage
 * @property DosageUnit $unit
 * @property CarbonImmutable $start_date
 * @property CarbonImmutable|null $end_date
 * @property string|null $instructions
 * @property string|null $clinician
 * @property string|null $notes
 * @property bool $reminders_enabled
 * @property MedicationStatus $status
 * @property CarbonImmutable|null $discontinued_at
 * @property CarbonImmutable $created_at
 * @property CarbonImmutable $updated_at
 * @property-read MedicationSchedule|null $schedule
 */
#[Fillable([
    'name', 'dosage', 'unit', 'start_date', 'end_date', 'instructions', 'clinician', 'notes',
    'reminders_enabled', 'status',
])]
class Medication extends Model
{
    /** @use HasFactory<MedicationFactory> */
    use HasFactory;

    use HasUuids;

    /** @var array<string, mixed> */
    protected $attributes = [
        'status' => 'active',
        'reminders_enabled' => true,
    ];

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'name' => 'encrypted',
            'dosage' => 'encrypted',
            'instructions' => 'encrypted',
            'clinician' => 'encrypted',
            'notes' => 'encrypted',
            'unit' => DosageUnit::class,
            'status' => MedicationStatus::class,
            'reminders_enabled' => 'boolean',
            'start_date' => 'immutable_date',
            'end_date' => 'immutable_date',
            'discontinued_at' => 'immutable_datetime',
        ];
    }

    /**
     * @param  Builder<self>  $query
     * @return Builder<self>
     */
    public function scopeOwnedBy(Builder $query, string $userId): Builder
    {
        return $query->where('medications.user_id', $userId);
    }

    /**
     * @return HasOne<MedicationSchedule, $this>
     */
    public function schedule(): HasOne
    {
        return $this->hasOne(MedicationSchedule::class);
    }

    /**
     * @return HasMany<MedicationLog, $this>
     */
    public function logs(): HasMany
    {
        return $this->hasMany(MedicationLog::class);
    }

    /**
     * @return HasMany<MedicationExperience, $this>
     */
    public function experiences(): HasMany
    {
        return $this->hasMany(MedicationExperience::class);
    }

    /**
     * Current = not discontinued and not past its end date (FR-MED-006 current vs past).
     */
    public function isCurrent(CarbonImmutable $today): bool
    {
        return $this->status !== MedicationStatus::Discontinued
            && ($this->end_date === null || $this->end_date->gte($today->startOfDay()));
    }

    protected static function newFactory(): MedicationFactory
    {
        return MedicationFactory::new();
    }
}
