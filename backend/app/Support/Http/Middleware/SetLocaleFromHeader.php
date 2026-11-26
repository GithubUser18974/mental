<?php

declare(strict_types=1);

namespace App\Support\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Picks the response language (Arabic / English) from the `Accept-Language` header.
 */
final class SetLocaleFromHeader
{
    public const array SUPPORTED = ['en', 'ar'];

    public function handle(Request $request, Closure $next): Response
    {
        $fallback = config('app.fallback_locale');
        $locale = $request->getPreferredLanguage(self::SUPPORTED) ?? (is_string($fallback) ? $fallback : 'en');

        app()->setLocale($locale);

        /** @var Response $response */
        $response = $next($request);
        $response->headers->set('Content-Language', $locale);

        return $response;
    }
}
