<?php

declare(strict_types=1);

namespace App\Modules\Tracking\Database\Factories;

use App\Modules\Auth\Models\User;
use App\Modules\Tracking\Models\SymptomCategory;
use App\Modules\Tracking\Models\SymptomEntry;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<SymptomEntry>
 */
final class SymptomEntryFactory extends Factory
{
    protected $model = SymptomEntry::class;

    /**
     * @return array<model-property<SymptomEntry>, mixed>
     */
    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'category_id' => static fn (): string => (string) SymptomCategory::query()->inRandomOrder()->value('id'),
            'severity' => fake()->numberBetween(1, 10),
            'recorded_at' => now()->subHours(fake()->numberBetween(1, 48)),
        ];
    }
}
