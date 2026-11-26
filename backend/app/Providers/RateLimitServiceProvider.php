<?php

declare(strict_types=1);

namespace App\Providers;

use Illuminate\Cache\RateLimiting\Limit;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\ServiceProvider;

/**
 * Named rate limiters. Apply with `->middleware('throttle:<name>')`.
 * `api` is applied to every API route automatically.
 */
final class RateLimitServiceProvider extends ServiceProvider
{
    public function boot(): void
    {
        // Default for all API routes.
        RateLimiter::for('api', static fn (Request $request): Limit => Limit::perMinute(120)
            ->by(self::actor($request)));

        // Login / register / OTP: per account identifier + IP, and per IP overall (brute-force protection).
        RateLimiter::for('auth', static fn (Request $request): array => [
            Limit::perMinute(5)->by('auth:'.self::identifier($request).'|'.$request->ip()),
            Limit::perMinute(20)->by('auth-ip:'.$request->ip()),
        ]);

        // Password reset requests: avoid email flooding.
        RateLimiter::for('password-reset', static fn (Request $request): array => [
            Limit::perMinutes(15, 3)->by('reset:'.self::identifier($request)),
            Limit::perMinutes(15, 10)->by('reset-ip:'.$request->ip()),
        ]);

        // Creating community content (posts, comments).
        RateLimiter::for('writes', static fn (Request $request): Limit => Limit::perMinute(20)
            ->by('writes:'.self::actor($request)));

        // Search-as-you-type, but not enough to scrape usernames.
        RateLimiter::for('search', static fn (Request $request): Limit => Limit::perMinute(60)
            ->by('search:'.self::actor($request)));

        // Quick toggles: reactions, bookmarks, follows and blocks.
        RateLimiter::for('reactions', static fn (Request $request): Limit => Limit::perMinute(60)
            ->by('reactions:'.self::actor($request)));

        // Content reports.
        RateLimiter::for('reports', static fn (Request $request): Limit => Limit::perHour(20)
            ->by('reports:'.self::actor($request)));

        // Media uploads.
        RateLimiter::for('uploads', static fn (Request $request): Limit => Limit::perMinute(10)
            ->by('uploads:'.self::actor($request)));
    }

    private static function actor(Request $request): string
    {
        $id = $request->user()?->getAuthIdentifier();

        return is_scalar($id) ? 'user:'.$id : 'ip:'.$request->ip();
    }

    /** Hashed so raw emails/phones never land in cache keys. */
    private static function identifier(Request $request): string
    {
        $value = $request->input('email') ?? $request->input('phone') ?? '';

        return hash('sha256', mb_strtolower(trim(is_string($value) ? $value : '')));
    }
}
