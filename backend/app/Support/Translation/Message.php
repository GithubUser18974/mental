<?php

declare(strict_types=1);

namespace App\Support\Translation;

/**
 * Typed wrapper around `__()` for single-string translations (which may return arrays).
 */
final class Message
{
    /**
     * @param  array<string, string|int|float>  $replace
     */
    public static function get(string $key, array $replace = []): string
    {
        $value = __($key, $replace);

        return is_string($value) ? $value : $key;
    }
}
