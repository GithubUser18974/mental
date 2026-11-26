<?php

declare(strict_types=1);

namespace App\Modules\Auth;

use App\Modules\Auth\Http\Middleware\EnsureAccountIsActive;
use App\Modules\Auth\Models\PersonalAccessToken;
use App\Support\Modules\ModuleServiceProvider as BaseModuleServiceProvider;
use Illuminate\Routing\Router;
use Illuminate\Validation\Rules\Password;
use Laravel\Sanctum\Sanctum;

/**
 * Authentication: accounts, credentials, tokens, password recovery (FR-AUTH-001/003).
 */
final class ModuleServiceProvider extends BaseModuleServiceProvider
{
    public function boot(): void
    {
        Sanctum::usePersonalAccessTokenModel(PersonalAccessToken::class);

        $this->app->make(Router::class)->aliasMiddleware(EnsureAccountIsActive::ALIAS, EnsureAccountIsActive::class);

        // Password policy. Breached-password check (k-anonymity API) only in production,
        // so tests and local dev never call out to the network.
        Password::defaults(fn (): Password => $this->app->isProduction()
            ? Password::min(10)->letters()->numbers()->uncompromised()
            : Password::min(10)->letters()->numbers());

        parent::boot();
    }
}
