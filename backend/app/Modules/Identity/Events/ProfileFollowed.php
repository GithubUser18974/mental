<?php

declare(strict_types=1);

namespace App\Modules\Identity\Events;

use Illuminate\Foundation\Events\Dispatchable;

/**
 * A member started following another profile. The Notifications module (Phase 7)
 * listens ("Someone followed your profile"). Anonymous profile ids only.
 */
final readonly class ProfileFollowed
{
    use Dispatchable;

    public function __construct(
        public string $followedProfileId,
        public string $followerProfileId,
    ) {}
}
