<?php

declare(strict_types=1);

namespace App\Modules\Identity\Actions;

use App\Modules\Auth\Models\User;
use App\Modules\Identity\DTOs\OwnIdentity;
use App\Modules\Identity\Models\AnonymousProfile;
use App\Modules\Identity\Models\UserPreference;
use App\Modules\Identity\Models\UserPrivacySetting;
use App\Modules\Identity\Support\AvatarCatalog;
use App\Modules\Identity\Support\UsernameGenerator;
use App\Modules\Identity\Support\UsernamePolicy;
use App\Support\Http\Middleware\SetLocaleFromHeader;
use Illuminate\Database\UniqueConstraintViolationException;
use Illuminate\Support\Facades\DB;
use RuntimeException;

/**
 * Idempotently creates a user's anonymous profile, preferences and privacy settings
 * (FR-AUTH-002). Runs on registration; also self-heals accounts missing any part.
 */
final class EnsureIdentity
{
    private const int MAX_USERNAME_ATTEMPTS = 10;

    public function __construct(private readonly UsernameGenerator $generator) {}

    public function __invoke(User $user, ?string $language = null): OwnIdentity
    {
        $language = in_array($language, SetLocaleFromHeader::SUPPORTED, true) ? $language : 'en';

        return new OwnIdentity(
            profile: $this->profile($user),
            preferences: UserPreference::query()->firstOrCreate(
                ['user_id' => $user->id],
                ['language' => $language, 'timezone' => 'UTC'],
            ),
            privacy: UserPrivacySetting::query()->firstOrCreate(['user_id' => $user->id]),
        );
    }

    private function profile(User $user): AnonymousProfile
    {
        $existing = AnonymousProfile::query()->where('user_id', $user->id)->first();
        if ($existing !== null) {
            return $existing;
        }

        for ($attempt = 1; $attempt <= self::MAX_USERNAME_ATTEMPTS; $attempt++) {
            $username = $this->generator->generate();

            if (! UsernamePolicy::isAvailable($username)) {
                continue;
            }

            try {
                // Nested transaction = savepoint, so a unique violation doesn't abort an
                // enclosing registration transaction on PostgreSQL.
                return DB::transaction(static fn (): AnonymousProfile => AnonymousProfile::query()->create([
                    'user_id' => $user->id,
                    'username' => $username,
                    'avatar' => AvatarCatalog::random(),
                ]));
            } catch (UniqueConstraintViolationException) {
                // Lost a race: either the username was just taken (retry) or another
                // request created this user's profile (return it).
                $existing = AnonymousProfile::query()->where('user_id', $user->id)->first();
                if ($existing !== null) {
                    return $existing;
                }
            }
        }

        throw new RuntimeException('Could not generate a unique username.');
    }
}
