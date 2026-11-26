<?php

declare(strict_types=1);

namespace App\Modules\Tracking\Database\Factories;

use App\Modules\Auth\Models\User;
use App\Modules\Tracking\Enums\Mood;
use App\Modules\Tracking\Models\MoodEntry;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<MoodEntry>
 */
final class MoodEntryFactory extends Factory
{
    protected $model = MoodEntry::class;

    /**
     * @return array<model-property<MoodEntry>, mixed>
     */
    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'mood' => fake()->randomElement(Mood::cases()),
            'score' => fake()->numberBetween(1, 10),
            'recorded_at' => now()->subHours(fake()->numberBetween(1, 48)),
        ];
    }
}
