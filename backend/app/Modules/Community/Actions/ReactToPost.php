<?php

declare(strict_types=1);

namespace App\Modules\Community\Actions;

use App\Modules\Community\Enums\ReactionType;
use App\Modules\Community\Events\PostReacted;
use App\Modules\Community\Models\Post;
use App\Modules\Community\Models\PostReaction;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Sets or removes the viewer's single supportive reaction on a post (FR-COM-005).
 * Choosing a different type replaces the previous one.
 */
final readonly class ReactToPost
{
    public function __construct(private RefreshPostScore $refreshScore) {}

    public function set(Post $post, string $profileId, ReactionType $type): void
    {
        $isNew = DB::transaction(function () use ($post, $profileId, $type): bool {
            $isNew = ! PostReaction::query()
                ->where('post_id', $post->id)
                ->where('profile_id', $profileId)
                ->exists();

            $now = CarbonImmutable::now();
            // Upsert on the unique (post, profile) pair — safe against double taps.
            PostReaction::query()->upsert(
                [[
                    'id' => (string) Str::uuid7(),
                    'post_id' => $post->id,
                    'profile_id' => $profileId,
                    'type' => $type->value,
                    'created_at' => $now,
                    'updated_at' => $now,
                ]],
                ['post_id', 'profile_id'],
                ['type', 'updated_at'],
            );

            ($this->refreshScore)($post->id);

            return $isNew;
        });

        if ($isNew && ! $post->isAuthoredBy($profileId)) {
            PostReacted::dispatch($post->id, $post->author_profile_id, $type);
        }
    }

    public function remove(Post $post, string $profileId): void
    {
        DB::transaction(function () use ($post, $profileId): void {
            $deleted = PostReaction::query()
                ->where('post_id', $post->id)
                ->where('profile_id', $profileId)
                ->delete();

            if ($deleted > 0) {
                ($this->refreshScore)($post->id);
            }
        });
    }

    /**
     * Fresh counts for the response after a change.
     *
     * @return array{counts: array<string, int>, total: int, mine: string|null}
     */
    public function summary(Post $post, string $profileId): array
    {
        $fresh = Post::query()->withEngagement($profileId)->findOrFail($post->id);
        $counts = $fresh->reactionCounts();

        return ['counts' => $counts, 'total' => array_sum($counts), 'mine' => $fresh->viewerReaction()?->value];
    }
}
