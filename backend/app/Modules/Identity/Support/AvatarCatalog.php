<?php

declare(strict_types=1);

namespace App\Modules\Identity\Support;

use Random\Randomizer;

/**
 * Generated avatars (FR-AUTH-002): an illustration + a soft color, stored as `icon-color`
 * (e.g. `lotus-lavender`). No photo uploads — real faces would undermine anonymity.
 * The mobile app renders each key from bundled artwork.
 */
final class AvatarCatalog
{
    public const array ICONS = [
        'lotus', 'leaf', 'cloud', 'moon', 'sun', 'star',
        'wave', 'feather', 'mountain', 'flower', 'butterfly', 'tree',
    ];

    public const array COLORS = [
        'lavender', 'rose', 'sky', 'mint', 'peach', 'sand', 'lilac', 'sea',
    ];

    /**
     * @return list<string>
     */
    public static function all(): array
    {
        $keys = [];
        foreach (self::ICONS as $icon) {
            foreach (self::COLORS as $color) {
                $keys[] = $icon.'-'.$color;
            }
        }

        return $keys;
    }

    public static function isValid(string $key): bool
    {
        return in_array($key, self::all(), true);
    }

    public static function random(?Randomizer $random = null): string
    {
        $random ??= new Randomizer;

        return self::ICONS[$random->getInt(0, count(self::ICONS) - 1)]
            .'-'.self::COLORS[$random->getInt(0, count(self::COLORS) - 1)];
    }
}
