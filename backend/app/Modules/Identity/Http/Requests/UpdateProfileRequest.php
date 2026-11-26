<?php

declare(strict_types=1);

namespace App\Modules\Identity\Http\Requests;

use App\Modules\Identity\Models\AnonymousProfile;
use App\Modules\Identity\Rules\ValidUsername;
use App\Modules\Identity\Support\AvatarCatalog;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

/**
 * Partial update: send only the fields being changed.
 */
final class UpdateProfileRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /** The caller's own profile id — their current username doesn't count as "taken". */
    private function ownProfileId(): ?string
    {
        $userId = $this->user()?->getAuthIdentifier();

        $id = AnonymousProfile::query()->where('user_id', $userId)->value('id');

        return is_string($id) ? $id : null;
    }

    protected function prepareForValidation(): void
    {
        $data = [];

        if (is_string($this->input('username'))) {
            $data['username'] = trim($this->string('username')->toString());
        }

        if ($this->has('bio')) {
            $bio = is_string($this->input('bio')) ? trim($this->string('bio')->toString()) : null;
            $data['bio'] = $bio === '' ? null : $bio;
        }

        $this->merge($data);
    }

    /**
     * @return array<string, list<mixed>>
     */
    public function rules(): array
    {
        return [
            'username' => ['sometimes', 'required', 'string', new ValidUsername(true, $this->ownProfileId())],
            'avatar' => ['sometimes', 'required', 'string', Rule::in(AvatarCatalog::all())],
            'bio' => ['sometimes', 'nullable', 'string', 'max:300'],
        ];
    }

    /**
     * @return array{username?: string, avatar?: string, bio?: string|null}
     */
    public function changes(): array
    {
        /** @var array{username?: string, avatar?: string, bio?: string|null} $validated */
        $validated = $this->safe()->only(['username', 'avatar', 'bio']);

        return $validated;
    }
}
