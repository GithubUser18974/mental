<?php

declare(strict_types=1);

namespace App\Modules\Tracking\Http\Controllers;

use App\Modules\Auth\Models\User;
use App\Modules\Identity\Services\AccountPreferences;
use App\Modules\Tracking\Actions\TrackingEntries;
use App\Modules\Tracking\Http\Requests\HistoryRequest;
use App\Modules\Tracking\Http\Requests\SleepEntryRequest;
use App\Modules\Tracking\Http\Resources\SleepEntryResource;
use App\Modules\Tracking\Models\SleepEntry;
use App\Support\Http\ApiResponse;
use App\Support\Translation\Message;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

/**
 * /tracking/sleep (FR-TRACK-001/006). Owner only; others → 404.
 */
final class SleepEntryController
{
    /** @param TrackingEntries<SleepEntry> $entries */
    public function __construct(private readonly TrackingEntries $entries) {}

    public function index(HistoryRequest $request, AccountPreferences $preferences): JsonResponse
    {
        $userId = self::userId($request);
        [$from, $to] = $request->utcRange($preferences->timezone($userId));

        return ApiResponse::success(SleepEntryResource::collection(
            $this->entries->list(SleepEntry::class, $userId, $from, $to, $request->perPage()),
        ));
    }

    public function store(SleepEntryRequest $request): JsonResponse
    {
        $entry = $this->entries->create(SleepEntry::class, self::userId($request), $request->entry());

        return ApiResponse::created(new SleepEntryResource($entry), Message::get('tracking::messages.sleep_created'));
    }

    public function show(Request $request, string $id): JsonResponse
    {
        return ApiResponse::success(new SleepEntryResource($this->entries->find(SleepEntry::class, self::userId($request), $id)));
    }

    public function update(SleepEntryRequest $request, string $id): JsonResponse
    {
        $entry = $this->entries->find(SleepEntry::class, self::userId($request), $id);

        return ApiResponse::success(
            new SleepEntryResource($this->entries->update($entry, $request->entry())),
            Message::get('tracking::messages.entry_updated'),
        );
    }

    public function destroy(Request $request, string $id): Response
    {
        $this->entries->delete($this->entries->find(SleepEntry::class, self::userId($request), $id));

        return ApiResponse::noContent();
    }

    private static function userId(Request $request): string
    {
        /** @var User $user */
        $user = $request->user();

        return $user->id;
    }
}
