<?php

declare(strict_types=1);

namespace App\Modules\Auth\Actions;

use App\Modules\Auth\DTOs\IssuedToken;
use App\Modules\Auth\Exceptions\AccountInactiveException;
use App\Modules\Auth\Models\User;
use App\Support\Translation\Message;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;
use SensitiveParameter;

/**
 * Email + password sign-in.
 *
 * Anti-enumeration: unknown email and wrong password produce the same response and
 * comparable timing (a dummy hash is checked when the account doesn't exist).
 */
final class AuthenticateUser
{
    private static ?string $dummyHash = null;

    public function __construct(private readonly IssueAccessToken $issueToken) {}

    public function __invoke(
        string $email,
        #[SensitiveParameter] string $password,
        ?string $deviceName = null,
    ): IssuedToken {
        $user = User::query()->where('email', $email)->first();

        $passwordMatches = Hash::check($password, $user->password ?? self::dummyHash());

        if ($user === null || ! $passwordMatches) {
            Log::notice('auth.login_failed', ['ip' => request()->ip()]);

            throw ValidationException::withMessages([
                'email' => [Message::get('auth::messages.credentials_invalid')],
            ]);
        }

        if (! $user->status->canSignIn()) {
            Log::notice('auth.login_blocked', ['user_id' => $user->id, 'status' => $user->status->value]);

            throw new AccountInactiveException;
        }

        if (Hash::needsRehash($user->password)) {
            $user->password = $password;
        }

        $user->last_login_at = CarbonImmutable::now();
        $user->save();

        Log::info('auth.login', ['user_id' => $user->id]);

        return ($this->issueToken)($user, $deviceName);
    }

    private static function dummyHash(): string
    {
        return self::$dummyHash ??= Hash::make(Str::random(40));
    }
}
