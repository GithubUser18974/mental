<?php

declare(strict_types=1);

namespace App\Modules\Community\Http\Requests;

use App\Modules\Community\Actions\SavePost;
use App\Modules\Community\Enums\ContentWarning;
use App\Modules\Community\Enums\PostVisibility;
use App\Modules\Community\Models\PostCategory;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

/**
 * Create (all required fields) and update (partial) a post.
 * `category` is the category slug; it is resolved to an id for the action.
 */
final class PostRequest extends FormRequest
{
    public const int MAX_CONTENT = 2000;

    public function authorize(): bool
    {
        return true;
    }

    private function isCreate(): bool
    {
        return $this->isMethod('post');
    }

    protected function prepareForValidation(): void
    {
        if (is_string($this->input('content'))) {
            $this->merge(['content' => trim($this->string('content')->toString())]);
        }
    }

    /**
     * @return array<string, list<mixed>>
     */
    public function rules(): array
    {
        $required = $this->isCreate() ? 'required' : 'sometimes';

        return [
            'content' => [$required, 'string', 'min:1', 'max:'.self::MAX_CONTENT],
            'category' => [$required, 'string', Rule::exists('post_categories', 'slug')->where('is_active', true)],
            'content_warning' => ['sometimes', 'nullable', Rule::enum(ContentWarning::class)],
            'allow_comments' => ['sometimes', 'boolean'],
            'visibility' => ['sometimes', Rule::enum(PostVisibility::class)],
            'media_ids' => ['sometimes', 'array', 'max:'.SavePost::MAX_MEDIA],
            'media_ids.*' => ['uuid', 'distinct'],
        ];
    }

    /**
     * @return array{category_id?: string, content?: string, content_warning?: string|null,
     *               allow_comments?: bool, visibility?: string, media_ids?: list<string>}
     */
    public function postData(): array
    {
        $validated = $this->validated();
        $data = [];

        foreach (['content', 'content_warning', 'visibility'] as $key) {
            if (array_key_exists($key, $validated)) {
                $data[$key] = $validated[$key];
            }
        }
        if (array_key_exists('allow_comments', $validated)) {
            $data['allow_comments'] = (bool) $validated['allow_comments'];
        }
        if (array_key_exists('media_ids', $validated)) {
            $data['media_ids'] = array_values(array_map('strval', (array) $validated['media_ids']));
        }
        if (array_key_exists('category', $validated)) {
            $data['category_id'] = PostCategory::query()->where('slug', $validated['category'])->value('id');
        }

        /** @var array{category_id?: string, content?: string, content_warning?: string|null, allow_comments?: bool, visibility?: string, media_ids?: list<string>} $data */
        return $data;
    }
}
