<?php

declare(strict_types=1);

namespace App\Modules\Tracking\Support;

use Carbon\CarbonImmutable;
use DateTimeZone;

/**
 * Calendar-day helpers in the member's own timezone (a check-in at 23:30 local time
 * belongs to that local day, whatever the UTC date is).
 */
final class LocalDays
{
    public static function dayOf(CarbonImmutable $utc, DateTimeZone $tz): string
    {
        return $utc->setTimezone($tz)->format('Y-m-d');
    }

    /**
     * Consecutive local days with at least one entry, counting back from today — or from
     * yesterday if there's nothing yet today (the streak isn't broken until the day ends).
     *
     * @param  iterable<CarbonImmutable>  $times
     */
    public static function currentStreak(iterable $times, DateTimeZone $tz, ?CarbonImmutable $now = null): int
    {
        $days = [];
        foreach ($times as $time) {
            $days[self::dayOf($time, $tz)] = true;
        }

        $day = ($now ?? CarbonImmutable::now())->setTimezone($tz)->startOfDay();
        if (! isset($days[$day->format('Y-m-d')])) {
            $day = $day->subDay();
        }

        $streak = 0;
        while (isset($days[$day->format('Y-m-d')])) {
            $streak++;
            $day = $day->subDay();
        }

        return $streak;
    }
}
