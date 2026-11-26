<?php

declare(strict_types=1);

namespace App\Modules\Identity\Services;

use Carbon\CarbonImmutable;
use Illuminate\Database\Query\Builder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Follows and blocks between anonymous profiles (FR-COM-006 / FR-COM-009 / BR-008).
 * This is the public API other modules use to respect blocking. Never touch the
 * tables directly from outside Identity.
 *
 * Blocking is symmetric for content: if either profile blocked the other, each is
 * "hidden" from the other everywhere (feeds, comments, search, profiles, follows).
 *
 * Registered as a scoped (per-request) service so the hidden-id list is computed once.
 */
final class SocialGraph
{
    /** @var array<string, list<string>> */
    private array $hiddenCache = [];

    /**
     * Subquery of profile ids hidden from the viewer (blocked by them or blocking them),
     * for `whereNotIn($column, ...)`. Selects a single `profile_id` column.
     */
    public function hiddenProfileIdsQuery(string $viewerProfileId): Builder
    {
        return DB::table('profile_blocks')
            ->select('blocked_profile_id as profile_id')
            ->where('blocker_profile_id', $viewerProfileId)
            ->union(
                DB::table('profile_blocks')
                    ->select('blocker_profile_id as profile_id')
                    ->where('blocked_profile_id', $viewerProfileId),
            );
    }

    /**
     * @return list<string>
     */
    public function hiddenProfileIds(string $viewerProfileId): array
    {
        if (! isset($this->hiddenCache[$viewerProfileId])) {
            /** @var list<string> $ids */
            $ids = $this->hiddenProfileIdsQuery($viewerProfileId)->pluck('profile_id')->all();
            $this->hiddenCache[$viewerProfileId] = $ids;
        }

        return $this->hiddenCache[$viewerProfileId];
    }

    public function isHidden(string $viewerProfileId, string $otherProfileId): bool
    {
        return in_array($otherProfileId, $this->hiddenProfileIds($viewerProfileId), true);
    }

    public function hasBlocked(string $blockerProfileId, string $blockedProfileId): bool
    {
        return DB::table('profile_blocks')
            ->where('blocker_profile_id', $blockerProfileId)
            ->where('blocked_profile_id', $blockedProfileId)
            ->exists();
    }

    /**
     * Subquery of profile ids the viewer follows (selects `followed_profile_id`).
     */
    public function followedProfileIdsQuery(string $followerProfileId): Builder
    {
        return DB::table('profile_follows')
            ->select('followed_profile_id')
            ->where('follower_profile_id', $followerProfileId);
    }

    public function isFollowing(string $followerProfileId, string $followedProfileId): bool
    {
        return DB::table('profile_follows')
            ->where('follower_profile_id', $followerProfileId)
            ->where('followed_profile_id', $followedProfileId)
            ->exists();
    }

    /**
     * @return array{followers: int, following: int}
     */
    public function counts(string $profileId): array
    {
        return [
            'followers' => DB::table('profile_follows')->where('followed_profile_id', $profileId)->count(),
            'following' => DB::table('profile_follows')->where('follower_profile_id', $profileId)->count(),
        ];
    }

    /**
     * @return bool true if this created a new follow
     */
    public function follow(string $followerProfileId, string $followedProfileId): bool
    {
        return DB::table('profile_follows')->insertOrIgnore([
            'id' => (string) Str::uuid7(),
            'follower_profile_id' => $followerProfileId,
            'followed_profile_id' => $followedProfileId,
            'created_at' => CarbonImmutable::now(),
        ]) > 0;
    }

    public function unfollow(string $followerProfileId, string $followedProfileId): void
    {
        DB::table('profile_follows')
            ->where('follower_profile_id', $followerProfileId)
            ->where('followed_profile_id', $followedProfileId)
            ->delete();
    }

    /**
     * Blocks and removes any follow relationship in both directions (FR-COM-009).
     */
    public function block(string $blockerProfileId, string $blockedProfileId): void
    {
        DB::transaction(function () use ($blockerProfileId, $blockedProfileId): void {
            DB::table('profile_blocks')->insertOrIgnore([
                'id' => (string) Str::uuid7(),
                'blocker_profile_id' => $blockerProfileId,
                'blocked_profile_id' => $blockedProfileId,
                'created_at' => CarbonImmutable::now(),
            ]);

            DB::table('profile_follows')
                ->where(fn (Builder $q) => $q->where('follower_profile_id', $blockerProfileId)->where('followed_profile_id', $blockedProfileId))
                ->orWhere(fn (Builder $q) => $q->where('follower_profile_id', $blockedProfileId)->where('followed_profile_id', $blockerProfileId))
                ->delete();
        });

        unset($this->hiddenCache[$blockerProfileId], $this->hiddenCache[$blockedProfileId]);
    }

    public function unblock(string $blockerProfileId, string $blockedProfileId): void
    {
        DB::table('profile_blocks')
            ->where('blocker_profile_id', $blockerProfileId)
            ->where('blocked_profile_id', $blockedProfileId)
            ->delete();

        unset($this->hiddenCache[$blockerProfileId], $this->hiddenCache[$blockedProfileId]);
    }
}
