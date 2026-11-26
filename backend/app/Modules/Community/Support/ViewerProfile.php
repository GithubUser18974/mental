<?php

declare(strict_types=1);

namespace App\Modules\Community\Support;

use App\Modules\Identity\Models\AnonymousProfile;
use App\Modules\Identity\Services\SocialGraph;
use App\Modules\Identity\Support\CurrentProfile;
use Illuminate\Contracts\Auth\Authenticatable;

/**
 * Maps the authenticated account to its anonymous profile — the only identity the
 * community module works with — and exposes who is hidden from the viewer by blocks.
 */
final readonly class ViewerProfile
{
    public function __construct(private CurrentProfile $current, private SocialGraph $graph) {}

    public function for(?Authenticatable $user): ?AnonymousProfile
    {
        return $this->current->for($user);
    }

    public function require(?Authenticatable $user): AnonymousProfile
    {
        return $this->current->require($user);
    }

    /**
     * Whether either profile blocked the other (FR-COM-009).
     */
    public function isHiddenFrom(?Authenticatable $user, string $otherProfileId): bool
    {
        $viewer = $this->for($user);

        return $viewer !== null && $this->graph->isHidden($viewer->id, $otherProfileId);
    }
}
