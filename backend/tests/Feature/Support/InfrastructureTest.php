<?php

declare(strict_types=1);

use App\Modules\System\ModuleServiceProvider as SystemModule;
use Illuminate\Routing\Route as RouteDefinition;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\Facades\Route;

it('auto-discovers and registers module service providers', function (): void {
    expect(app()->getProviders(SystemModule::class))->not->toBeEmpty()
        ->and(Route::has('api.v1.health'))->toBeTrue();
});

it('defines all named rate limiters', function (string $name): void {
    expect(RateLimiter::limiter($name))->not->toBeNull();
})->with(['api', 'auth', 'password-reset', 'writes', 'reports', 'uploads']);

it('applies the api throttle and request-id middleware to module routes', function (): void {
    $middleware = Route::getRoutes()->getByName('api.v1.health')?->gatherMiddleware() ?? [];

    expect($middleware)->toContain('api');

    $resolved = app('router')->gatherRouteMiddleware(Route::getRoutes()->getByName('api.v1.health'));
    expect($resolved)->toContain('Illuminate\Routing\Middleware\ThrottleRequests:api')
        ->toContain(App\Support\Http\Middleware\AssignRequestId::class);
});

it('documents every /api/v1 route in the OpenAPI spec and vice versa', function (): void {
    $specPath = base_path('../docs/openapi/openapi.json');
    expect(is_file($specPath))->toBeTrue("OpenAPI spec missing at {$specPath}");

    /** @var array{paths: array<string, array<string, mixed>>} $spec */
    $spec = json_decode((string) file_get_contents($specPath), true, flags: JSON_THROW_ON_ERROR);

    $routes = collect(Route::getRoutes()->getRoutes())
        ->filter(static fn (RouteDefinition $route): bool => str_starts_with($route->uri(), 'api/v1/'))
        ->flatMap(static fn (RouteDefinition $route): array => collect($route->methods())
            ->reject(static fn (string $method): bool => $method === 'HEAD')
            ->map(static fn (string $method): string => strtolower($method).' /'.substr($route->uri(), strlen('api/v1/')))
            ->all())
        ->sort()->values()->all();

    $documented = collect($spec['paths'])
        ->flatMap(static fn (array $operations, string $path): array => collect(array_keys($operations))
            ->filter(static fn (string $key): bool => in_array($key, ['get', 'post', 'put', 'patch', 'delete'], true))
            ->map(static fn (string $method): string => $method.' '.$path)
            ->all())
        ->sort()->values()->all();

    expect(array_values(array_diff($routes, $documented)))->toBe([], 'Routes missing from OpenAPI spec')
        ->and(array_values(array_diff($documented, $routes)))->toBe([], 'OpenAPI paths without a route');
});
