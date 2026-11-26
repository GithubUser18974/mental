<?php

declare(strict_types=1);

namespace App\Modules\Identity\Http\Requests;

use App\Modules\Identity\Enums\FollowPolicy;
use App\Modules\Identity\Enums\ProfileVisibility;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

final class UpdatePrivacyRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /**
     * @return array<string, list<mixed>>
     */
    public function rules(): array
    {
        return [
            'profile_visibility' => ['sometimes', 'required', Rule::enum(ProfileVisibility::class)],
            'follow_policy' => ['sometimes', 'required', Rule::enum(FollowPolicy::class)],
            'analytics_consent' => ['sometimes', 'required', 'boolean'],
        ];
    }

    /**
     * @return array<string, mixed>
     */
    public function changes(): array
    {
        return $this->safe()->only(['profile_visibility', 'follow_policy', 'analytics_consent']);
    }
}
