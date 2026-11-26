<?php

declare(strict_types=1);

namespace App\Modules\Identity\Actions;

use App\Modules\Identity\Enums\FollowPolicy;
use App\Modules\Identity\Events\ProfileFollowed;
use App\Modules\Identity\Models\AnonymousProfile;
use App\Modules\Identity\Models\UserPrivacySetting;
use App\Modules\Identity\Services\SocialGraph;
use App\Support\Exceptions\ApiException;
use App\Support\Translation\Message;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Validation\ValidationException;

/**
 * Follow / unfollow / block / unblock with the business rules (FR-COM-006, FR-COM-009,
 * FR-ONB-003 follow permissions). All operations are idempotent.
 */
final readonly class ManageConnection
{
    public function __construct(private SocialGraph $graph) {}

    public function follow(AnonymousProfile $follower, AnonymousProfile $target): void
    {
        $this->rejectSelf($follower, $target, 'cannot_follow_self');

        // Blocked either way: the target doesn't exist for this member.
        if ($this->graph->isHidden($follower->id, $target->id)) {
            throw (new ModelNotFoundException)->setModel(AnonymousProfile::class);
        }

        if ($this->graph->isFollowing($follower->id, $target->id)) {
            return;
        }

        $privacy = UserPrivacySetting::query()->where('user_id', $target->user_id)->first();
        if ($privacy?->follow_policy === FollowPolicy::Nobody) {
            throw new ApiException(Message::get('identity::messages.not_accepting_followers'), 403);
        }

        if ($this->graph->follow($follower->id, $target->id)) {
            ProfileFollowed::dispatch($target->id, $follower->id);
        }
    }

    public function unfollow(AnonymousProfile $follower, AnonymousProfile $target): void
    {
        $this->graph->unfollow($follower->id, $target->id);
    }

    /**
     * Always succeeds silently, even if the target already blocked the blocker — the
     * response never reveals the other side's blocks.
     */
    public function block(AnonymousProfile $blocker, AnonymousProfile $target): void
    {
        $this->rejectSelf($blocker, $target, 'cannot_block_self');
        $this->graph->block($blocker->id, $target->id);
    }

    public function unblock(AnonymousProfile $blocker, AnonymousProfile $target): void
    {
        $this->graph->unblock($blocker->id, $target->id);
    }

    private function rejectSelf(AnonymousProfile $actor, AnonymousProfile $target, string $messageKey): void
    {
        if ($actor->id === $target->id) {
            throw ValidationException::withMessages([
                'profile' => [Message::get('identity::messages.'.$messageKey)],
            ]);
        }
    }
}
