<?php

declare(strict_types=1);

namespace App\Modules\Auth\DTOs;

use App\Modules\Auth\Models\User;
use Carbon\CarbonImmutable;
use SensitiveParameter;

/**
 * A freshly issued API token. `plainTextToken` is shown to the client exactly once.
 */
final readonly class IssuedToken
{
    public function __construct(
        public User $user,
        #[SensitiveParameter] public string $plainTextToken,
        public CarbonImmutable $expiresAt,
    ) {}
}
