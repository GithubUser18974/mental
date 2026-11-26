<?php

declare(strict_types=1);

namespace App\Modules\Community\Database\Factories;

use App\Modules\Community\Enums\ContentWarning;
use App\Modules\Community\Enums\ModerationStatus;
use App\Modules\Community\Enums\PostVisibility;
use App\Modules\Community\Models\Post;
use App\Modules\Community\Models\PostCategory;
use App\Modules\Identity\Models\AnonymousProfile;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Post>
 */
final class PostFactory extends Factory
{
    protected $model = Post::class;

    /**
     * @return array<model-property<Post>, mixed>
     */
    public function definition(): array
    {
        return [
            'author_profile_id' => AnonymousProfile::factory(),
            'category_id' => static fn (): string => (string) PostCategory::query()->inRandomOrder()->value('id'),
            'content' => fake()->sentence(12),
            'visibility' => PostVisibility::Community,
        ];
    }

    public function inCategory(string $slug): static
    {
        return $this->state(fn (): array => [
            'category_id' => (string) PostCategory::query()->where('slug', $slug)->value('id'),
        ]);
    }

    public function onlyMe(): static
    {
        return $this->state(['visibility' => PostVisibility::OnlyMe]);
    }

    public function withWarning(ContentWarning $warning = ContentWarning::Sensitive): static
    {
        return $this->state(['content_warning' => $warning]);
    }

    public function moderated(ModerationStatus $status): static
    {
        return $this->state(['moderation_status' => $status]);
    }
}
