<?php

declare(strict_types=1);

namespace App\Modules\Tracking\Models;

use App\Modules\Tracking\Database\Factories\SymptomEntryFactory;
use App\Modules\Tracking\Models\Concerns\OwnedByUser;
use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * A recorded symptom (FR-TRACK-003).
 *
 * @property string $id
 * @property string $user_id
 * @property string $category_id
 * @property int $severity
 * @property int|null $duration_minutes
 * @property string|null $notes
 * @property CarbonImmutable $recorded_at
 * @property CarbonImmutable $created_at
 * @property CarbonImmutable $updated_at
 * @property-read SymptomCategory $category
 */
#[Fillable(['user_id', 'category_id', 'severity', 'duration_minutes', 'notes', 'recorded_at'])]
class SymptomEntry extends Model
{
    /** @use HasFactory<SymptomEntryFactory> */
    use HasFactory;

    use HasUuids;
    use OwnedByUser;

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'severity' => 'integer',
            'duration_minutes' => 'integer',
            'notes' => 'encrypted',
            'recorded_at' => 'immutable_datetime',
        ];
    }

    /**
     * @return BelongsTo<SymptomCategory, $this>
     */
    public function category(): BelongsTo
    {
        return $this->belongsTo(SymptomCategory::class);
    }

    protected static function newFactory(): SymptomEntryFactory
    {
        return SymptomEntryFactory::new();
    }
}
