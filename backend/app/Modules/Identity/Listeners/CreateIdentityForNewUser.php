<?php

declare(strict_types=1);

namespace App\Modules\Identity\Listeners;

use App\Modules\Auth\Events\UserRegistered;
use App\Modules\Identity\Actions\EnsureIdentity;

/**
 * Runs synchronously inside the registration transaction, so an account never
 * exists without its anonymous identity. Language defaults to the request locale.
 */
final class CreateIdentityForNewUser
{
    public function __construct(private readonly EnsureIdentity $ensureIdentity) {}

    public function handle(UserRegistered $event): void
    {
        ($this->ensureIdentity)($event->user, app()->getLocale());
    }
}
