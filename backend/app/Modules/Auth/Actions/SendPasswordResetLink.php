<?php

declare(strict_types=1);

namespace App\Modules\Auth\Actions;

use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Password;

/**
 * Sends a reset link if the account exists. The caller always gets the same answer
 * whether or not the email is registered (no account enumeration).
 */
final class SendPasswordResetLink
{
    public function __invoke(string $email): void
    {
        $status = Password::broker()->sendResetLink(['email' => $email]);

        // Only the outcome category is logged — never the email.
        Log::info('auth.password_reset_requested', ['result' => $status]);
    }
}
