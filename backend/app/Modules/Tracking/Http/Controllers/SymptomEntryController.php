<?php

declare(strict_types=1);

namespace App\Modules\Tracking\Http\Controllers;

use App\Modules\Auth\Models\User;
use App\Modules\Identity\Services\AccountPreferences;
use App\Modules\Tracking\Actions\TrackingEntries;
use App\Modules\Tracking\Http\Requests\HistoryRequest;
use App\Modules\Tracking\Http\Requests\SymptomEntryRequest;
use App\Modules\Tracking\Http\Resources\SymptomEntryResource;
use App\Modules\Tracking\Models\SymptomEntry;
use App\Support\Http\ApiResponse;
use App\Support\Translation\Message;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

/**
 * /tracking/symptoms (FR-TRACK-003/006). Owner only; others → 404.
 */
final class SymptomEntryController
{
    /** @param TrackingEntries<SymptomEntry> $entries */
    public function __construct(private readonly TrackingEntries $entries) {}

    public function index(HistoryRequest $request, AccountPreferences $preferences): JsonResponse
    {
        $userId = self::userId($request);
        [$from, $to] = $request->utcRange($preferences->timezone($userId));

        return ApiResponse::success(SymptomEntryResource::collection(
            $this->entries->list(SymptomEntry::class, $userId, $from, $to, $request->perPage()),
        ));
    }

    public function store(SymptomEntryRequest $request): JsonResponse
    {
        $entry = $this->entries->create(SymptomEntry::class, self::userId($request), $request->entry());

        return ApiResponse::created(
            new SymptomEntryResource($entry->load('category')),
            Message::get('tracking::messages.symptom_created'),
        );
    }

    public function show(Request $request, string $id): JsonResponse
    {
        $entry = $this->entries->find(SymptomEntry::class, self::userId($request), $id);

        return ApiResponse::success(new SymptomEntryResource($entry->load('category')));
    }

    public function update(SymptomEntryRequest $request, string $id): JsonResponse
    {
        $entry = $this->entries->find(SymptomEntry::class, self::userId($request), $id);

        return ApiResponse::success(
            new SymptomEntryResource($this->entries->update($entry, $request->entry())->load('category')),
            Message::get('tracking::messages.entry_updated'),
        );
    }

    public function destroy(Request $request, string $id): Response
    {
        $this->entries->delete($this->entries->find(SymptomEntry::class, self::userId($request), $id));

        return ApiResponse::noContent();
    }

    private static function userId(Request $request): string
    {
        /** @var User $user */
        $user = $request->user();

        return $user->id;
    }
}
