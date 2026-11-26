<?php

declare(strict_types=1);

namespace App\Modules\Auth\Http\Requests;

use App\Modules\Auth\Http\Requests\Concerns\NormalizesEmail;
use App\Support\Translation\Message;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;
use Illuminate\Validation\Rules\Password;

final class RegisterRequest extends FormRequest
{
    use NormalizesEmail;

    public function authorize(): bool
    {
        return true;
    }

    /**
     * @return array<string, list<string|ValidationRule|\Illuminate\Contracts\Validation\Rule|object>>
     */
    public function rules(): array
    {
        return [
            'email' => ['required', 'string', 'email:rfc', 'max:254', Rule::unique('users', 'email')],
            'password' => ['required', 'string', 'max:128', 'confirmed', Password::defaults()],
            'age_confirmed' => ['accepted'],   // BR-001: 18+
            'terms_accepted' => ['accepted'],  // terms of use + privacy policy
            'device_name' => ['sometimes', 'nullable', 'string', 'max:100'],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'age_confirmed.accepted' => Message::get('auth::messages.age_required'),
            'terms_accepted.accepted' => Message::get('auth::messages.terms_required'),
        ];
    }

    public function password(): string
    {
        return $this->string('password')->toString();
    }
}
