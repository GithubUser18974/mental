<?php

declare(strict_types=1);

namespace App\Modules\Medication\Http\Requests;

use App\Modules\Medication\Enums\DosageUnit;
use App\Modules\Medication\Enums\MedicationStatus;
use App\Modules\Medication\Enums\ScheduleType;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

/**
 * Add (POST, required fields per FR-MED-001) or edit (PUT, partial) a medication and its
 * schedule (FR-MED-002). Invalid records are rejected (SRS §13.3 #9).
 */
final class MedicationRequest extends FormRequest
{
    public const int MAX_TIMES = 8;

    public function authorize(): bool
    {
        return true;
    }

    /**
     * @return array<string, list<mixed>>
     */
    public function rules(): array
    {
        $create = $this->isMethod('POST');
        $required = $create ? 'required' : 'sometimes';
        $type = ScheduleType::tryFrom($this->string('schedule.type')->toString());

        return [
            'name' => [$required, 'string', 'min:1', 'max:120'],
            'dosage' => [$required, 'string', 'max:30', 'regex:/^\d+([.,]\d+)?(\s*[-–]\s*\d+([.,]\d+)?)?$/'],
            'unit' => [$required, Rule::enum(DosageUnit::class)],
            'start_date' => [$required, 'date_format:Y-m-d'],
            'end_date' => ['sometimes', 'nullable', 'date_format:Y-m-d', 'after_or_equal:start_date'],
            'instructions' => ['sometimes', 'nullable', 'string', 'max:1000'],
            'clinician' => ['sometimes', 'nullable', 'string', 'max:120'],
            'notes' => ['sometimes', 'nullable', 'string', 'max:2000'],
            'reminders_enabled' => ['sometimes', 'boolean'],
            'status' => [$create ? 'prohibited' : 'sometimes', Rule::enum(MedicationStatus::class)],

            'schedule' => [$required, 'array'],
            'schedule.type' => ['required_with:schedule', Rule::enum(ScheduleType::class)],
            'schedule.times' => [
                $type === null || $type === ScheduleType::AsNeeded ? 'prohibited' : 'required',
                'array',
                'min:1',
                'max:'.self::MAX_TIMES,
            ],
            'schedule.times.*' => ['string', 'date_format:H:i', 'distinct'],
            'schedule.days_of_week' => [
                $type === ScheduleType::Weekly ? 'required' : 'prohibited',
                'array',
                'min:1',
                'max:7',
            ],
            'schedule.days_of_week.*' => ['integer', 'between:1,7', 'distinct'],
            'schedule.interval_days' => [
                $type === ScheduleType::Interval ? 'required' : 'prohibited',
                'integer',
                'between:2,90',
            ],
        ];
    }

    /**
     * Medication fields only (no schedule), trimmed; empty optional text → null.
     *
     * @return array<string, mixed>
     */
    public function medication(): array
    {
        $data = $this->safe()->except(['schedule']);
        foreach (['name', 'dosage', 'instructions', 'clinician', 'notes'] as $field) {
            if (array_key_exists($field, $data) && is_string($data[$field])) {
                $value = trim($data[$field]);
                $data[$field] = $value === '' && $field !== 'name' && $field !== 'dosage' ? null : $value;
            }
        }
        if (isset($data['dosage']) && is_string($data['dosage'])) {
            $data['dosage'] = str_replace(',', '.', $data['dosage']);
        }

        return $data;
    }

    /**
     * Normalized schedule, or null when not sent (edits keep the current schedule).
     *
     * @return array{type: ScheduleType, times: list<string>, days_of_week: list<int>|null, interval_days: int|null}|null
     */
    public function schedule(): ?array
    {
        if (! $this->has('schedule')) {
            return null;
        }

        $type = ScheduleType::from($this->string('schedule.type')->toString());
        /** @var list<string> $times */
        $times = array_values((array) $this->input('schedule.times', []));
        sort($times);
        /** @var list<int> $days */
        $days = array_map('intval', (array) $this->input('schedule.days_of_week', []));
        sort($days);

        return [
            'type' => $type,
            'times' => $type === ScheduleType::AsNeeded ? [] : $times,
            'days_of_week' => $type === ScheduleType::Weekly ? $days : null,
            'interval_days' => $type === ScheduleType::Interval ? $this->integer('schedule.interval_days') : null,
        ];
    }
}
