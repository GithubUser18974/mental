<?php

declare(strict_types=1);

namespace App\Modules\Community\Models;

use App\Modules\Community\Database\Factories\SavedPostFactory;
use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * Private bookmark (FR-COM-007). Only ever readable by the member who saved it.
 *
 * @property string $id
 * @property string $profile_id
 * @property string $post_id
 * @property CarbonImmutable $created_at
 */
#[Fillable(['profile_id', 'post_id'])]
class SavedPost extends Model
{
    /** @use HasFactory<SavedPostFactory> */
    use HasFactory;

    use HasUuids;

    public const null UPDATED_AT = null;

    /**
     * @return BelongsTo<Post, $this>
     */
    public function post(): BelongsTo
    {
        return $this->belongsTo(Post::class);
    }

    protected static function newFactory(): SavedPostFactory
    {
        return SavedPostFactory::new();
    }
}
