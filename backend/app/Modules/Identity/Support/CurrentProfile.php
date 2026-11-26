<?php

declare(strict_types=1);

namespace App\Modules\Identity\Support;

use App\Modules\Auth\Models\User;
use App\Modules\Identity\Actions\EnsureIdentity;
use App\Modules\Identity\Models\AnonymousProfile;
use Illuminate\Contracts\Auth\Authenticatable;

/**
 * The signed-in account's anonymous profile, resolved once per request (scoped service).
 * Policies, controllers and other modules share it instead of re-querying.
 */
final class CurrentProfile
{
    /** @var array<string, AnonymousProfile> */
    private array $cache = [];

    public function __construct(private readonly EnsureIdentity $ensureIdentity) {}

    public function for(?Authenticatable $user): ?AnonymousProfile
    {
        if (! $user instanceof User) {
            return null;
        }

        return $this->cache[$user->id] ??= ($this->ensureIdentity)($user)->profile;
    }

    public function require(?Authenticatable $user): AnonymousProfile
    {
        $profile = $this->for($user);
        abort_if($profile === null, 401);

        return $profile;
    }
}
