<?php

declare(strict_types=1);

namespace App\Modules\Identity\Http\Requests;

use App\Support\Http\Middleware\SetLocaleFromHeader;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

final class UpdatePreferencesRequest extends FormRequest
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
            'language' => ['sometimes', 'required', 'string', Rule::in(SetLocaleFromHeader::SUPPORTED)],
            'timezone' => ['sometimes', 'required', 'string', 'timezone:all'],
        ];
    }

    /**
     * @return array{language?: string, timezone?: string}
     */
    public function changes(): array
    {
        /** @var array{language?: string, timezone?: string} $validated */
        $validated = $this->safe()->only(['language', 'timezone']);

        return $validated;
    }
}
