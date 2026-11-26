<?php

declare(strict_types=1);

namespace App\Modules\Identity\Http\Controllers;

use App\Modules\Identity\Http\Requests\SearchProfilesRequest;
use App\Modules\Identity\Http\Resources\ProfileCardResource;
use App\Modules\Identity\Models\AnonymousProfile;
use App\Modules\Identity\Services\SocialGraph;
use App\Modules\Identity\Support\CurrentProfile;
use App\Support\Database\LikePattern;
use App\Support\Http\ApiResponse;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

/**
 * GET /search/profiles?q= — find members by anonymous username (FR-COM-008). Active
 * accounts only, never anyone hidden by a block either way, prefix matches first.
 * Bounded result list (no pagination); usernames are the only searchable field.
 */
final class SearchProfilesController
{
    public const int LIMIT = 20;

    public function __invoke(SearchProfilesRequest $request, CurrentProfile $current, SocialGraph $graph): JsonResponse
    {
        $me = $current->require($request->user())->id;
        $needle = mb_strtolower($request->text());

        $profiles = AnonymousProfile::query()
            ->active()
            ->whereRaw('lower(username) like ?', [LikePattern::contains($needle)])
            ->whereNotIn('anonymous_profiles.id', $graph->hiddenProfileIdsQuery($me))
            ->select('anonymous_profiles.*')
            ->addSelect([
                'viewer_follows' => DB::table('profile_follows as vf')
                    ->selectRaw('1')
                    ->whereColumn('vf.followed_profile_id', 'anonymous_profiles.id')
                    ->where('vf.follower_profile_id', $me)
                    ->limit(1),
            ])
            ->orderByRaw('CASE WHEN lower(username) LIKE ? THEN 0 ELSE 1 END', [LikePattern::startsWith($needle)])
            ->orderByRaw('lower(username)')
            ->limit(self::LIMIT)
            ->get();

        return ApiResponse::success(ProfileCardResource::collection($profiles));
    }
}
