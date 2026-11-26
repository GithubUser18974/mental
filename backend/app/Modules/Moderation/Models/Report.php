<?php

declare(strict_types=1);

namespace App\Modules\Moderation\Models;

use App\Modules\Identity\Models\AnonymousProfile;
use App\Modules\Moderation\Database\Factories\ReportFactory;
use App\Modules\Moderation\Enums\ReportPriority;
use App\Modules\Moderation\Enums\ReportReason;
use App\Modules\Moderation\Enums\ReportStatus;
use App\Modules\Moderation\Enums\ReportTargetType;
use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * A member's report of a post, comment or profile (FR-COM-010).
 *
 * @property string $id
 * @property string $reporter_profile_id
 * @property ReportTargetType $target_type
 * @property string $target_id
 * @property string|null $target_owner_profile_id
 * @property ReportReason $reason
 * @property string|null $details
 * @property ReportStatus $status
 * @property ReportPriority $priority
 * @property CarbonImmutable|null $resolved_at
 * @property CarbonImmutable $created_at
 * @property CarbonImmutable $updated_at
 * @property-read AnonymousProfile $reporter
 */
#[Fillable(['reporter_profile_id', 'target_type', 'target_id', 'target_owner_profile_id', 'reason', 'details', 'priority'])]
class Report extends Model
{
    /** @use HasFactory<ReportFactory> */
    use HasFactory;

    use HasUuids;

    /** @var array<string, mixed> */
    protected $attributes = [
        'status' => 'open',
    ];

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'target_type' => ReportTargetType::class,
            'reason' => ReportReason::class,
            'status' => ReportStatus::class,
            'priority' => ReportPriority::class,
            'resolved_at' => 'immutable_datetime',
        ];
    }

    /**
     * @return BelongsTo<AnonymousProfile, $this>
     */
    public function reporter(): BelongsTo
    {
        return $this->belongsTo(AnonymousProfile::class, 'reporter_profile_id');
    }

    /**
     * @param  Builder<self>  $query
     * @return Builder<self>
     */
    public function scopePending(Builder $query): Builder
    {
        return $query->whereIn('status', [ReportStatus::Open->value, ReportStatus::Reviewing->value]);
    }

    protected static function newFactory(): ReportFactory
    {
        return ReportFactory::new();
    }
}
