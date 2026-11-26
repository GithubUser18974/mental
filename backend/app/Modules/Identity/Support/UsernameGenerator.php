<?php

declare(strict_types=1);

namespace App\Modules\Identity\Support;

use Random\Randomizer;

/**
 * Calm, human-friendly pseudonyms: Adjective + Noun + 2–4 digits (e.g. `QuietRiver482`).
 * Never derived from the user's email or any account data.
 */
final class UsernameGenerator
{
    private const array ADJECTIVES = [
        'Quiet', 'Gentle', 'Calm', 'Brave', 'Kind', 'Hopeful', 'Soft', 'Bright',
        'Still', 'Warm', 'Steady', 'Patient', 'Silver', 'Golden', 'Misty', 'Velvet',
        'Tender', 'Serene', 'Mellow', 'Sunny',
    ];

    private const array NOUNS = [
        'River', 'Willow', 'Harbor', 'Meadow', 'Lantern', 'Sparrow', 'Cedar', 'Breeze',
        'Tide', 'Ember', 'Fern', 'Pebble', 'Comet', 'Maple', 'Lark', 'Orchid',
        'Brook', 'Dawn', 'Heron', 'Moss',
    ];

    public function __construct(private readonly Randomizer $random = new Randomizer) {}

    public function generate(): string
    {
        $adjective = self::ADJECTIVES[$this->random->getInt(0, count(self::ADJECTIVES) - 1)];
        $noun = self::NOUNS[$this->random->getInt(0, count(self::NOUNS) - 1)];
        $number = (string) $this->random->getInt(10, 9999);

        return $adjective.$noun.$number; // max 7 + 7 + 4 = 18 chars
    }

    /**
     * Up to $count distinct usernames that are currently free.
     *
     * @return list<string>
     */
    public function available(int $count, int $maxAttempts = 50): array
    {
        $names = [];

        for ($i = 0; $i < $maxAttempts && count($names) < $count; $i++) {
            $name = $this->generate();

            if (! in_array($name, $names, true) && UsernamePolicy::isAvailable($name)) {
                $names[] = $name;
            }
        }

        return $names;
    }
}
