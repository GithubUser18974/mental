<?php

declare(strict_types=1);

namespace App\Modules\Community\Events;

use Illuminate\Foundation\Events\Dispatchable;

/**
 * A member commented on someone else's post, or replied to someone else's comment. The
 * Notifications module (Phase 7) listens. Carries ids only, no content.
 */
final readonly class CommentCreated
{
    use Dispatchable;

    /**
     * @param  list<string>  $recipientProfileIds  post author and/or parent comment author (never the commenter)
     */
    public function __construct(
        public string $commentId,
        public string $postId,
        public array $recipientProfileIds,
    ) {}
}
