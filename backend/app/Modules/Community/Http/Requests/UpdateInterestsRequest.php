<?php

declare(strict_types=1);

namespace App\Modules\Community\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

final class UpdateInterestsRequest extends FormRequest
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
            'categories' => ['present', 'array', 'max:20'],
            'categories.*' => ['string', 'distinct', Rule::exists('post_categories', 'slug')->where('is_active', true)],
        ];
    }

    /**
     * @return list<string>
     */
    public function slugs(): array
    {
        return array_values(array_map('strval', (array) $this->validated('categories', [])));
    }
}
