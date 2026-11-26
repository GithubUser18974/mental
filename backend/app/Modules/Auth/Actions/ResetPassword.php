<?php

declare(strict_types=1);

namespace App\Modules\Auth\Actions;

use App\Modules\Auth\Models\User;
use App\Support\Translation\Message;
use Illuminate\Auth\Events\PasswordReset;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Password;
use Illuminate\Validation\ValidationException;
use SensitiveParameter;

/**
 * Completes a password reset and signs the account out of every device.
 */
final class ResetPassword
{
    public function __invoke(
        string $email,
        #[SensitiveParameter] string $token,
        #[SensitiveParameter] string $password,
    ): void {
        $status = Password::broker()->reset(
            ['email' => $email, 'token' => $token, 'password' => $password],
            static function (User $user, string $password): void {
                $user->password = $password;
                $user->setRememberToken(null);
                $user->save();

                $user->tokens()->delete();

                event(new PasswordReset($user));
                Log::info('auth.password_reset', ['user_id' => $user->id]);
            },
        );

        if ($status !== Password::PASSWORD_RESET) {
            // Same message for unknown email, wrong or expired token.
            throw ValidationException::withMessages([
                'token' => [Message::get('auth::messages.reset_token_invalid')],
            ]);
        }
    }
}
