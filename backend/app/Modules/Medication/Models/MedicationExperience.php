<?php

declare(strict_types=1);

namespace App\Modules\Medication\Models;

use App\Modules\Medication\Enums\ExperienceKind;
use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;

/**
 * A private observation about a medication (FR-MED-005). Never shared automatically —
 * publishing it as a post needs an explicit action in the app (FR-MED-007, BR-012).
 *
 * @property string $id
 * @property string $medication_id
 * @property string $user_id
 * @property ExperienceKind $kind
 * @property string $description
 * @property CarbonImmutable $observed_on
 * @property CarbonImmutable $created_at
 * @property CarbonImmutable $updated_at
 */
#[Fillable(['kind', 'description', 'observed_on'])]
class MedicationExperience extends Model
{
    use HasUuids;

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'kind' => ExperienceKind::class,
            'description' => 'encrypted',
            'observed_on' => 'immutable_date',
        ];
    }
}
