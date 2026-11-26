<?php

declare(strict_types=1);

namespace App\Providers;

use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Date;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\ServiceProvider;

final class AppServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        //
    }

    public function boot(): void
    {
        $isProduction = $this->app->isProduction();

        // Lazy loading, silently discarded attributes and missing attributes throw outside production.
        Model::shouldBeStrict(! $isProduction);

        // Never allow `migrate:fresh`, `db:wipe`, etc. against production.
        DB::prohibitDestructiveCommands($isProduction);

        Date::use(CarbonImmutable::class);

    }
}
