<?php

declare(strict_types=1);

namespace App\Modules\Tracking\Http\Requests;

/**
 * Sleep record (FR-TRACK-001): duration in minutes (required), quality 1–10 optional.
 */
final class SleepEntryRequest extends TrackingEntryRequest
{
    /**
     * @return array<string, list<mixed>>
     */
    public function rules(): array
    {
        return [
            'duration_minutes' => [$this->presence(), 'integer', 'between:1,1440'],
            'quality' => $this->scaleRules(),
            'recorded_at' => $this->recordedAtRules(),
        ];
    }

    /**
     * @return array<string, mixed>
     */
    public function entry(): array
    {
        return $this->entryData(['duration_minutes', 'quality', 'recorded_at']);
    }
}
