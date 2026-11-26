<?php

declare(strict_types=1);

namespace App\Modules\Tracking\Http\Resources;

use App\Modules\Tracking\Models\MoodEntry;
use App\Modules\Tracking\Models\SymptomCategory;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * Shapes BuildOverview's result for the API.
 *
 * @property array<string, mixed> $resource
 */
final class OverviewResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $o = $this->resource;
        $latest = $o['latest'] ?? null;
        /** @var list<array{category: SymptomCategory, count: int, average_severity: float}> $symptoms */
        $symptoms = $o['top_symptoms'] ?? [];

        return [
            'latest' => $latest instanceof MoodEntry ? new MoodEntryResource($latest) : null,
            'streak_days' => $o['streak_days'],
            'total_check_ins' => $o['total_check_ins'],
            'last_7_days' => $o['last_7_days'],
            'averages' => $o['averages'],
            'top_symptoms' => array_map(static fn (array $s): array => [
                'category' => new SymptomCategoryResource($s['category']),
                'count' => $s['count'],
                'average_severity' => $s['average_severity'],
            ], $symptoms),
        ];
    }
}
