<?php

declare(strict_types=1);

namespace App\Modules\Community\Actions;

use App\Modules\Community\Models\PostMedia;
use App\Modules\Community\Support\ImageSanitizer;
use App\Modules\Identity\Models\AnonymousProfile;
use App\Support\Translation\Message;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;
use RuntimeException;

/**
 * Sanitizes (re-encodes, strips metadata) and stores a post image. The image is
 * unattached until a post claims it; unclaimed uploads are pruned after a day.
 */
final readonly class StorePostMedia
{
    public function __construct(private ImageSanitizer $sanitizer) {}

    public function __invoke(AnonymousProfile $uploader, UploadedFile $file): PostMedia
    {
        try {
            $image = $this->sanitizer->sanitize($file->getRealPath() ?: $file->getPathname());
        } catch (RuntimeException) {
            throw ValidationException::withMessages([
                'image' => [Message::get('community::messages.image_unreadable')],
            ]);
        }

        $disk = self::disk();
        $path = sprintf('post-media/%s/%s.%s', now()->format('Y/m'), Str::uuid7(), $image['extension']);
        Storage::disk($disk)->put($path, $image['bytes'], ['visibility' => 'private']);

        return PostMedia::query()->create([
            'uploader_profile_id' => $uploader->id,
            'disk' => $disk,
            'path' => $path,
            'mime' => $image['mime'],
            'width' => $image['width'],
            'height' => $image['height'],
            'size_bytes' => strlen($image['bytes']),
        ]);
    }

    public static function disk(): string
    {
        $disk = config('filesystems.media_disk');

        return is_string($disk) && $disk !== '' ? $disk : 'local';
    }
}
