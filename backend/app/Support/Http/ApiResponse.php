<?php

declare(strict_types=1);

namespace App\Support\Http;

use App\Support\Translation\Message;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Http\Response;

/**
 * Builds the standard API envelope shared with the mobile app (SRS §8.9):
 *
 *   success: { success: true,  message, data, meta? }
 *   error:   { success: false, message, errors? }
 *
 * `meta.pagination` is added automatically for paginated resource collections.
 */
final class ApiResponse
{
    /**
     * @param  JsonResource|array<array-key, mixed>|null  $data
     * @param  array<string, mixed>  $meta
     * @param  array<string, string>  $headers
     */
    public static function success(
        JsonResource|array|null $data = null,
        ?string $message = null,
        int $status = 200,
        array $meta = [],
        array $headers = [],
    ): JsonResponse {
        [$data, $pagination] = self::resolveData($data);

        if ($pagination !== null) {
            $meta = ['pagination' => $pagination, ...$meta];
        }

        $body = [
            'success' => true,
            'message' => $message ?? Message::get('api.success'),
            'data' => $data,
        ];

        if ($meta !== []) {
            $body['meta'] = $meta;
        }

        return new JsonResponse($body, $status, $headers);
    }

    /**
     * @param  JsonResource|array<array-key, mixed>|null  $data
     */
    public static function created(JsonResource|array|null $data = null, ?string $message = null): JsonResponse
    {
        return self::success($data, $message ?? Message::get('api.created'), 201);
    }

    public static function noContent(): Response
    {
        return new Response(status: 204);
    }

    /**
     * @param  array<string, list<string>>  $errors  field => messages
     * @param  array<string, string>  $headers
     */
    public static function error(string $message, int $status, array $errors = [], array $headers = []): JsonResponse
    {
        $body = [
            'success' => false,
            'message' => $message,
        ];

        if ($errors !== []) {
            $body['errors'] = $errors;
        }

        return new JsonResponse($body, $status, $headers);
    }

    /**
     * @param  JsonResource|array<array-key, mixed>|null  $data
     * @return array{0: mixed, 1: array<string, mixed>|null}
     */
    private static function resolveData(JsonResource|array|null $data): array
    {
        if (! $data instanceof JsonResource) {
            return [$data, null];
        }

        /** @var array<string, mixed> $payload */
        $payload = $data->response(request())->getData(true);

        return [$payload['data'] ?? null, self::pagination($payload)];
    }

    /**
     * Normalizes Laravel's cursor / length-aware paginator meta into one shape.
     *
     * @param  array<string, mixed>  $payload
     * @return array<string, mixed>|null
     */
    private static function pagination(array $payload): ?array
    {
        $meta = $payload['meta'] ?? null;

        if (! is_array($meta) || ! array_key_exists('per_page', $meta)) {
            return null;
        }

        if (array_key_exists('next_cursor', $meta)) {
            return [
                'per_page' => $meta['per_page'],
                'next_cursor' => $meta['next_cursor'],
                'prev_cursor' => $meta['prev_cursor'] ?? null,
                'has_more' => $meta['next_cursor'] !== null,
            ];
        }

        return [
            'per_page' => $meta['per_page'],
            'current_page' => $meta['current_page'] ?? null,
            'last_page' => $meta['last_page'] ?? null,
            'total' => $meta['total'] ?? null,
            'has_more' => ($meta['current_page'] ?? 0) < ($meta['last_page'] ?? 0),
        ];
    }
}
