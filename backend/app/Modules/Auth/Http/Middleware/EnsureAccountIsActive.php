<?php

declare(strict_types=1);

namespace App\Modules\Auth\Http\Middleware;

use App\Modules\Auth\Exceptions\AccountInactiveException;
use App\Modules\Auth\Models\User;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Blocks suspended / deactivated accounts from using still-valid tokens.
 * Alias: `account.active`. Use on every authenticated route group.
 */
final class EnsureAccountIsActive
{
    public const string ALIAS = 'account.active';

    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();

        if ($user instanceof User && ! $user->status->canSignIn()) {
            throw new AccountInactiveException;
        }

        /** @var Response $response */
        $response = $next($request);

        return $response;
    }
}
