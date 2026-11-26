<?php

declare(strict_types=1);

arch('all application code declares strict types')
    ->expect('App')
    ->toUseStrictTypes();

arch('no debugging helpers are left in application code')
    ->expect(['dd', 'dump', 'ray', 'var_dump', 'print_r', 'die'])
    ->not->toBeUsed();

arch('env() is only read inside config files')
    ->expect('env')
    ->not->toBeUsedIn('App');

arch('privacy boundary: community-facing modules never depend on private health modules')
    ->expect(['App\Modules\Community', 'App\Modules\Moderation', 'App\Modules\Identity'])
    ->not->toUse(['App\Modules\Tracking', 'App\Modules\Medication', 'App\Modules\Journal']);

arch('support layer does not depend on modules')
    ->expect('App\Support')
    ->not->toUse('App\Modules');

foreach (glob(dirname(__DIR__, 2).'/app/Modules/*', GLOB_ONLYDIR) ?: [] as $moduleDir) {
    $module = basename($moduleDir);

    arch("{$module}: controllers are final and suffixed")
        ->expect("App\\Modules\\{$module}\\Http\\Controllers")
        ->classes()
        ->toBeFinal()
        ->toHaveSuffix('Controller');

    arch("{$module}: form requests extend FormRequest")
        ->expect("App\\Modules\\{$module}\\Http\\Requests")
        ->classes()
        ->toExtend('Illuminate\Foundation\Http\FormRequest');
}
