<?php

declare(strict_types=1);

namespace App\Modules\Identity\Support;

use App\Modules\Identity\Models\AnonymousProfile;

/**
 * Username rules (FR-AUTH-002 "availability and abuse-prevention rules").
 */
final class UsernamePolicy
{
    /** 3–20 chars, starts with a letter, letters/digits/underscore only (no `@`, spaces or dots). */
    public const string PATTERN = '/^[A-Za-z][A-Za-z0-9_]{2,19}$/';

    /** After onboarding, a username can be changed once per this many days. */
    public const int CHANGE_COOLDOWN_DAYS = 30;

    /** Exact names nobody may take (case-insensitive). */
    private const array RESERVED = [
        'y', 'me', 'admin', 'root', 'system', 'support', 'help', 'crisis', 'moderator', 'mod',
        'staff', 'team', 'official', 'security', 'privacy', 'profile', 'profiles', 'settings',
        'api', 'null', 'undefined', 'anonymous', 'deleted', 'everyone', 'nobody',
    ];

    /** Fragments that would let someone impersonate the platform. */
    private const array FORBIDDEN_FRAGMENTS = ['admin', 'moderator', 'support', 'official', 'staff'];

    public static function isWellFormed(string $username): bool
    {
        return preg_match(self::PATTERN, $username) === 1;
    }

    public static function isReserved(string $username): bool
    {
        $lower = mb_strtolower($username);

        if (in_array($lower, self::RESERVED, true)) {
            return true;
        }

        foreach (self::FORBIDDEN_FRAGMENTS as $fragment) {
            if (str_contains($lower, $fragment)) {
                return true;
            }
        }

        return false;
    }

    public static function isTaken(string $username, ?string $exceptProfileId = null): bool
    {
        return AnonymousProfile::query()
            ->whereRaw('lower(username) = ?', [mb_strtolower($username)])
            ->when($exceptProfileId !== null, static fn ($q) => $q->whereKeyNot($exceptProfileId))
            ->exists();
    }

    public static function isAvailable(string $username, ?string $exceptProfileId = null): bool
    {
        return self::isWellFormed($username)
            && ! self::isReserved($username)
            && ! self::isTaken($username, $exceptProfileId);
    }
}
