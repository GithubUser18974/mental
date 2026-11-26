<?php

declare(strict_types=1);

namespace App\Modules\Identity\Actions;

use App\Modules\Identity\Models\AnonymousProfile;
use App\Modules\Identity\Services\SocialGraph;
use Illuminate\Contracts\Pagination\CursorPaginator;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Facades\DB;

/**
 * The signed-in member's own followers / following / blocked lists, newest first.
 * Followers & following skip inactive accounts and anyone hidden by a block.
 */
final readonly class ListConnections
{
    public const int MAX_PER_PAGE = 50;

    public function __construct(private SocialGraph $graph) {}

    /**
     * @return CursorPaginator<int, AnonymousProfile>
     */
    public function followers(string $me, int $perPage): CursorPaginator
    {
        return $this->paginate($this->linked($me, 'followed_profile_id', 'follower_profile_id'), $perPage);
    }

    /**
     * @return CursorPaginator<int, AnonymousProfile>
     */
    public function following(string $me, int $perPage): CursorPaginator
    {
        return $this->paginate($this->linked($me, 'follower_profile_id', 'followed_profile_id'), $perPage);
    }

    /**
     * Everyone I blocked (so I can unblock them), active accounts only.
     *
     * @return CursorPaginator<int, AnonymousProfile>
     */
    public function blocked(string $me, int $perPage): CursorPaginator
    {
        $query = AnonymousProfile::query()
            ->active()
            ->join('profile_blocks', 'profile_blocks.blocked_profile_id', '=', 'anonymous_profiles.id')
            ->where('profile_blocks.blocker_profile_id', $me)
            ->select('anonymous_profiles.*', 'profile_blocks.created_at as linked_at', 'profile_blocks.id as link_id');

        return $this->paginate($query, $perPage);
    }

    /**
     * @return Builder<AnonymousProfile>
     */
    private function linked(string $me, string $myColumn, string $theirColumn): Builder
    {
        $mine = $myColumn === 'followed_profile_id' ? 'profile_follows.followed_profile_id' : 'profile_follows.follower_profile_id';

        return AnonymousProfile::query()
            ->active()
            ->join('profile_follows', 'profile_follows.'.$theirColumn, '=', 'anonymous_profiles.id')
            ->where($mine, $me)
            ->whereNotIn('anonymous_profiles.id', $this->graph->hiddenProfileIdsQuery($me))
            ->select('anonymous_profiles.*', 'profile_follows.created_at as linked_at', 'profile_follows.id as link_id')
            ->addSelect([
                // Whether I follow them (for the follow-back button).
                'viewer_follows' => DB::table('profile_follows as vf')
                    ->selectRaw('1')
                    ->whereColumn('vf.followed_profile_id', 'anonymous_profiles.id')
                    ->where('vf.follower_profile_id', $me)
                    ->limit(1),
            ]);
    }

    /**
     * @param  Builder<AnonymousProfile>  $query
     * @return CursorPaginator<int, AnonymousProfile>
     */
    private function paginate(Builder $query, int $perPage): CursorPaginator
    {
        return $query
            ->orderByDesc('linked_at')
            ->orderByDesc('link_id')
            ->cursorPaginate(max(1, min(self::MAX_PER_PAGE, $perPage)));
    }
}
