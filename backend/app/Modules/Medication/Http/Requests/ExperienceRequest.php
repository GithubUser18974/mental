<?php

declare(strict_types=1);

namespace App\Modules\Medication\Http\Requests;

use App\Modules\Medication\Enums\ExperienceKind;
use Carbon\CarbonImmutable;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

/**
 * A private experience note (FR-MED-005). `observed_on` defaults to today.
 */
final class ExperienceRequest extends FormRequest
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
        return [
            'kind' => ['required', Rule::enum(ExperienceKind::class)],
            'description' => ['required', 'string', 'min:2', 'max:2000'],
            'observed_on' => [
                'sometimes',
                'date_format:Y-m-d',
                'after:2000-01-01',
                'before_or_equal:'.CarbonImmutable::now()->addDay()->toDateString(),
            ],
        ];
    }

    /**
     * @return array{kind: string, description: string, observed_on: string}
     */
    public function experience(): array
    {
        return [
            'kind' => $this->string('kind')->toString(),
            'description' => trim($this->string('description')->toString()),
            'observed_on' => $this->filled('observed_on')
                ? $this->string('observed_on')->toString()
                : CarbonImmutable::now()->toDateString(),
        ];
    }
}
