<?php

declare(strict_types=1);

namespace App\Modules\Community\Http\Requests;

use App\Modules\Community\Actions\BuildFeed;
use App\Modules\Community\DTOs\FeedFilters;
use App\Modules\Community\Enums\FeedSort;
use App\Modules\Community\Models\PostCategory;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

final class FeedRequest extends FormRequest
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
            'sort' => ['sometimes', Rule::enum(FeedSort::class)],
            'category' => ['sometimes', 'string', Rule::exists('post_categories', 'slug')],
            'hashtag' => ['sometimes', 'string', 'max:31'],
            'following' => ['sometimes', 'boolean'],
            // Post text search (FR-COM-008).
            'q' => ['sometimes', 'string', 'min:2', 'max:100'],
            'per_page' => ['sometimes', 'integer', 'min:1', 'max:'.BuildFeed::MAX_PER_PAGE],
            'cursor' => ['sometimes', 'string'],
        ];
    }

    public function filters(): FeedFilters
    {
        return new FeedFilters(
            sort: $this->sort(),
            categoryId: $this->categoryId(),
            hashtag: $this->hashtag(),
            followingOnly: $this->boolean('following'),
            search: $this->filled('q') ? trim($this->string('q')->toString()) : null,
            perPage: $this->perPage(),
        );
    }

    public function sort(): FeedSort
    {
        return FeedSort::tryFrom($this->string('sort')->toString()) ?? FeedSort::Recent;
    }

    public function categoryId(): ?string
    {
        if (! $this->filled('category')) {
            return null;
        }

        $id = PostCategory::query()->where('slug', $this->string('category')->toString())->value('id');

        return is_string($id) ? $id : null;
    }

    public function hashtag(): ?string
    {
        return $this->filled('hashtag') ? $this->string('hashtag')->toString() : null;
    }

    public function perPage(): int
    {
        return $this->integer('per_page', BuildFeed::DEFAULT_PER_PAGE);
    }
}
