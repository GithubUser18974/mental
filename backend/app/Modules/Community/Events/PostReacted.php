<?php

declare(strict_types=1);

namespace App\Modules\Community\Events;

use App\Modules\Community\Enums\ReactionType;
use Illuminate\Foundation\Events\Dispatchable;

/**
 * Someone added a reaction to another member's post. The Notifications module (Phase 7)
 * listens to tell the author ("Someone understood your story"). Carries ids only, and
 * never the reacting member's identity.
 */
final readonly class PostReacted
{
    use Dispatchable;

    public function __construct(
        public string $postId,
        public string $postAuthorProfileId,
        public ReactionType $type,
    ) {}
}
