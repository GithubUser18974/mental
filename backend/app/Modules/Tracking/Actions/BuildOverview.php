<?php

declare(strict_types=1);

namespace App\Modules\Tracking\Actions;

use App\Modules\Identity\Services\AccountPreferences;
use App\Modules\Tracking\Models\MoodEntry;
use App\Modules\Tracking\Models\SleepEntry;
use App\Modules\Tracking\Models\SymptomCategory;
use App\Modules\Tracking\Models\SymptomEntry;
use App\Modules\Tracking\Support\LocalDays;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;

/**
 * Tracking dashboard (GET /tracking/overview, FR-PROGRESS-001): latest check-in, streak,
 * the last 7 local days, 7/30-day averages, sleep and the most recorded symptoms.
 * Owner's own data only.
 */
final readonly class BuildOverview
{
    public function __construct(private AccountPreferences $preferences) {}

    /**
     * @return array<string, mixed>
     */
    public function __invoke(string $userId, ?CarbonImmutable $now = null): array
    {
        $now ??= CarbonImmutable::now();
        $tz = $this->preferences->timezone($userId);

        $latest = MoodEntry::query()->ownedBy($userId)->latest('recorded_at')->first();

        $week = MoodEntry::query()->ownedBy($userId)
            ->where('recorded_at', '>=', $now->setTimezone($tz)->startOfDay()->subDays(6)->utc())
            ->orderBy('recorded_at')
            ->get(['mood', 'score', 'recorded_at']);
        $byDay = $week->groupBy(fn (MoodEntry $m): string => LocalDays::dayOf($m->recorded_at, $tz));

        $days = [];
        for ($i = 6; $i >= 0; $i--) {
            $date = $now->setTimezone($tz)->subDays($i)->format('Y-m-d');
            $entries = $byDay->get($date);
            $days[] = [
                'date' => $date,
                'mood' => $entries?->last()?->mood->value,
                'score' => $entries === null || $entries->whereNotNull('score')->isEmpty()
                    ? null
                    : round((float) $entries->avg('score'), 1),
            ];
        }

        $streakTimes = MoodEntry::query()->ownedBy($userId)
            ->where('recorded_at', '>=', $now->subDays(400))
            ->pluck('recorded_at');

        return [
            'latest' => $latest,
            'streak_days' => LocalDays::currentStreak($streakTimes, $tz, $now),
            'total_check_ins' => MoodEntry::query()->ownedBy($userId)->count(),
            'last_7_days' => $days,
            'averages' => [
                'last_7_days' => $this->averages($userId, $now->subDays(7)),
                'last_30_days' => $this->averages($userId, $now->subDays(30)),
            ],
            'top_symptoms' => $this->topSymptoms($userId, $now->subDays(30)),
        ];
    }

    /**
     * @return array<string, float|null>
     */
    private function averages(string $userId, CarbonImmutable $since): array
    {
        $mood = MoodEntry::query()->ownedBy($userId)->where('recorded_at', '>=', $since)
            ->toBase()
            ->selectRaw('avg(score) as score, avg(anxiety) as anxiety, avg(stress) as stress, avg(energy) as energy')
            ->first();
        $sleep = SleepEntry::query()->ownedBy($userId)->where('recorded_at', '>=', $since)
            ->toBase()
            ->selectRaw('avg(duration_minutes) as minutes, avg(quality) as quality')
            ->first();

        $round = static fn (mixed $v, int $div = 1): ?float => is_numeric($v) ? round((float) $v / $div, 1) : null;

        return [
            'score' => $round($mood?->score),
            'anxiety' => $round($mood?->anxiety),
            'stress' => $round($mood?->stress),
            'energy' => $round($mood?->energy),
            'sleep_hours' => $round($sleep?->minutes, 60),
            'sleep_quality' => $round($sleep?->quality),
        ];
    }

    /**
     * Most recorded symptoms with their average severity.
     *
     * @return list<array{category: SymptomCategory, count: int, average_severity: float}>
     */
    private function topSymptoms(string $userId, CarbonImmutable $since): array
    {
        $rows = SymptomEntry::query()->ownedBy($userId)
            ->where('recorded_at', '>=', $since)
            ->toBase()
            ->select('category_id', DB::raw('count(*) as total'), DB::raw('avg(severity) as severity'))
            ->groupBy('category_id')
            ->orderByDesc('total')
            ->limit(5)
            ->get();

        $categories = SymptomCategory::query()->whereIn('id', $rows->pluck('category_id'))->get()->keyBy('id');

        $top = [];
        foreach ($rows as $row) {
            $category = $categories->get($row->category_id);
            if ($category instanceof SymptomCategory) {
                $top[] = [
                    'category' => $category,
                    'count' => (int) $row->total,
                    'average_severity' => round((float) $row->severity, 1),
                ];
            }
        }

        return $top;
    }
}
