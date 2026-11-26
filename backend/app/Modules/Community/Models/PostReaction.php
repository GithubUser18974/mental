<?php

declare(strict_types=1);

namespace App\Modules\Community\Models;

use App\Modules\Community\Database\Factories\PostReactionFactory;
use App\Modules\Community\Enums\ReactionType;
use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * A member's single supportive reaction on a post (FR-COM-005). Who reacted is never
 * exposed by the API, only per-type counts and the viewer's own reaction.
 *
 * @property string $id
 * @property string $post_id
 * @property string $profile_id
 * @property ReactionType $type
 * @property CarbonImmutable $created_at
 * @property CarbonImmutable $updated_at
 */
#[Fillable(['post_id', 'profile_id', 'type'])]
class PostReaction extends Model
{
    /** @use HasFactory<PostReactionFactory> */
    use HasFactory;

    use HasUuids;

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return ['type' => ReactionType::class];
    }

    /**
     * @return BelongsTo<Post, $this>
     */
    public function post(): BelongsTo
    {
        return $this->belongsTo(Post::class);
    }

    protected static function newFactory(): PostReactionFactory
    {
        return PostReactionFactory::new();
    }
}
