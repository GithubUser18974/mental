<?php

declare(strict_types=1);

namespace App\Modules\Identity\DTOs;

use App\Modules\Identity\Models\AnonymousProfile;
use App\Modules\Identity\Models\UserPreference;
use App\Modules\Identity\Models\UserPrivacySetting;

/**
 * Everything the signed-in user sees about their own identity and settings.
 */
final readonly class OwnIdentity
{
    public function __construct(
        public AnonymousProfile $profile,
        public UserPreference $preferences,
        public UserPrivacySetting $privacy,
    ) {}
}
