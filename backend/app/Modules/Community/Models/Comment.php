<?php

declare(strict_types=1);

namespace App\Modules\Community\Models;

use App\Modules\Community\Database\Factories\CommentFactory;
use App\Modules\Community\Enums\ModerationStatus;
use App\Modules\Identity\Models\AnonymousProfile;
use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * Comment on a post (FR-COM-004). One level of threading: `parent_id` is null for
 * top-level comments and points at a top-level comment for replies.
 *
 * @property string $id
 * @property string $post_id
 * @property string $author_profile_id
 * @property string|null $parent_id
 * @property string $content
 * @property ModerationStatus $moderation_status
 * @property CarbonImmutable|null $edited_at
 * @property CarbonImmutable $created_at
 * @property CarbonImmutable $updated_at
 * @property CarbonImmutable|null $deleted_at
 * @property int|null $replies_count
 * @property-read Post $post
 * @property-read AnonymousProfile $author
 * @property-read Comment|null $parent
 */
#[Fillable(['post_id', 'author_profile_id', 'parent_id', 'content'])]
class Comment extends Model
{
    /** @use HasFactory<CommentFactory> */
    use HasFactory;

    use HasUuids;
    use SoftDeletes;

    /** @var array<string, mixed> */
    protected $attributes = [
        'moderation_status' => 'visible',
    ];

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'moderation_status' => ModerationStatus::class,
            'edited_at' => 'immutable_datetime',
            'replies_count' => 'integer',
        ];
    }

    /**
     * @return BelongsTo<Post, $this>
     */
    public function post(): BelongsTo
    {
        return $this->belongsTo(Post::class);
    }

    /**
     * @return BelongsTo<AnonymousProfile, $this>
     */
    public function author(): BelongsTo
    {
        return $this->belongsTo(AnonymousProfile::class, 'author_profile_id');
    }

    /**
     * @return BelongsTo<Comment, $this>
     */
    public function parent(): BelongsTo
    {
        return $this->belongsTo(self::class, 'parent_id')->withTrashed();
    }

    /**
     * @return HasMany<Comment, $this>
     */
    public function replies(): HasMany
    {
        return $this->hasMany(self::class, 'parent_id');
    }

    /**
     * Set by listings when the author is hidden from the viewer by a block (FR-COM-009);
     * such a comment renders as a placeholder. Not a database column.
     */
    public bool $authorHiddenFromViewer = false;

    /**
     * Comments the viewer may read: not deleted, not by a member hidden from the viewer
     * by a block, and visible — or the viewer's own comment that moderation hasn't
     * removed. Explicit `deleted_at` check so the scope also holds on `withTrashed()`.
     *
     * @param  Builder<self>  $query
     * @param  list<string>  $hiddenProfileIds
     * @return Builder<self>
     */
    public function scopeVisibleTo(Builder $query, ?string $viewerProfileId, array $hiddenProfileIds = []): Builder
    {
        $column = fn (string $name): string => $query->getModel()->qualifyColumn($name);

        if ($hiddenProfileIds !== []) {
            $query->whereNotIn($column('author_profile_id'), $hiddenProfileIds);
        }

        return $query->whereNull($column('deleted_at'))
            ->where(function (Builder $q) use ($viewerProfileId, $column): void {
                $q->where($column('moderation_status'), ModerationStatus::Visible->value);

                if ($viewerProfileId !== null) {
                    $q->orWhere(function (Builder $own) use ($viewerProfileId, $column): void {
                        $own->where($column('author_profile_id'), $viewerProfileId)
                            ->where($column('moderation_status'), '!=', ModerationStatus::Removed->value);
                    });
                }
            });
    }

    /**
     * @param  list<string>  $hiddenProfileIds
     */
    public function isVisibleTo(?string $viewerProfileId, array $hiddenProfileIds = []): bool
    {
        if ($this->deleted_at !== null || $this->authorHiddenFromViewer
            || in_array($this->author_profile_id, $hiddenProfileIds, true)) {
            return false;
        }

        return $this->moderation_status === ModerationStatus::Visible
            || ($this->isAuthoredBy($viewerProfileId) && $this->moderation_status !== ModerationStatus::Removed);
    }

    public function isAuthoredBy(?string $profileId): bool
    {
        return $profileId !== null && $this->author_profile_id === $profileId;
    }

    public function isTopLevel(): bool
    {
        return $this->parent_id === null;
    }

    protected static function newFactory(): CommentFactory
    {
        return CommentFactory::new();
    }
}
