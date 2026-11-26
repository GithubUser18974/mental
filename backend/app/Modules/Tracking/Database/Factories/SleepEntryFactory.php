<?php

declare(strict_types=1);

namespace App\Modules\Tracking\Database\Factories;

use App\Modules\Auth\Models\User;
use App\Modules\Tracking\Models\SleepEntry;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<SleepEntry>
 */
final class SleepEntryFactory extends Factory
{
    protected $model = SleepEntry::class;

    /**
     * @return array<model-property<SleepEntry>, mixed>
     */
    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'duration_minutes' => fake()->numberBetween(240, 600),
            'quality' => fake()->numberBetween(1, 10),
            'recorded_at' => now()->subHours(fake()->numberBetween(1, 48)),
        ];
    }
}
