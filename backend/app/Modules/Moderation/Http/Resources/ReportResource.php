<?php

declare(strict_types=1);

namespace App\Modules\Moderation\Http\Resources;

use App\Modules\Moderation\Models\Report;
use App\Support\Time\Iso8601;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * A report as seen by the member who filed it. Never shown to the reported member.
 *
 * `crisis_support`: the app should offer crisis resources and an escalation path
 * (FR-SAFETY-002) because the reported content suggests someone may be in danger.
 *
 * @property Report $resource
 */
final class ReportResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $report = $this->resource;

        return [
            'id' => $report->id,
            'target_type' => $report->target_type->value,
            'target_id' => $report->target_id,
            'reason' => $report->reason->value,
            'status' => $report->status->value,
            'crisis_support' => $report->reason->suggestsCrisis(),
            'created_at' => Iso8601::format($report->created_at),
        ];
    }
}
