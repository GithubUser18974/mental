<?php

declare(strict_types=1);

namespace App\Modules\Medication\Http\Controllers;

use App\Modules\Auth\Models\User;
use App\Modules\Medication\Actions\FindMedication;
use App\Modules\Medication\Actions\RecordIntake;
use App\Modules\Medication\Http\Requests\IntakeRequest;
use App\Modules\Medication\Http\Resources\MedicationLogResource;
use App\Support\Http\ApiResponse;
use App\Support\Translation\Message;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

/**
 * /medications/{id}/logs — intake history (FR-MED-004/006).
 */
final class MedicationLogController
{
    public function __construct(private readonly FindMedication $find) {}

    public function index(Request $request, string $id): JsonResponse
    {
        $medication = ($this->find)(self::userId($request), $id);
        $perPage = max(1, min(100, $request->integer('per_page', 30)));

        $logs = $medication->logs()
            ->orderByRaw('COALESCE(scheduled_at, taken_at, created_at) DESC')
            ->orderByDesc('id')
            ->cursorPaginate($perPage);

        return ApiResponse::success(MedicationLogResource::collection($logs));
    }

    public function store(IntakeRequest $request, string $id, RecordIntake $record): JsonResponse
    {
        $medication = ($this->find)(self::userId($request), $id);
        [$log, $created] = $record($medication, $request->intake());

        return ApiResponse::success(
            new MedicationLogResource($log),
            Message::get('medication::messages.intake_recorded'),
            $created ? 201 : 200,
        );
    }

    public function destroy(Request $request, string $id, string $logId): Response
    {
        $medication = ($this->find)(self::userId($request), $id);
        $this->find->log($medication, $logId)->delete();

        return ApiResponse::noContent();
    }

    private static function userId(Request $request): string
    {
        /** @var User $user */
        $user = $request->user();

        return $user->id;
    }
}
