<?php

declare(strict_types=1);

namespace App\Modules\Moderation\Actions;

use App\Modules\Auth\Models\User;
use App\Modules\Community\Services\ContentLookup;
use App\Modules\Identity\Models\AnonymousProfile;
use App\Modules\Identity\Services\SocialGraph;
use App\Modules\Moderation\DTOs\SubmittedReport;
use App\Modules\Moderation\Enums\ReportReason;
use App\Modules\Moderation\Enums\ReportTargetType;
use App\Modules\Moderation\Events\ContentReported;
use App\Modules\Moderation\Models\Report;
use App\Support\Translation\Message;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Database\UniqueConstraintViolationException;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\ValidationException;
use LogicException;

/**
 * Files a report into the moderation queue (FR-COM-010, BR-009).
 *
 * - Members can only report what they can see (otherwise 404 — no existence leak).
 * - A member who blocked someone can still report that profile; content hidden by a
 *   block can't be reported (it doesn't exist for them).
 * - Repeating a report while it's still pending returns the existing one.
 * - Priority comes from the reason; suicide / self-harm reports are critical and are
 *   announced via ContentReported for the safety workflow (T8.1).
 */
final readonly class SubmitReport
{
    public function __construct(private ContentLookup $content, private SocialGraph $graph) {}

    public function __invoke(
        User $user,
        AnonymousProfile $reporter,
        ReportTargetType $type,
        string $targetId,
        ReportReason $reason,
        ?string $details,
    ): SubmittedReport {
        $ownerId = $this->ownerOf($user, $reporter, $type, $targetId)
            ?? throw (new ModelNotFoundException)->setModel(Report::class);

        if ($ownerId === $reporter->id) {
            throw ValidationException::withMessages([
                'target_id' => [Message::get('moderation::messages.cannot_report_own')],
            ]);
        }

        $existing = $this->pending($reporter->id, $type, $targetId);
        if ($existing instanceof Report) {
            return new SubmittedReport($existing, created: false);
        }

        try {
            $report = DB::transaction(static fn (): Report => Report::query()->create([
                'reporter_profile_id' => $reporter->id,
                'target_type' => $type,
                'target_id' => $targetId,
                'target_owner_profile_id' => $ownerId,
                'reason' => $reason,
                'details' => $details,
                'priority' => $reason->priority(),
            ]));
        } catch (UniqueConstraintViolationException) {
            // Double tap raced us: the other request created it.
            return new SubmittedReport($this->pending($reporter->id, $type, $targetId) ?? throw new LogicException('Report vanished.'), created: false);
        }

        // Ids and labels only — never the details text (it may contain personal information).
        Log::info('moderation.report_created', [
            'report_id' => $report->id,
            'target_type' => $type->value,
            'priority' => $report->priority->label(),
        ]);
        ContentReported::dispatch($report->id, $type, $targetId, $report->priority);

        return new SubmittedReport($report, created: true);
    }

    private function ownerOf(User $user, AnonymousProfile $reporter, ReportTargetType $type, string $targetId): ?string
    {
        return match ($type) {
            ReportTargetType::Post => $this->content->visiblePostAuthor($user, $targetId),
            ReportTargetType::Comment => $this->content->visibleCommentAuthor($user, $targetId),
            ReportTargetType::Profile => $this->visibleProfile($reporter, $targetId),
        };
    }

    private function visibleProfile(AnonymousProfile $reporter, string $profileId): ?string
    {
        $exists = AnonymousProfile::query()->active()->whereKey($profileId)->exists();

        return $exists && ! $this->graph->hasBlocked($profileId, $reporter->id) ? $profileId : null;
    }

    private function pending(string $reporterId, ReportTargetType $type, string $targetId): ?Report
    {
        return Report::query()
            ->pending()
            ->where('reporter_profile_id', $reporterId)
            ->where('target_type', $type->value)
            ->where('target_id', $targetId)
            ->first();
    }
}
