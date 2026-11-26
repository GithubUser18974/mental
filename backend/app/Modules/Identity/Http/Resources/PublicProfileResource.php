<?php

declare(strict_types=1);

namespace App\Modules\Identity\Http\Resources;

use App\Modules\Identity\Enums\ProfileVisibility;
use App\Modules\Identity\Models\AnonymousProfile;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * What OTHER members can see (FR-PRO-001/003). Explicit whitelist: never add user_id,
 * email, phone, account status or any health-related data here (FR-PRO-002).
 *
 * @property AnonymousProfile $resource
 */
final class PublicProfileResource extends JsonResource
{
    /**
     * @param  array{followers: int, following: int}  $counts
     * @param  array{is_self: bool, is_following: bool, follows_you: bool, is_blocked: bool, can_follow: bool}  $relationship
     */
    public function __construct(
        AnonymousProfile $profile,
        private readonly ProfileVisibility $visibility,
        private readonly array $counts,
        private readonly array $relationship,
    ) {
        parent::__construct($profile);
    }

    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $profile = $this->resource;
        $isPrivate = $this->visibility === ProfileVisibility::Private;

        return [
            'id' => $profile->id,
            'username' => $profile->username,
            'avatar' => $profile->avatar,
            'bio' => $isPrivate ? null : $profile->bio,
            'is_private' => $isPrivate,
            'joined_on' => $profile->created_at->format('Y-m-d'),
            'stats' => [
                'followers' => $this->counts['followers'],
                'following' => $this->counts['following'],
            ],
            'relationship' => $this->relationship,
        ];
    }
}
