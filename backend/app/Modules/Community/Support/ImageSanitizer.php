<?php

declare(strict_types=1);

namespace App\Modules\Community\Support;

use GdImage;
use RuntimeException;

/**
 * Re-encodes an uploaded image so nothing but pixels survives: EXIF (GPS location,
 * device model, timestamps), ICC/XMP blocks and any appended payload are dropped.
 * This matters for anonymity — a photo's metadata can identify its author.
 */
final class ImageSanitizer
{
    public const int MAX_DIMENSION = 2048;

    private const int JPEG_QUALITY = 82;

    /**
     * @return array{bytes: string, mime: string, extension: string, width: int, height: int}
     */
    public function sanitize(string $sourcePath): array
    {
        $data = file_get_contents($sourcePath);
        $info = $data === false ? false : getimagesizefromstring($data);
        if ($data === false || $info === false) {
            throw new RuntimeException('Unreadable image.');
        }

        $image = imagecreatefromstring($data);
        if (! $image instanceof GdImage) {
            throw new RuntimeException('Unsupported image.');
        }

        $image = $this->applyExifOrientation($image, $sourcePath, $info[2]);
        $image = $this->downscale($image);

        $hasAlpha = $info[2] === IMAGETYPE_PNG || $info[2] === IMAGETYPE_WEBP;

        ob_start();
        if ($hasAlpha) {
            imagesavealpha($image, true);
            imagewebp($image, null, self::JPEG_QUALITY);
            $mime = 'image/webp';
            $extension = 'webp';
        } else {
            imageinterlace($image, true);
            imagejpeg($image, null, self::JPEG_QUALITY);
            $mime = 'image/jpeg';
            $extension = 'jpg';
        }
        $bytes = (string) ob_get_clean();

        $result = [
            'bytes' => $bytes,
            'mime' => $mime,
            'extension' => $extension,
            'width' => imagesx($image),
            'height' => imagesy($image),
        ];

        imagedestroy($image);

        return $result;
    }

    private function downscale(GdImage $image): GdImage
    {
        $width = imagesx($image);
        $height = imagesy($image);
        $longest = max($width, $height);

        if ($longest <= self::MAX_DIMENSION) {
            return $image;
        }

        $ratio = self::MAX_DIMENSION / $longest;
        $scaled = imagescale($image, max(1, (int) round($width * $ratio)), max(1, (int) round($height * $ratio)));

        return $scaled instanceof GdImage ? $scaled : $image;
    }

    /**
     * Phones store rotation in EXIF; since EXIF is removed, bake the rotation into pixels.
     */
    private function applyExifOrientation(GdImage $image, string $path, int $type): GdImage
    {
        if ($type !== IMAGETYPE_JPEG || ! function_exists('exif_read_data')) {
            return $image;
        }

        $exif = @exif_read_data($path);
        $orientation = is_array($exif) && isset($exif['Orientation']) ? (int) $exif['Orientation'] : 1;

        $rotated = match ($orientation) {
            3 => imagerotate($image, 180, 0),
            6 => imagerotate($image, -90, 0),
            8 => imagerotate($image, 90, 0),
            default => $image,
        };

        return $rotated instanceof GdImage ? $rotated : $image;
    }
}
