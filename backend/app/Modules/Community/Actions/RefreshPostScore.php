<?php

declare(strict_types=1);

namespace App\Modules\Community\Actions;

use App\Modules\Community\Enums\ModerationStatus;
use Illuminate\Support\Facades\DB;

/**
 * Recomputes a post's engagement score for the "popular" feed from the source rows, so
 * it can never drift: reactions count 1, visible comments count 2. The author's own
 * reactions and comments don't count — members can't boost their own posts.
 */
final class RefreshPostScore
{
    public const int REACTION_WEIGHT = 1;

    public const int COMMENT_WEIGHT = 2;

    public function __invoke(string $postId): void
    {
        DB::update(
            <<<'SQL'
                UPDATE posts p SET score =
                    ? * (SELECT count(*) FROM post_reactions r
                         WHERE r.post_id = p.id AND r.profile_id <> p.author_profile_id)
                  + ? * (SELECT count(*) FROM comments c
                         WHERE c.post_id = p.id AND c.author_profile_id <> p.author_profile_id
                           AND c.deleted_at IS NULL AND c.moderation_status = ?)
                WHERE p.id = ?
                SQL,
            [self::REACTION_WEIGHT, self::COMMENT_WEIGHT, ModerationStatus::Visible->value, $postId],
        );
    }
}
