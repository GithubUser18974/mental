<?php

declare(strict_types=1);

namespace App\Modules\Community\Services;

use App\Modules\Auth\Models\User;
use App\Modules\Community\Models\Comment;
use App\Modules\Community\Models\Post;
use App\Modules\Identity\Services\SocialGraph;
use App\Modules\Identity\Support\CurrentProfile;
use Illuminate\Support\Facades\Gate;

/**
 * Public API for other modules (e.g. Moderation reports) to resolve community content
 * the way the given member sees it. Returns the author's anonymous profile id, or null
 * when the content doesn't exist for this member (deleted, hidden, private, blocked).
 */
final readonly class ContentLookup
{
    public function __construct(private CurrentProfile $current, private SocialGraph $graph) {}

    public function visiblePostAuthor(User $viewer, string $postId): ?string
    {
        $post = Post::query()->find($postId);

        return $post instanceof Post && Gate::forUser($viewer)->allows('view', $post) ? $post->author_profile_id : null;
    }

    public function visibleCommentAuthor(User $viewer, string $commentId): ?string
    {
        $comment = Comment::query()->find($commentId);
        $profile = $this->current->for($viewer);
        if (! $comment instanceof Comment || $profile === null) {
            return null;
        }

        $post = $comment->post()->first();
        $visible = $post instanceof Post
            && Gate::forUser($viewer)->allows('view', $post)
            && $comment->isVisibleTo($profile->id, $this->graph->hiddenProfileIds($profile->id));

        return $visible ? $comment->author_profile_id : null;
    }
}
