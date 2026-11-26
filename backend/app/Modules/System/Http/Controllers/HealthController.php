<?php

declare(strict_types=1);

namespace App\Modules\System\Http\Controllers;

use App\Support\Http\ApiResponse;
use App\Support\Translation\Message;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Redis;
use Throwable;

/**
 * Liveness/readiness probe. Reports only pass/fail per dependency — never versions or error details.
 */
final class HealthController
{
    public function __invoke(): JsonResponse
    {
        $failed = array_keys(array_filter([
            'database' => ! $this->check(static fn (): mixed => DB::select('select 1')),
            'redis' => ! $this->check(static fn (): mixed => Redis::connection()->ping()),
        ]));

        if ($failed !== []) {
            return ApiResponse::error(
                Message::get('api.degraded'),
                503,
                array_fill_keys($failed, [Message::get('api.dependency_unavailable')]),
            );
        }

        return ApiResponse::success(['status' => 'ok'], Message::get('api.healthy'));
    }

    /**
     * @param  callable(): mixed  $probe
     */
    private function check(callable $probe): bool
    {
        try {
            $probe();

            return true;
        } catch (Throwable) {
            return false;
        }
    }
}
