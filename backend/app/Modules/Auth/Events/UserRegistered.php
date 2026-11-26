<?php

declare(strict_types=1);

namespace App\Modules\Auth\Events;

use App\Modules\Auth\Models\User;
use Illuminate\Foundation\Events\Dispatchable;

/**
 * Fired after a new account is created. Identity (T1.2) listens to create the
 * anonymous public profile.
 */
final class UserRegistered
{
    use Dispatchable;

    public function __construct(public readonly User $user) {}
}
