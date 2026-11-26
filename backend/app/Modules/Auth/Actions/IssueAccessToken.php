<?php

declare(strict_types=1);

namespace App\Modules\Auth\Actions;

use App\Modules\Auth\DTOs\IssuedToken;
use App\Modules\Auth\Models\User;
use Carbon\CarbonImmutable;

/**
 * Issues an expiring Sanctum token (FR-AUTH-003 session expiration).
 */
final class IssueAccessToken
{
    public const string DEFAULT_DEVICE_NAME = 'mobile';

    public function __invoke(User $user, ?string $deviceName = null): IssuedToken
    {
        $minutes = config('sanctum.expiration');
        $expiresAt = CarbonImmutable::now()->addMinutes(is_numeric($minutes) ? (int) $minutes : 43200);

        $token = $user->createToken($this->deviceName($deviceName), ['*'], $expiresAt);

        return new IssuedToken($user, $token->plainTextToken, $expiresAt);
    }

    private function deviceName(?string $name): string
    {
        $name = trim((string) preg_replace('/[^\pL\pN \-_.()]/u', '', (string) $name));

        return $name === '' ? self::DEFAULT_DEVICE_NAME : mb_substr($name, 0, 100);
    }
}
