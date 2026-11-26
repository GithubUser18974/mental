<?php

declare(strict_types=1);

namespace App\Modules\Tracking\Http\Requests;

use App\Modules\Tracking\Models\SymptomCategory;
use Illuminate\Validation\Rule;

/**
 * Symptom entry (FR-TRACK-003): active category (by slug) + severity 1–10; duration in
 * minutes and notes optional.
 */
final class SymptomEntryRequest extends TrackingEntryRequest
{
    /**
     * @return array<string, list<mixed>>
     */
    public function rules(): array
    {
        return [
            'category' => [
                $this->presence(),
                'string',
                Rule::exists('symptom_categories', 'slug')->where('is_active', true),
            ],
            'severity' => [$this->presence(), 'integer', 'between:1,10'],
            'duration_minutes' => ['sometimes', 'nullable', 'integer', 'between:1,10080'],
            'notes' => $this->notesRules(),
            'recorded_at' => $this->recordedAtRules(),
        ];
    }

    /**
     * @return array<string, mixed>
     */
    public function entry(): array
    {
        $data = $this->entryData(['severity', 'duration_minutes', 'notes', 'recorded_at']);

        if ($this->filled('category')) {
            $data['category_id'] = SymptomCategory::query()
                ->where('slug', $this->string('category')->toString())
                ->value('id');
        }

        return $data;
    }
}
