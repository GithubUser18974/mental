<?php

declare(strict_types=1);

namespace App\Modules\Community;

use App\Modules\Community\Console\PruneOrphanMedia;
use App\Modules\Community\Models\Comment;
use App\Modules\Community\Models\Post;
use App\Modules\Community\Policies\CommentPolicy;
use App\Modules\Community\Policies\PostPolicy;
use App\Support\Modules\ModuleServiceProvider as BaseModuleServiceProvider;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\Facades\Route;

/**
 * Community: categories, interests, posts, hashtags, media, feed, comments, reactions,
 * saved posts (FR-COM-001..005, 007).
 * Must never depend on Tracking, Medication or Journal (privacy boundary, arch-tested).
 */
final class ModuleServiceProvider extends BaseModuleServiceProvider
{
    private const string UUID_PATTERN = '[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}';

    public function boot(): void
    {
        Gate::policy(Post::class, PostPolicy::class);
        Gate::policy(Comment::class, CommentPolicy::class);

        // Malformed ids are a plain 404, never a database error.
        Route::pattern('post', self::UUID_PATTERN);
        Route::pattern('comment', self::UUID_PATTERN);

        if ($this->app->runningInConsole()) {
            $this->commands([PruneOrphanMedia::class]);
        }

        parent::boot();
    }
}
