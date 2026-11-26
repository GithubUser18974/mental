<?php

declare(strict_types=1);

namespace App\Modules\Community\Database\Factories;

use App\Modules\Community\Enums\ModerationStatus;
use App\Modules\Community\Models\Comment;
use App\Modules\Community\Models\Post;
use App\Modules\Identity\Models\AnonymousProfile;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Comment>
 */
final class CommentFactory extends Factory
{
    protected $model = Comment::class;

    /**
     * @return array<model-property<Comment>, mixed>
     */
    public function definition(): array
    {
        return [
            'post_id' => Post::factory(),
            'author_profile_id' => AnonymousProfile::factory(),
            'content' => fake()->sentence(8),
        ];
    }

    public function replyTo(Comment $parent): static
    {
        return $this->state(['post_id' => $parent->post_id, 'parent_id' => $parent->id]);
    }

    public function moderated(ModerationStatus $status): static
    {
        return $this->state(['moderation_status' => $status]);
    }
}
