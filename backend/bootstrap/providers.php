<?php

declare(strict_types=1);

use App\Providers\AppServiceProvider;
use App\Providers\ModulesServiceProvider;
use App\Providers\RateLimitServiceProvider;

return [
    AppServiceProvider::class,
    RateLimitServiceProvider::class,
    ModulesServiceProvider::class,
];
