<?php

declare(strict_types=1);

namespace App\Modules\Identity\Models;

use App\Modules\Identity\Enums\FollowPolicy;
use App\Modules\Identity\Enums\ProfileVisibility;
use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;

/**
 * Privacy preferences (FR-ONB-003). Defaults are the most private reasonable choice for
 * optional processing (analytics off). Health data is private regardless of these settings.
 *
 * @property string $id
 * @property string $user_id
 * @property ProfileVisibility $profile_visibility
 * @property FollowPolicy $follow_policy
 * @property bool $analytics_consent
 * @property CarbonImmutable $created_at
 * @property CarbonImmutable $updated_at
 */
#[Fillable(['user_id', 'profile_visibility', 'follow_policy', 'analytics_consent'])]
class UserPrivacySetting extends Model
{
    use HasUuids;

    /** @var array<string, mixed> */
    protected $attributes = [
        'profile_visibility' => 'public',
        'follow_policy' => 'everyone',
        'analytics_consent' => false,
    ];

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'profile_visibility' => ProfileVisibility::class,
            'follow_policy' => FollowPolicy::class,
            'analytics_consent' => 'boolean',
        ];
    }
}
