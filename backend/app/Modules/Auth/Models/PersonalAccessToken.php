<?php

declare(strict_types=1);

namespace App\Modules\Auth\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Laravel\Sanctum\PersonalAccessToken as SanctumPersonalAccessToken;

/**
 * Sanctum token model using UUID primary keys (project rule: no auto-increment ids).
 *
 * @property string $id
 * @property string $name
 * @property \Carbon\CarbonImmutable|null $expires_at
 * @property \Carbon\CarbonImmutable|null $last_used_at
 *
 * Not final: Sanctum::actingAs() mocks this class in tests.
 */
class PersonalAccessToken extends SanctumPersonalAccessToken
{
    use HasUuids;
}
