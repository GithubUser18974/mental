<?php

declare(strict_types=1);

namespace App\Modules\Tracking\Actions;

use App\Modules\Identity\Services\AccountPreferences;
use App\Modules\Tracking\Models\MoodEntry;
use App\Modules\Tracking\Models\SleepEntry;
use App\Modules\Tracking\Support\LocalDays;
use Carbon\CarbonImmutable;
use DateTimeZone;
use Illuminate\Support\Collection;

/**
 * Non-diagnostic personal observations (FR-TRACK-005, BR-015) from the member's own
 * records. Describes what was recorded — never causes, diagnoses or treatment advice.
 * Each insight needs a minimum amount of data so a couple of entries can't produce a
 * misleading "trend".
 *
 * Returns language-neutral `{key, params}`; text is rendered at read time.
 */
final readonly class ComputeInsights
{
    /** Minimum entries in each compared period. */
    public const int MIN_ENTRIES = 3;

    /** Difference in average (1–10 scale) that counts as "higher"/"lower". */
    public const float TREND_THRESHOLD = 0.75;

    public function __construct(private AccountPreferences $preferences) {}

    /**
     * @return list<array{key: string, params: array<string, string|int|float>}>
     */
    public function __invoke(string $userId, ?CarbonImmutable $now = null): array
    {
        $now ??= CarbonImmutable::now();
        $tz = $this->preferences->timezone($userId);

        /** @var Collection<int, MoodEntry> $moods */
        $moods = MoodEntry::query()->ownedBy($userId)
            ->where('recorded_at', '>=', $now->subDays(60))
            ->get(['mood', 'score', 'stress', 'recorded_at']);

        $insights = [];

        foreach ([['score', 'mood_trend', true], ['stress', 'stress_trend', false]] as [$field, $key, $withSteady]) {
            $trend = $this->trend($moods, $field, $now);
            if ($trend !== null && ($withSteady || $trend['direction'] !== 'steady')) {
                $insights[] = [
                    'key' => $key.'_'.$trend['direction'],
                    'params' => ['recent' => $trend['recent'], 'previous' => $trend['previous']],
                ];
            }
        }

        $lastMonth = $moods->filter(fn (MoodEntry $m): bool => $m->recorded_at->gte($now->subDays(30)));
        if ($lastMonth->count() >= self::MIN_ENTRIES) {
            // Most recorded; a tie goes to the most recently recorded mood.
            $frequent = $lastMonth
                ->sortByDesc(fn (MoodEntry $m): int => $m->recorded_at->getTimestamp())
                ->groupBy(fn (MoodEntry $m): string => $m->mood->value)
                ->map(fn (Collection $group): int => $group->count())
                ->sortDesc(SORT_NUMERIC)
                ->keys()
                ->first();
            if (is_string($frequent)) {
                $insights[] = ['key' => 'frequent_mood', 'params' => ['mood' => $frequent]];
            }
        }

        if (($sleep = $this->sleepAndMood($userId, $moods, $tz, $now)) !== null) {
            $insights[] = ['key' => 'sleep_mood', 'params' => $sleep];
        }

        return [...$insights, ...$this->milestones($userId, $tz, $now)];
    }

    /**
     * Average of the last 14 days vs the 14 before.
     *
     * @param  Collection<int, MoodEntry>  $moods
     * @return array{direction: string, recent: float, previous: float}|null
     */
    private function trend(Collection $moods, string $field, CarbonImmutable $now): ?array
    {
        $values = fn (CarbonImmutable $from, CarbonImmutable $to): Collection => $moods
            ->filter(fn (MoodEntry $m): bool => $m->recorded_at->gte($from) && $m->recorded_at->lt($to))
            ->map(fn (MoodEntry $m): ?int => $m->getAttribute($field))
            ->filter(fn (?int $v): bool => $v !== null);

        $recent = $values($now->subDays(14), $now->addMinute());
        $previous = $values($now->subDays(28), $now->subDays(14));
        if ($recent->count() < self::MIN_ENTRIES || $previous->count() < self::MIN_ENTRIES) {
            return null;
        }

        $r = round((float) $recent->avg(), 1);
        $p = round((float) $previous->avg(), 1);
        $diff = $r - $p;

        return [
            'direction' => $diff >= self::TREND_THRESHOLD ? 'up' : ($diff <= -self::TREND_THRESHOLD ? 'down' : 'steady'),
            'recent' => $r,
            'previous' => $p,
        ];
    }

    /**
     * Mood score on days after 7h+ of sleep vs under 6h (a pattern, not a cause).
     *
     * @param  Collection<int, MoodEntry>  $moods
     * @return array{more: float, less: float}|null
     */
    private function sleepAndMood(string $userId, Collection $moods, DateTimeZone $tz, CarbonImmutable $now): ?array
    {
        $scoreByDay = $moods->filter(fn (MoodEntry $m): bool => $m->score !== null)
            ->groupBy(fn (MoodEntry $m): string => LocalDays::dayOf($m->recorded_at, $tz))
            ->map(fn (Collection $day): float => (float) $day->avg('score'));

        $sleepByDay = SleepEntry::query()->ownedBy($userId)
            ->where('recorded_at', '>=', $now->subDays(60))
            ->get(['duration_minutes', 'recorded_at'])
            ->groupBy(fn (SleepEntry $s): string => LocalDays::dayOf($s->recorded_at, $tz))
            ->map(fn (Collection $day): int => (int) $day->sum('duration_minutes'));

        $more = [];
        $less = [];
        foreach ($sleepByDay as $day => $minutes) {
            if (! $scoreByDay->has($day)) {
                continue;
            }
            if ($minutes >= 7 * 60) {
                $more[] = $scoreByDay[$day];
            } elseif ($minutes < 6 * 60) {
                $less[] = $scoreByDay[$day];
            }
        }

        if (count($more) < self::MIN_ENTRIES || count($less) < self::MIN_ENTRIES) {
            return null;
        }

        return [
            'more' => round(array_sum($more) / count($more), 1),
            'less' => round(array_sum($less) / count($less), 1),
        ];
    }

    /**
     * Engagement milestones (FR-PROGRESS-002) — about the habit of checking in, never
     * implying recovery or improvement.
     *
     * @return list<array{key: string, params: array<string, string|int|float>}>
     */
    private function milestones(string $userId, DateTimeZone $tz, CarbonImmutable $now): array
    {
        $total = MoodEntry::query()->ownedBy($userId)->count();
        if ($total === 0) {
            return [];
        }

        $recent = MoodEntry::query()->ownedBy($userId)
            ->where('recorded_at', '>=', $now->subDays(400))
            ->pluck('recorded_at');
        $streak = LocalDays::currentStreak($recent, $tz, $now);

        $milestones = [];
        if ($streak >= 7) {
            $milestones[] = ['key' => 'milestone_streak', 'params' => ['days' => $streak]];
        }
        if ($total >= 30) {
            $milestones[] = ['key' => 'milestone_check_ins', 'params' => ['count' => 30]];
        }
        if ($total < 30 && $streak < 7) {
            $milestones[] = ['key' => 'milestone_first', 'params' => []];
        }

        return $milestones;
    }
}
