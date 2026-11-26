<?php

declare(strict_types=1);

namespace App\Providers;

use App\Support\Modules\ModuleServiceProvider;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Str;

/**
 * Discovers and registers every module: app/Modules/<Name>/ModuleServiceProvider.php.
 */
final class ModulesServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        foreach (glob(app_path('Modules/*/ModuleServiceProvider.php')) ?: [] as $file) {
            $class = 'App\\Modules\\'.basename(dirname($file)).'\\ModuleServiceProvider';

            if (is_subclass_of($class, ModuleServiceProvider::class)) {
                $this->app->register($class);
            }
        }
    }

    public function boot(): void
    {
        // App\Modules\X\Models\Post → App\Modules\X\Database\Factories\PostFactory
        Factory::guessFactoryNamesUsing(static function (string $model): string {
            if (Str::startsWith($model, 'App\\Modules\\')) {
                /** @var class-string<Factory<\Illuminate\Database\Eloquent\Model>> */
                return Str::replaceLast('\\Models\\', '\\Database\\Factories\\', $model).'Factory';
            }

            /** @var class-string<Factory<\Illuminate\Database\Eloquent\Model>> */
            return 'Database\\Factories\\'.Str::after($model, 'App\\Models\\').'Factory';
        });
    }
}
