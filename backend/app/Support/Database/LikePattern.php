<?php

declare(strict_types=1);

namespace App\Support\Database;

/**
 * Builds LIKE/ILIKE patterns from user input with `%`, `_` and `\` escaped, so search
 * text is always matched literally (always passed as a binding, never interpolated).
 */
final class LikePattern
{
    public static function contains(string $text): string
    {
        return '%'.self::escape($text).'%';
    }

    public static function startsWith(string $text): string
    {
        return self::escape($text).'%';
    }

    public static function escape(string $text): string
    {
        return str_replace(['\\', '%', '_'], ['\\\\', '\\%', '\\_'], $text);
    }
}
