<?php

declare(strict_types=1);

namespace App\Modules\Auth\Database\Factories;

use App\Modules\Auth\Enums\AccountStatus;
use App\Modules\Auth\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Facades\Hash;

/**
 * @extends Factory<User>
 */
final class UserFactory extends Factory
{
    public const string PASSWORD = 'Password123';

    protected $model = User::class;

    private static ?string $passwordHash = null;

    /**
     * @return array<model-property<User>, mixed>
     */
    public function definition(): array
    {
        return [
            'email' => mb_strtolower(fake()->unique()->safeEmail()),
            'password' => self::$passwordHash ??= Hash::make(self::PASSWORD),
            'status' => AccountStatus::Active,
            'age_confirmed_at' => now(),
            'terms_accepted_at' => now(),
        ];
    }

    public function suspended(): static
    {
        return $this->state(['status' => AccountStatus::Suspended]);
    }

    public function deactivated(): static
    {
        return $this->state(['status' => AccountStatus::Deactivated]);
    }
}
