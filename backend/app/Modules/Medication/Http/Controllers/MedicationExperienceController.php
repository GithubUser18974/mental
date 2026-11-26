<?php

declare(strict_types=1);

namespace App\Modules\Medication\Http\Controllers;

use App\Modules\Auth\Models\User;
use App\Modules\Medication\Actions\FindMedication;
use App\Modules\Medication\Http\Requests\ExperienceRequest;
use App\Modules\Medication\Http\Resources\MedicationExperienceResource;
use App\Modules\Medication\Models\MedicationExperience;
use App\Support\Http\ApiResponse;
use App\Support\Translation\Message;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

/**
 * /medications/{id}/experiences — private experience notes (FR-MED-005).
 */
final class MedicationExperienceController
{
    public function __construct(private readonly FindMedication $find) {}

    public function index(Request $request, string $id): JsonResponse
    {
        $medication = ($this->find)(self::userId($request), $id);
        $perPage = max(1, min(100, $request->integer('per_page', 30)));

        return ApiResponse::success(MedicationExperienceResource::collection(
            $medication->experiences()->orderByDesc('observed_on')->orderByDesc('id')->cursorPaginate($perPage),
        ));
    }

    public function store(ExperienceRequest $request, string $id): JsonResponse
    {
        $medication = ($this->find)(self::userId($request), $id);

        $experience = new MedicationExperience;
        $experience->fill($request->experience());
        $experience->medication_id = $medication->id;
        $experience->user_id = $medication->user_id;
        $experience->save();

        return ApiResponse::created(
            new MedicationExperienceResource($experience),
            Message::get('medication::messages.experience_saved'),
        );
    }

    public function destroy(Request $request, string $id, string $experienceId): Response
    {
        $medication = ($this->find)(self::userId($request), $id);
        $this->find->experience($medication, $experienceId)->delete();

        return ApiResponse::noContent();
    }

    private static function userId(Request $request): string
    {
        /** @var User $user */
        $user = $request->user();

        return $user->id;
    }
}
