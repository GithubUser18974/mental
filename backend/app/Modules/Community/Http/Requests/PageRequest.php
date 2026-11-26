<?php

declare(strict_types=1);

namespace App\Modules\Community\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

/**
 * Plain cursor-paginated listing (comments, replies, saved posts).
 */
final class PageRequest extends FormRequest
{
    public const int MAX_PER_PAGE = 50;

    public function authorize(): bool
    {
        return true;
    }

    /**
     * @return array<string, list<string>>
     */
    public function rules(): array
    {
        return [
            'per_page' => ['sometimes', 'integer', 'min:1', 'max:'.self::MAX_PER_PAGE],
            'cursor' => ['sometimes', 'string'],
        ];
    }

    public function perPage(): int
    {
        return $this->integer('per_page', 20);
    }
}
