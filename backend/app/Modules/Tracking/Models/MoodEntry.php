<?php

declare(strict_types=1);

namespace App\Modules\Tracking\Models;

use App\Modules\Tracking\Database\Factories\MoodEntryFactory;
use App\Modules\Tracking\Enums\Mood;
use App\Modules\Tracking\Models\Concerns\OwnedByUser;
use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * Daily check-in (FR-TRACK-001/002): mood plus optional 1–10 scales and private notes.
 *
 * @property string $id
 * @property string $user_id
 * @property Mood $mood
 * @property int|null $score
 * @property int|null $anxiety
 * @property int|null $stress
 * @property int|null $energy
 * @property string|null $notes
 * @property CarbonImmutable $recorded_at
 * @property CarbonImmutable $created_at
 * @property CarbonImmutable $updated_at
 */
#[Fillable(['user_id', 'mood', 'score', 'anxiety', 'stress', 'energy', 'notes', 'recorded_at'])]
class MoodEntry extends Model
{
    /** @use HasFactory<MoodEntryFactory> */
    use HasFactory;

    use HasUuids;
    use OwnedByUser;

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'mood' => Mood::class,
            'score' => 'integer',
            'anxiety' => 'integer',
            'stress' => 'integer',
            'energy' => 'integer',
            'notes' => 'encrypted',
            'recorded_at' => 'immutable_datetime',
        ];
    }

    protected static function newFactory(): MoodEntryFactory
    {
        return MoodEntryFactory::new();
    }
}
