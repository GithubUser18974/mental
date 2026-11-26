<?php

declare(strict_types=1);

namespace App\Modules\Community\Database\Factories;

use App\Modules\Community\Models\Post;
use App\Modules\Community\Models\SavedPost;
use App\Modules\Identity\Models\AnonymousProfile;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<SavedPost>
 */
final class SavedPostFactory extends Factory
{
    protected $model = SavedPost::class;

    /**
     * @return array<model-property<SavedPost>, mixed>
     */
    public function definition(): array
    {
        return [
            'profile_id' => AnonymousProfile::factory(),
            'post_id' => Post::factory(),
        ];
    }
}
