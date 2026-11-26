<?php

declare(strict_types=1);

namespace App\Modules\Community\Models;

use Carbon\CarbonImmutable;
use DateTimeInterface;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

/**
 * An uploaded, sanitized post image. Stored privately; clients get short-lived signed URLs.
 *
 * @property string $id
 * @property string $uploader_profile_id
 * @property string|null $post_id
 * @property string $disk
 * @property string $path
 * @property string $mime
 * @property int $width
 * @property int $height
 * @property int $size_bytes
 * @property int $position
 * @property CarbonImmutable $created_at
 * @property CarbonImmutable $updated_at
 */
#[Fillable(['uploader_profile_id', 'post_id', 'disk', 'path', 'mime', 'width', 'height', 'size_bytes', 'position'])]
class PostMedia extends Model
{
    use HasUuids;

    public const int URL_TTL_MINUTES = 30;

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'width' => 'integer',
            'height' => 'integer',
            'size_bytes' => 'integer',
            'position' => 'integer',
        ];
    }

    public function temporaryUrl(?DateTimeInterface $expiresAt = null): string
    {
        return Storage::disk($this->disk)->temporaryUrl(
            $this->path,
            $expiresAt ?? now()->addMinutes(self::URL_TTL_MINUTES),
        );
    }
}
