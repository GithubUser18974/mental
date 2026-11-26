<?php

declare(strict_types=1);

namespace App\Modules\Identity\Http\Requests;

use App\Modules\Identity\Actions\ListConnections;
use Illuminate\Foundation\Http\FormRequest;

final class ConnectionListRequest extends FormRequest
{
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
            'per_page' => ['sometimes', 'integer', 'min:1', 'max:'.ListConnections::MAX_PER_PAGE],
            'cursor' => ['sometimes', 'string'],
        ];
    }

    public function perPage(): int
    {
        return $this->integer('per_page', 20);
    }
}
