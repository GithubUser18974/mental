<?php

declare(strict_types=1);

namespace App\Modules\Community\Support;

/**
 * Finds `#tags` in post text (Arabic and Latin), normalized to lowercase, unique, capped.
 */
final class HashtagExtractor
{
    public const int MAX_PER_POST = 10;

    /** 2–30 letters/digits/underscore, not glued to a preceding word character. */
    private const string PATTERN = '/(?<![\p{L}\p{N}_#])#([\p{L}\p{N}_]{2,30})(?![\p{L}\p{N}_])/u';

    /**
     * @return list<string>
     */
    public static function extract(string $text): array
    {
        if (preg_match_all(self::PATTERN, $text, $matches) === false) {
            return [];
        }

        $tags = [];
        foreach ($matches[1] as $tag) {
            // Purely numeric tags (#1, #2024) are not topics.
            if (preg_match('/^\p{N}+$/u', $tag) === 1) {
                continue;
            }
            $tags[mb_strtolower($tag)] = true;
        }

        return array_slice(array_keys($tags), 0, self::MAX_PER_POST);
    }

    public static function normalize(string $tag): string
    {
        return mb_strtolower(ltrim(trim($tag), '#'));
    }
}
