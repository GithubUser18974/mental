<?php

declare(strict_types=1);

namespace App\Support\Exceptions;

use App\Support\Http\ApiResponse;
use App\Support\Translation\Message;
use Illuminate\Auth\AuthenticationException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Symfony\Component\HttpKernel\Exception\HttpExceptionInterface;
use Throwable;

/**
 * Converts every exception thrown on an API route into the standard error envelope.
 *
 * Client-facing messages are always generic translations — exception messages from
 * the framework or database (which may contain model names, SQL or user data) are
 * never echoed back. Details stay in the (redacted) logs.
 */
final class ApiExceptionRenderer
{
    private const array STATUS_MESSAGES = [
        401 => 'api.unauthenticated',
        403 => 'api.forbidden',
        404 => 'api.not_found',
        405 => 'api.method_not_allowed',
        413 => 'api.payload_too_large',
        429 => 'api.too_many_requests',
        503 => 'api.service_unavailable',
    ];

    public function __invoke(Throwable $e, Request $request): ?JsonResponse
    {
        if (! $request->is('api/*')) {
            return null;
        }

        return match (true) {
            $e instanceof ValidationException => ApiResponse::error(
                Message::get('api.validation_failed'),
                422,
                $this->validationErrors($e),
            ),
            $e instanceof AuthenticationException => ApiResponse::error(Message::get('api.unauthenticated'), 401),
            $e instanceof ApiException => ApiResponse::error($e->getMessage(), $e->status(), $e->errors()),
            $e instanceof HttpExceptionInterface => $this->fromHttpException($e),
            default => ApiResponse::error(Message::get('api.server_error'), 500),
        };
    }

    private function fromHttpException(HttpExceptionInterface $e): JsonResponse
    {
        $status = $e->getStatusCode();
        $key = self::STATUS_MESSAGES[$status] ?? ($status >= 500 ? 'api.server_error' : 'api.http_error');

        /** @var array<string, string> $headers */
        $headers = $e->getHeaders();

        return ApiResponse::error(Message::get($key), $status, headers: $headers);
    }

    /**
     * @return array<string, list<string>>
     */
    private function validationErrors(ValidationException $e): array
    {
        /** @var array<string, list<string>> $errors */
        $errors = $e->errors();

        return $errors;
    }
}
