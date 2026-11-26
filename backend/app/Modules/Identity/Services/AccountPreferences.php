<?php

declare(strict_types=1);

namespace App\Modules\Identity\Services;

use App\Modules\Identity\Models\UserPreference;
use DateTimeZone;
use Exception;

/**
 * Public read API for account preferences other modules need (e.g. Tracking groups
 * days in the member's own timezone). Never exposes anything identifying.
 */
final class AccountPreferences
{
    public function timezone(string $userId): DateTimeZone
    {
        $name = UserPreference::query()->where('user_id', $userId)->value('timezone');

        try {
            return new DateTimeZone(is_string($name) && $name !== '' ? $name : 'UTC');
        } catch (Exception) {
            return new DateTimeZone('UTC');
        }
    }
}
