<?php

declare(strict_types=1);

namespace App\Modules\Community\Models;

use App\Modules\Community\Database\Factories\PostFactory;
use App\Modules\Community\Enums\ContentWarning;
use App\Modules\Community\Enums\ModerationStatus;
use App\Modules\Community\Enums\PostVisibility;
use App\Modules\Community\Enums\ReactionType;
use App\Modules\Identity\Models\AnonymousProfile;
use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * Community post (FR-COM-002). Authored by an anonymous profile.
 *
 * @property string $id
 * @property string $author_profile_id
 * @property string $category_id
 * @property string $content
 * @property ContentWarning|null $content_warning
 * @property bool $allow_comments
 * @property PostVisibility $visibility
 * @property ModerationStatus $moderation_status
 * @property int $score
 * @property CarbonImmutable|null $edited_at
 * @property CarbonImmutable $created_at
 * @property CarbonImmutable $updated_at
 * @property CarbonImmutable|null $deleted_at
 * @property int|null $comments_count
 * @property-read AnonymousProfile $author
 * @property-read PostCategory $category
 * @property-read Collection<int, PostMedia> $media
 * @property-read Collection<int, Hashtag> $hashtags
 */
#[Fillable(['author_profile_id', 'category_id', 'content', 'content_warning', 'allow_comments', 'visibility'])]
class Post extends Model
{
    /** @use HasFactory<PostFactory> */
    use HasFactory;

    use HasUuids;
    use SoftDeletes;

    /** @var array<string, mixed> */
    protected $attributes = [
        'allow_comments' => true,
        'visibility' => 'community',
        'moderation_status' => 'visible',
        'score' => 0,
    ];

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'content_warning' => ContentWarning::class,
            'allow_comments' => 'boolean',
            'visibility' => PostVisibility::class,
            'moderation_status' => ModerationStatus::class,
            'score' => 'integer',
            'edited_at' => 'immutable_datetime',
        ];
    }

    /**
     * @return BelongsTo<AnonymousProfile, $this>
     */
    public function author(): BelongsTo
    {
        return $this->belongsTo(AnonymousProfile::class, 'author_profile_id');
    }

    /**
     * @return BelongsTo<PostCategory, $this>
     */
    public function category(): BelongsTo
    {
        return $this->belongsTo(PostCategory::class);
    }

    /**
     * @return HasMany<PostMedia, $this>
     */
    public function media(): HasMany
    {
        return $this->hasMany(PostMedia::class)->orderBy('position');
    }

    /**
     * @return BelongsToMany<Hashtag, $this>
     */
    public function hashtags(): BelongsToMany
    {
        return $this->belongsToMany(Hashtag::class, 'post_hashtags')->orderBy('name');
    }

    /**
     * @return HasMany<Comment, $this>
     */
    public function comments(): HasMany
    {
        return $this->hasMany(Comment::class);
    }

    /**
     * @return HasMany<PostReaction, $this>
     */
    public function reactions(): HasMany
    {
        return $this->hasMany(PostReaction::class);
    }

    /**
     * @return HasMany<SavedPost, $this>
     */
    public function saves(): HasMany
    {
        return $this->hasMany(SavedPost::class);
    }

    /**
     * Adds engagement data in the same query (no N+1): visible comment count, a count per
     * reaction type, and — for a viewer — their own reaction and whether they saved it.
     * Read back through {@see reactionCounts()}, {@see viewerReaction()}, {@see isSavedByViewer()}.
     *
     * @param  Builder<self>  $query
     * @return Builder<self>
     */
    public function scopeWithEngagement(Builder $query, ?string $viewerProfileId): Builder
    {
        $counts = [
            'comments as comments_count' => static fn (Builder $q) => $q->where('comments.moderation_status', ModerationStatus::Visible->value),
        ];
        foreach (ReactionType::cases() as $type) {
            $counts['reactions as reactions_'.$type->value.'_count'] = static fn (Builder $q) => $q->where('post_reactions.type', $type->value);
        }

        $query->withCount($counts);

        if ($viewerProfileId !== null) {
            $query->addSelect([
                'viewer_reaction' => PostReaction::query()
                    ->select('type')
                    ->whereColumn('post_reactions.post_id', 'posts.id')
                    ->where('profile_id', $viewerProfileId)
                    ->limit(1),
            ])->withExists([
                'saves as viewer_saved' => static fn (Builder $q) => $q->where('saved_posts.profile_id', $viewerProfileId),
            ]);
        }

        return $query;
    }

    /**
     * @return array<string, int> reaction type => count (all types present)
     */
    public function reactionCounts(): array
    {
        $counts = [];
        foreach (ReactionType::cases() as $type) {
            $counts[$type->value] = (int) $this->getAttribute('reactions_'.$type->value.'_count');
        }

        return $counts;
    }

    public function viewerReaction(): ?ReactionType
    {
        $value = $this->getAttribute('viewer_reaction');

        return is_string($value) ? ReactionType::tryFrom($value) : null;
    }

    public function isSavedByViewer(): bool
    {
        return (bool) $this->getAttribute('viewer_saved');
    }

    /**
     * Posts other members may see: community-visible and not moderated away.
     * (Soft-deleted posts are already excluded by the SoftDeletes scope.)
     *
     * @param  Builder<self>  $query
     * @return Builder<self>
     */
    public function scopePubliclyVisible(Builder $query): Builder
    {
        return $query
            ->where('visibility', PostVisibility::Community->value)
            ->where('moderation_status', ModerationStatus::Visible->value);
    }

    /**
     * Visible to the given viewer: public posts, plus all of the viewer's own posts
     * that moderation hasn't removed.
     *
     * @param  Builder<self>  $query
     * @return Builder<self>
     */
    public function scopeVisibleTo(Builder $query, ?string $viewerProfileId): Builder
    {
        return $query->where(function (Builder $q) use ($viewerProfileId): void {
            $q->publiclyVisible();

            if ($viewerProfileId !== null) {
                $q->orWhere(function (Builder $own) use ($viewerProfileId): void {
                    $own->where('author_profile_id', $viewerProfileId)
                        ->where('moderation_status', '!=', ModerationStatus::Removed->value);
                });
            }
        });
    }

    public function isAuthoredBy(?string $profileId): bool
    {
        return $profileId !== null && $this->author_profile_id === $profileId;
    }

    protected static function newFactory(): PostFactory
    {
        return PostFactory::new();
    }
}
