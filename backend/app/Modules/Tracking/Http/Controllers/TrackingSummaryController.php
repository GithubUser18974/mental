<?php

declare(strict_types=1);

namespace App\Modules\Tracking\Http\Controllers;

use App\Modules\Auth\Models\User;
use App\Modules\Tracking\Actions\BuildOverview;
use App\Modules\Tracking\Enums\Mood;
use App\Modules\Tracking\Http\Resources\OverviewResource;
use App\Modules\Tracking\Http\Resources\SymptomCategoryResource;
use App\Modules\Tracking\Jobs\RefreshInsights;
use App\Modules\Tracking\Models\SymptomCategory;
use App\Modules\Tracking\Models\TrackingInsight;
use App\Support\Http\ApiResponse;
use App\Support\Time\Iso8601;
use App\Support\Translation\Message;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * GET /tracking/overview, /tracking/insights, /tracking/symptom-categories.
 */
final class TrackingSummaryController
{
    public function overview(Request $request, BuildOverview $overview): JsonResponse
    {
        return ApiResponse::success(new OverviewResource($overview(self::userId($request))));
    }

    /**
     * Latest computed insights, rendered in the reader's language. If none exist yet a
     * refresh is queued and `refreshing` is true.
     */
    public function insights(Request $request): JsonResponse
    {
        $userId = self::userId($request);
        $stored = TrackingInsight::query()->find($userId);

        if (! $stored instanceof TrackingInsight) {
            RefreshInsights::dispatch($userId);
        }

        $items = [];
        foreach ($stored->items ?? [] as $item) {
            $params = $item['params'];
            if (isset($params['mood']) && is_string($params['mood'])) {
                $params['mood'] = Mood::tryFrom($params['mood'])?->label() ?? $params['mood'];
            }
            $items[] = [
                'key' => $item['key'],
                'kind' => str_starts_with($item['key'], 'milestone_') ? 'milestone' : 'observation',
                'text' => Message::get('tracking::insights.'.$item['key'], $params),
            ];
        }

        return ApiResponse::success([
            'items' => $items,
            // BR-010/011/015: always shown with the observations.
            'disclaimer' => Message::get('tracking::insights.disclaimer'),
            'computed_at' => $stored === null ? null : Iso8601::format($stored->computed_at),
            'refreshing' => $stored === null,
        ]);
    }

    public function symptomCategories(): JsonResponse
    {
        return ApiResponse::success(SymptomCategoryResource::collection(SymptomCategory::query()->active()->get()));
    }

    private static function userId(Request $request): string
    {
        /** @var User $user */
        $user = $request->user();

        return $user->id;
    }
}
