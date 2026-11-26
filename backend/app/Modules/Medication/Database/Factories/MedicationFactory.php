<?php

declare(strict_types=1);

namespace App\Modules\Medication\Database\Factories;

use App\Modules\Auth\Models\User;
use App\Modules\Medication\Enums\DosageUnit;
use App\Modules\Medication\Enums\MedicationStatus;
use App\Modules\Medication\Enums\ScheduleType;
use App\Modules\Medication\Models\Medication;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Medication>
 */
final class MedicationFactory extends Factory
{
    protected $model = Medication::class;

    /**
     * @return array<model-property<Medication>, mixed>
     */
    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'name' => 'Medication '.fake()->unique()->numberBetween(1, 9999),
            'dosage' => (string) fake()->randomElement([5, 10, 20, 50]),
            'unit' => DosageUnit::Mg,
            'start_date' => now()->subDays(30)->toDateString(),
        ];
    }

    /**
     * Attach a schedule after creating.
     *
     * @param  list<string>  $times
     * @param  list<int>|null  $days
     */
    public function scheduled(
        ScheduleType $type = ScheduleType::Daily,
        array $times = ['08:00'],
        ?array $days = null,
        ?int $interval = null,
    ): static {
        return $this->afterCreating(function (Medication $medication) use ($type, $times, $days, $interval): void {
            $medication->schedule()->create([
                'type' => $type,
                'times' => $times,
                'days_of_week' => $days,
                'interval_days' => $interval,
            ]);
        });
    }

    public function discontinued(): static
    {
        return $this->state(['status' => MedicationStatus::Discontinued, 'discontinued_at' => now()]);
    }
}
