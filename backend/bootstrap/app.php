<?php

declare(strict_types=1);

use App\Support\Exceptions\ApiExceptionRenderer;
use App\Support\Http\Middleware\AssignRequestId;
use App\Support\Http\Middleware\ForceJsonResponse;
use App\Support\Http\Middleware\SetLocaleFromHeader;
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Http\Request;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware): void {
        $middleware->api(prepend: [
            AssignRequestId::class,
            ForceJsonResponse::class,
            SetLocaleFromHeader::class,
        ]);

        $middleware->throttleApi('api');
    })
    ->withExceptions(function (Exceptions $exceptions): void {
        $exceptions->shouldRenderJsonWhen(
            fn (Request $request): bool => $request->is('api/*') || $request->expectsJson(),
        );

        $exceptions->render(new ApiExceptionRenderer);

        $exceptions->dontReportDuplicates();

        $exceptions->dontFlash([
            'current_password',
            'password',
            'password_confirmation',
            'token',
            'otp',
        ]);
    })->create();
