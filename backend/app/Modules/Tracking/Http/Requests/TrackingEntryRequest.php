<?php

declare(strict_types=1);

namespace App\Modules\Tracking\Http\Requests;

use Carbon\CarbonImmutable;
use Illuminate\Foundation\Http\FormRequest;

/**
 * Shared rules for creating (POST: required fields) and editing (PUT: partial) entries.
 */
abstract class TrackingEntryRequest extends FormRequest
{
    public const int MAX_NOTES = 2000;

    public function authorize(): bool
    {
        return true;
    }

    protected function isCreate(): bool
    {
        return $this->isMethod('POST');
    }

    /** `required` when creating, `sometimes` when editing. */
    protected function presence(): string
    {
        return $this->isCreate() ? 'required' : 'sometimes';
    }

    /**
     * @return list<string>
     */
    protected function scaleRules(): array
    {
        return ['sometimes', 'nullable', 'integer', 'between:1,10'];
    }

    /**
     * When it happened: optional (defaults to now), never meaningfully in the future.
     *
     * @return list<string>
     */
    protected function recordedAtRules(): array
    {
        return [
            'sometimes',
            'date',
            'after:2000-01-01',
            'before_or_equal:'.CarbonImmutable::now()->addMinutes(5)->toIso8601String(),
        ];
    }

    /**
     * @return list<string>
     */
    protected function notesRules(): array
    {
        return ['sometimes', 'nullable', 'string', 'max:'.self::MAX_NOTES];
    }

    /**
     * Validated data with `recorded_at` normalized to UTC (and defaulted on create).
     *
     * @param  list<string>  $fields
     * @return array<string, mixed>
     */
    protected function entryData(array $fields): array
    {
        $data = $this->safe()->only($fields);

        if (array_key_exists('recorded_at', $data) && is_string($data['recorded_at'])) {
            $data['recorded_at'] = CarbonImmutable::parse($data['recorded_at'])->utc();
        } elseif ($this->isCreate()) {
            $data['recorded_at'] = CarbonImmutable::now();
        }

        if (array_key_exists('notes', $data) && is_string($data['notes'])) {
            $data['notes'] = trim($data['notes']) === '' ? null : trim($data['notes']);
        }

        return $data;
    }
}
