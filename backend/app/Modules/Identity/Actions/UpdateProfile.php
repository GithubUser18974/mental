<?php

declare(strict_types=1);

namespace App\Modules\Identity\Actions;

use App\Modules\Identity\Models\AnonymousProfile;
use App\Support\Translation\Message;
use Carbon\CarbonImmutable;
use Illuminate\Database\UniqueConstraintViolationException;
use Illuminate\Validation\ValidationException;

/**
 * Updates username / avatar / bio (FR-ONB-002). The first save completes profile setup.
 * After setup, a real username change is limited by the cooldown in UsernamePolicy.
 */
final class UpdateProfile
{
    /**
     * @param  array{username?: string, avatar?: string, bio?: string|null}  $changes
     */
    public function __invoke(AnonymousProfile $profile, array $changes): AnonymousProfile
    {
        if (array_key_exists('username', $changes)) {
            $this->changeUsername($profile, $changes['username']);
        }

        if (array_key_exists('avatar', $changes)) {
            $profile->avatar = $changes['avatar'];
        }

        if (array_key_exists('bio', $changes)) {
            $profile->bio = $changes['bio'];
        }

        $profile->setup_completed_at ??= CarbonImmutable::now();

        try {
            $profile->save();
        } catch (UniqueConstraintViolationException) {
            // Someone took the username between validation and save.
            throw ValidationException::withMessages([
                'username' => [Message::get('identity::messages.username_taken')],
            ]);
        }

        return $profile;
    }

    private function changeUsername(AnonymousProfile $profile, string $username): void
    {
        $isRealChange = mb_strtolower($username) !== mb_strtolower($profile->username);

        if ($isRealChange) {
            $availableAt = $profile->usernameChangeAvailableAt();

            if ($availableAt !== null) {
                throw ValidationException::withMessages([
                    'username' => [Message::get('identity::messages.username_cooldown', [
                        'date' => $availableAt->format('Y-m-d'),
                    ])],
                ]);
            }

            // Changes during onboarding are free and don't start the cooldown.
            if ($profile->setup_completed_at !== null) {
                $profile->username_changed_at = CarbonImmutable::now();
            }
        }

        $profile->username = $username; // case-only changes are always allowed
    }
}
