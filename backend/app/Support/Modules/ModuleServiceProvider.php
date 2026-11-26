<?php

declare(strict_types=1);

namespace App\Support\Modules;

use Illuminate\Support\Facades\Route;
use Illuminate\Support\ServiceProvider;
use ReflectionClass;

/**
 * Base provider for every module in app/Modules/<Name>/.
 *
 * Conventions loaded automatically when present:
 *   Routes/api.php        → mounted at /api/v1 with the `api` middleware group
 *   Database/Migrations/  → registered with the migrator
 *   Lang/                 → translations under the `<name>` namespace, e.g. __('community::posts.created')
 */
abstract class ModuleServiceProvider extends ServiceProvider
{
    public function boot(): void
    {
        $path = $this->modulePath();

        if (is_file($path.'/Routes/api.php') && ! $this->app->routesAreCached()) {
            Route::middleware('api')
                ->prefix('api/v1')
                ->name('api.v1.')
                ->group($path.'/Routes/api.php');
        }

        if (is_dir($path.'/Database/Migrations')) {
            $this->loadMigrationsFrom($path.'/Database/Migrations');
        }

        if (is_dir($path.'/Lang')) {
            $this->loadTranslationsFrom($path.'/Lang', $this->moduleKey());
        }
    }

    protected function modulePath(): string
    {
        return dirname((string) (new ReflectionClass($this))->getFileName());
    }

    protected function moduleKey(): string
    {
        return strtolower(basename($this->modulePath()));
    }
}
