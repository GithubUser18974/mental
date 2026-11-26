<?php

declare(strict_types=1);

namespace App\Modules\Medication\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

final class MedicationListRequest extends FormRequest
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
            'status' => ['sometimes', Rule::in(['current', 'past', 'all'])],
            'per_page' => ['sometimes', 'integer', 'min:1', 'max:100'],
            'cursor' => ['sometimes', 'string'],
        ];
    }

    public function filter(): string
    {
        return $this->string('status', 'current')->toString();
    }

    public function perPage(): int
    {
        return $this->integer('per_page', 50);
    }
}
