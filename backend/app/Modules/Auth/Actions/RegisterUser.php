<?php

declare(strict_types=1);

namespace App\Modules\Auth\Actions;

use App\Modules\Auth\DTOs\IssuedToken;
use App\Modules\Auth\Events\UserRegistered;
use App\Modules\Auth\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use SensitiveParameter;

/**
 * FR-AUTH-001: create an email + password account and sign it in.
 */
final class RegisterUser
{
    public function __construct(private readonly IssueAccessToken $issueToken) {}

    public function __invoke(
        string $email,
        #[SensitiveParameter] string $password,
        ?string $deviceName = null,
    ): IssuedToken {
        return DB::transaction(function () use ($email, $password, $deviceName): IssuedToken {
            $now = now();

            $user = User::query()->create([
                'email' => $email,
                'password' => $password,
                'age_confirmed_at' => $now,
                'terms_accepted_at' => $now,
            ]);

            UserRegistered::dispatch($user);

            Log::info('auth.registered', ['user_id' => $user->id]);

            return ($this->issueToken)($user, $deviceName);
        });
    }
}
