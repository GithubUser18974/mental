<?php

declare(strict_types=1);

namespace App\Modules\Identity;

use App\Modules\Auth\Events\UserRegistered;
use App\Modules\Identity\Listeners\CreateIdentityForNewUser;
use App\Modules\Identity\Models\AnonymousProfile;
use App\Modules\Identity\Services\SocialGraph;
use App\Modules\Identity\Support\CurrentProfile;
use App\Support\Modules\ModuleServiceProvider as BaseModuleServiceProvider;
use Illuminate\Cache\RateLimiting\Limit;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\Facades\Route;

/**
 * Anonymous public identity, preferences, privacy settings and the social graph
 * (follows / blocks) — FR-AUTH-002, FR-ONB-002/003, FR-PRO-*, FR-COM-006/009.
 */
final class ModuleServiceProvider extends BaseModuleServiceProvider
{
    public function register(): void
    {
        parent::register();

        // Per-request caches (viewer profile, hidden-by-block ids).
        $this->app->scoped(CurrentProfile::class);
        $this->app->scoped(SocialGraph::class);
    }

    public function boot(): void
    {
        Event::listen(UserRegistered::class, CreateIdentityForNewUser::class);

        // Typing-speed lookups during onboarding, but not enough to scrape usernames.
        RateLimiter::for('username-checks', static fn (Request $request): Limit => Limit::perMinute(30)
            ->by('username-checks:'.($request->user()?->getAuthIdentifier() ?? $request->ip())));

        // `{profile}` = anonymous profile id of an ACTIVE account; anything else is a 404.
        Route::pattern('profile', '[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}');
        Route::bind('profile', static fn (string $id): AnonymousProfile => AnonymousProfile::query()->active()->findOrFail($id));

        parent::boot();
    }
}
