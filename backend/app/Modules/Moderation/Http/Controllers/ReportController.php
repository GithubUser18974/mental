<?php

declare(strict_types=1);

namespace App\Modules\Moderation\Http\Controllers;

use App\Modules\Auth\Models\User;
use App\Modules\Identity\Support\CurrentProfile;
use App\Modules\Moderation\Actions\ListOwnReports;
use App\Modules\Moderation\Actions\SubmitReport;
use App\Modules\Moderation\Http\Requests\SubmitReportRequest;
use App\Modules\Moderation\Http\Resources\ReportResource;
use App\Support\Http\ApiResponse;
use App\Support\Translation\Message;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * POST /reports (SRS §8) and GET /reports — the member's own reports and their status.
 */
final class ReportController
{
    public function __construct(private readonly CurrentProfile $current) {}

    public function store(SubmitReportRequest $request, SubmitReport $submit): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();

        $result = $submit(
            $user,
            $this->current->require($user),
            $request->targetType(),
            $request->targetId(),
            $request->reason(),
            $request->details(),
        );

        return ApiResponse::success(
            new ReportResource($result->report),
            Message::get('moderation::messages.report_received'),
            $result->created ? 201 : 200,
        );
    }

    public function index(Request $request, ListOwnReports $list): JsonResponse
    {
        $me = $this->current->require($request->user())->id;

        return ApiResponse::success(ReportResource::collection($list($me, $request->integer('per_page', 20))));
    }
}
