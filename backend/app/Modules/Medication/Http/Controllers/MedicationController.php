<?php

declare(strict_types=1);

namespace App\Modules\Medication\Http\Controllers;

use App\Modules\Auth\Models\User;
use App\Modules\Identity\Services\AccountPreferences;
use App\Modules\Medication\Actions\FindMedication;
use App\Modules\Medication\Actions\ListMedications;
use App\Modules\Medication\Actions\SaveMedication;
use App\Modules\Medication\Http\Requests\MedicationListRequest;
use App\Modules\Medication\Http\Requests\MedicationRequest;
use App\Modules\Medication\Http\Resources\MedicationResource;
use App\Support\Http\ApiResponse;
use App\Support\Translation\Message;
use Carbon\CarbonImmutable;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

/**
 * /medications (SRS §8.6). Owner only; another member's medication → 404.
 */
final class MedicationController
{
    public function __construct(private readonly FindMedication $find, private readonly SaveMedication $save) {}

    public function index(MedicationListRequest $request, ListMedications $list, AccountPreferences $preferences): JsonResponse
    {
        $userId = self::userId($request);
        $today = CarbonImmutable::now($preferences->timezone($userId));

        return ApiResponse::success(MedicationResource::collection(
            $list($userId, $request->filter(), $today, $request->perPage()),
        ));
    }

    public function store(MedicationRequest $request): JsonResponse
    {
        $schedule = $request->schedule() ?? [];
        $medication = $this->save->create(self::userId($request), $request->medication(), $schedule);

        return ApiResponse::created(new MedicationResource($medication), Message::get('medication::messages.created'));
    }

    public function show(Request $request, string $id): JsonResponse
    {
        return ApiResponse::success(new MedicationResource(($this->find)(self::userId($request), $id)));
    }

    public function update(MedicationRequest $request, string $id): JsonResponse
    {
        $medication = ($this->find)(self::userId($request), $id);

        return ApiResponse::success(
            new MedicationResource($this->save->update($medication, $request->medication(), $request->schedule())),
            Message::get('medication::messages.updated'),
        );
    }

    /** Permanent delete, with its schedule, logs and experiences. */
    public function destroy(Request $request, string $id): Response
    {
        ($this->find)(self::userId($request), $id)->delete();

        return ApiResponse::noContent();
    }

    private static function userId(Request $request): string
    {
        /** @var User $user */
        $user = $request->user();

        return $user->id;
    }
}
