<?php

declare(strict_types=1);

namespace App\Modules\Medication\Support;

use App\Modules\Medication\Enums\ScheduleType;
use App\Modules\Medication\Models\Medication;
use Carbon\CarbonImmutable;
use DateTimeZone;

/**
 * Expands a medication's schedule into concrete dose times (FR-MED-002/003).
 *
 * Times are wall-clock in the member's CURRENT timezone: "08:00" means 8 am local on
 * every matching day, so doses follow travel and daylight-saving changes. On a DST
 * spring-forward day a time that doesn't exist (e.g. 02:30) moves forward to the next
 * valid instant; on fall-back the first occurrence is used — never a duplicate dose.
 */
final class DoseCalendar
{
    /**
     * Dose times (UTC) within [$fromUtc, $toUtc), oldest first.
     *
     * @return list<CarbonImmutable>
     */
    public static function between(
        Medication $medication,
        CarbonImmutable $fromUtc,
        CarbonImmutable $toUtc,
        DateTimeZone $tz,
    ): array {
        $schedule = $medication->schedule;
        if ($schedule === null || $schedule->type === ScheduleType::AsNeeded || $schedule->times === []) {
            return [];
        }

        $start = CarbonImmutable::parse($medication->start_date->format('Y-m-d'), $tz)->startOfDay();
        $end = $medication->end_date === null
            ? null
            : CarbonImmutable::parse($medication->end_date->format('Y-m-d'), $tz)->startOfDay();

        $day = $fromUtc->setTimezone($tz)->startOfDay();
        $lastDay = $toUtc->setTimezone($tz)->startOfDay();
        $doses = [];

        while ($day->lte($lastDay)) {
            if ($day->gte($start) && ($end === null || $day->lte($end)) && self::matches($schedule->type, $day, $start, $schedule->days_of_week, $schedule->interval_days)) {
                foreach ($schedule->times as $time) {
                    $local = CarbonImmutable::createFromFormat('Y-m-d H:i', $day->format('Y-m-d').' '.$time, $tz);
                    if ($local === null) {
                        continue;
                    }
                    $utc = $local->utc();
                    if ($utc->gte($fromUtc) && $utc->lt($toUtc)) {
                        $doses[] = $utc;
                    }
                }
            }
            $day = $day->addDay();
        }

        usort($doses, static fn (CarbonImmutable $a, CarbonImmutable $b): int => $a <=> $b);

        return $doses;
    }

    /**
     * @param  list<int>|null  $daysOfWeek
     */
    private static function matches(
        ScheduleType $type,
        CarbonImmutable $day,
        CarbonImmutable $start,
        ?array $daysOfWeek,
        ?int $intervalDays,
    ): bool {
        return match ($type) {
            ScheduleType::Daily => true,
            ScheduleType::Weekly => in_array($day->isoWeekday(), $daysOfWeek ?? [], true),
            ScheduleType::Interval => $intervalDays !== null && $intervalDays > 0
                && ((int) $start->diffInDays($day)) % $intervalDays === 0,
            ScheduleType::AsNeeded => false,
        };
    }
}
