<?php

declare(strict_types=1);

namespace App\Modules\Identity\Http\Controllers;

use App\Modules\Identity\Enums\FollowPolicy;
use App\Modules\Identity\Enums\ProfileVisibility;
use App\Modules\Identity\Http\Resources\PublicProfileResource;
use App\Modules\Identity\Models\AnonymousProfile;
use App\Modules\Identity\Models\UserPrivacySetting;
use App\Modules\Identity\Services\SocialGraph;
use App\Modules\Identity\Support\CurrentProfile;
use App\Support\Http\ApiResponse;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * Another member's public profile, looked up by username (case-insensitive).
 * Suspended / deactivated accounts are 404, exactly like unknown usernames — and so is
 * a member who blocked the viewer (FR-COM-009). A member the viewer blocked stays
 * reachable (so they can unblock) but shows no bio.
 */
final class ShowPublicProfileController
{
    public function __invoke(Request $request, string $username, CurrentProfile $current, SocialGraph $graph): JsonResponse
    {
        $viewer = $current->require($request->user());
        $profile = AnonymousProfile::query()->active()->withUsername($username)->firstOrFail();

        $isSelf = $viewer->id === $profile->id;
        abort_if(! $isSelf && $graph->hasBlocked($profile->id, $viewer->id), 404);

        $privacy = UserPrivacySetting::query()->where('user_id', $profile->user_id)->first();
        $blockedByMe = ! $isSelf && $graph->hasBlocked($viewer->id, $profile->id);
        $isFollowing = ! $isSelf && $graph->isFollowing($viewer->id, $profile->id);

        return ApiResponse::success(new PublicProfileResource(
            $profile,
            $blockedByMe ? ProfileVisibility::Private : ($privacy->profile_visibility ?? ProfileVisibility::Public),
            $graph->counts($profile->id),
            [
                'is_self' => $isSelf,
                'is_following' => $isFollowing,
                'follows_you' => ! $isSelf && $graph->isFollowing($profile->id, $viewer->id),
                'is_blocked' => $blockedByMe,
                'can_follow' => ! $isSelf && ! $blockedByMe && ! $isFollowing
                    && ($privacy->follow_policy ?? FollowPolicy::Everyone) === FollowPolicy::Everyone,
            ],
        ));
    }
}
