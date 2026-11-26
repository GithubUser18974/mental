<?php

declare(strict_types=1);

namespace App\Support\Time;

use DateTimeImmutable;
use DateTimeInterface;
use DateTimeZone;

/**
 * API timestamp format: UTC, second precision, `Z` suffix — `2026-11-12T10:00:00Z`.
 */
final class Iso8601
{
    public static function format(?DateTimeInterface $date): ?string
    {
        if ($date === null) {
            return null;
        }

        return DateTimeImmutable::createFromInterface($date)
            ->setTimezone(new DateTimeZone('UTC'))
            ->format('Y-m-d\TH:i:s\Z');
    }
}
