<?php

declare(strict_types=1);

namespace Database\Seeders;

use App\Modules\Auth\Models\User;
use App\Modules\Identity\Actions\EnsureIdentity;
use Illuminate\Database\Seeder;

/**
 * Local development data only. Never real personal data.
 */
final class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        /** @var User $user */
        $user = User::factory()->create(['email' => 'demo@example.com']);
        app(EnsureIdentity::class)($user);
    }
}
