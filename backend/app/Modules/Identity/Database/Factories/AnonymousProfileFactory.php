<?php

declare(strict_types=1);

namespace App\Modules\Identity\Database\Factories;

use App\Modules\Auth\Models\User;
use App\Modules\Identity\Models\AnonymousProfile;
use App\Modules\Identity\Support\AvatarCatalog;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<AnonymousProfile>
 */
final class AnonymousProfileFactory extends Factory
{
    protected $model = AnonymousProfile::class;

    /**
     * @return array<model-property<AnonymousProfile>, mixed>
     */
    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'username' => 'Member'.fake()->unique()->numberBetween(1000, 999999),
            'avatar' => AvatarCatalog::random(),
            'bio' => null,
        ];
    }

    public function setupCompleted(): static
    {
        return $this->state(['setup_completed_at' => now()]);
    }
}
