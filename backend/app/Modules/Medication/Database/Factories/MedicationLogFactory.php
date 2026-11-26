<?php

declare(strict_types=1);

namespace App\Modules\Medication\Database\Factories;

use App\Modules\Medication\Enums\IntakeStatus;
use App\Modules\Medication\Models\Medication;
use App\Modules\Medication\Models\MedicationLog;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<MedicationLog>
 */
final class MedicationLogFactory extends Factory
{
    protected $model = MedicationLog::class;

    /**
     * @return array<model-property<MedicationLog>, mixed>
     */
    public function definition(): array
    {
        return [
            'medication_id' => Medication::factory(),
            'user_id' => static fn (array $attributes): string => (string) Medication::query()
                ->whereKey($attributes['medication_id'])
                ->value('user_id'),
            'scheduled_at' => now()->subHours(fake()->numberBetween(1, 72))->startOfHour(),
            'taken_at' => now()->subHour(),
            'status' => IntakeStatus::Taken,
        ];
    }
}
