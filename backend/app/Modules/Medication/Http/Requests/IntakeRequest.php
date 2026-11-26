<?php

declare(strict_types=1);

namespace App\Modules\Medication\Http\Requests;

use App\Modules\Medication\Enums\IntakeStatus;
use Carbon\CarbonImmutable;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

/**
 * Record a dose (FR-MED-004): status, the scheduled time (omit for as-needed doses), the
 * actual intake time when taken / delayed, and an optional private note.
 */
final class IntakeRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /**
     * @return array<string, list<mixed>>
     */
    public function rules(): array
    {
        $soon = CarbonImmutable::now()->addMinutes(5)->toIso8601String();
        $status = IntakeStatus::tryFrom($this->string('status')->toString());

        return [
            'status' => ['required', Rule::enum(IntakeStatus::class)],
            'scheduled_at' => ['sometimes', 'nullable', 'date', 'after:2000-01-01'],
            'taken_at' => [
                $status?->requiresTakenAt() === true ? 'required' : 'prohibited',
                'date',
                'after:2000-01-01',
                'before_or_equal:'.$soon,
            ],
            'notes' => ['sometimes', 'nullable', 'string', 'max:1000'],
        ];
    }

    /**
     * @return array{status: IntakeStatus, scheduled_at: CarbonImmutable|null, taken_at: CarbonImmutable|null, notes: string|null}
     */
    public function intake(): array
    {
        $notes = $this->filled('notes') ? trim($this->string('notes')->toString()) : null;

        return [
            'status' => IntakeStatus::from($this->string('status')->toString()),
            'scheduled_at' => $this->filled('scheduled_at')
                ? CarbonImmutable::parse($this->string('scheduled_at')->toString())->utc()
                : null,
            'taken_at' => $this->filled('taken_at')
                ? CarbonImmutable::parse($this->string('taken_at')->toString())->utc()
                : null,
            'notes' => $notes === '' ? null : $notes,
        ];
    }
}
