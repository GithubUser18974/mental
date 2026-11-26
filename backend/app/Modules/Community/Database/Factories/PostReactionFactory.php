<?php

declare(strict_types=1);

namespace App\Modules\Community\Database\Factories;

use App\Modules\Community\Enums\ReactionType;
use App\Modules\Community\Models\Post;
use App\Modules\Community\Models\PostReaction;
use App\Modules\Identity\Models\AnonymousProfile;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<PostReaction>
 */
final class PostReactionFactory extends Factory
{
    protected $model = PostReaction::class;

    /**
     * @return array<model-property<PostReaction>, mixed>
     */
    public function definition(): array
    {
        return [
            'post_id' => Post::factory(),
            'profile_id' => AnonymousProfile::factory(),
            'type' => fake()->randomElement(ReactionType::cases()),
        ];
    }
}
