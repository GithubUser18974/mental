<?php

declare(strict_types=1);

namespace App\Modules\Community\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\UploadedFile;

final class UploadMediaRequest extends FormRequest
{
    public const int MAX_KILOBYTES = 8192;

    public function authorize(): bool
    {
        return true;
    }

    /**
     * @return array<string, list<string>>
     */
    public function rules(): array
    {
        return [
            // Content sniffing (mimes) + real image check (dimensions) — not the client's filename.
            'image' => [
                'required',
                'file',
                'mimes:jpeg,jpg,png,webp',
                'max:'.self::MAX_KILOBYTES,
                'dimensions:min_width=32,min_height=32,max_width=12000,max_height=12000',
            ],
        ];
    }

    public function uploadedImage(): UploadedFile
    {
        /** @var UploadedFile $file */
        $file = $this->file('image');

        return $file;
    }
}
