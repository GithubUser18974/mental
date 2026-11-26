<?php

declare(strict_types=1);

namespace App\Modules\Identity\Http\Resources;

use App\Modules\Identity\Models\AnonymousProfile;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * Compact public profile for lists (followers, following, blocked, search results).
 * Anonymous identity only. `is_following` appears when the list query computed it.
 *
 * @property AnonymousProfile $resource
 */
final class ProfileCardResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $profile = $this->resource;
        $hasFollowFlag = array_key_exists('viewer_follows', $profile->getAttributes());

        return [
            'id' => $profile->id,
            'username' => $profile->username,
            'avatar' => $profile->avatar,
            'is_following' => $this->when($hasFollowFlag, fn (): bool => $profile->getAttribute('viewer_follows') !== null),
        ];
    }
}
