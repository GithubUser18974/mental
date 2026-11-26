<?php

declare(strict_types=1);

namespace App\Modules\Tracking\Http\Requests;

use App\Modules\Tracking\Enums\Mood;
use Illuminate\Validation\Rule;

/**
 * Daily check-in (FR-TRACK-001/002). Only `mood` is required; every scale is optional.
 */
final class MoodEntryRequest extends TrackingEntryRequest
{
    /**
     * @return array<string, list<mixed>>
     */
    public function rules(): array
    {
        return [
            'mood' => [$this->presence(), 'string', Rule::enum(Mood::class)],
            'score' => $this->scaleRules(),
            'anxiety' => $this->scaleRules(),
            'stress' => $this->scaleRules(),
            'energy' => $this->scaleRules(),
            'notes' => $this->notesRules(),
            'recorded_at' => $this->recordedAtRules(),
        ];
    }

    /**
     * @return array<string, mixed>
     */
    public function entry(): array
    {
        return $this->entryData(['mood', 'score', 'anxiety', 'stress', 'energy', 'notes', 'recorded_at']);
    }
}
