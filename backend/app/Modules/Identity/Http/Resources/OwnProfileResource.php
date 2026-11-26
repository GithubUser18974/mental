<?php

declare(strict_types=1);

namespace App\Modules\Identity\Http\Resources;

use App\Modules\Identity\DTOs\OwnIdentity;
use App\Support\Time\Iso8601;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * The owner's view of their identity and settings. Contains no account credentials
 * (email etc. live only in /auth/me).
 *
 * @property OwnIdentity $resource
 */
final class OwnProfileResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $profile = $this->resource->profile;
        $preferences = $this->resource->preferences;
        $privacy = $this->resource->privacy;

        return [
            'profile' => [
                'id' => $profile->id,
                'username' => $profile->username,
                'avatar' => $profile->avatar,
                'bio' => $profile->bio,
                'setup_completed' => $profile->setup_completed_at !== null,
                'username_change_available_at' => Iso8601::format($profile->usernameChangeAvailableAt()),
                'joined_on' => $profile->created_at->format('Y-m-d'),
            ],
            'preferences' => [
                'language' => $preferences->language,
                'timezone' => $preferences->timezone,
            ],
            'privacy' => [
                'profile_visibility' => $privacy->profile_visibility->value,
                'follow_policy' => $privacy->follow_policy->value,
                'analytics_consent' => $privacy->analytics_consent,
            ],
        ];
    }
}
