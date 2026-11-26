<?php

declare(strict_types=1);

namespace App\Modules\Community\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

/**
 * Create (POST /posts/{post}/comments) or edit (PUT /comments/{comment}) a comment.
 */
final class CommentRequest extends FormRequest
{
    public const int MAX_LENGTH = 1000;

    public function authorize(): bool
    {
        return true;
    }

    /**
     * @return array<string, list<string>>
     */
    public function rules(): array
    {
        $rules = [
            'content' => ['required', 'string', 'max:'.self::MAX_LENGTH],
        ];

        if ($this->isMethod('POST')) {
            $rules['parent_id'] = ['sometimes', 'nullable', 'uuid'];
        }

        return $rules;
    }

    public function commentText(): string
    {
        return $this->string('content')->toString();
    }

    public function parentId(): ?string
    {
        return $this->filled('parent_id') ? $this->string('parent_id')->toString() : null;
    }
}
