<?php

declare(strict_types=1);

namespace App\Modules\Auth\Http\Requests;

use App\Modules\Auth\Http\Requests\Concerns\NormalizesEmail;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rules\Password;

final class ResetPasswordRequest extends FormRequest
{
    use NormalizesEmail;

    public function authorize(): bool
    {
        return true;
    }

    /**
     * @return array<string, list<string|ValidationRule|object>>
     */
    public function rules(): array
    {
        return [
            'email' => ['required', 'string', 'email:rfc', 'max:254'],
            'token' => ['required', 'string', 'max:255'],
            'password' => ['required', 'string', 'max:128', 'confirmed', Password::defaults()],
        ];
    }

    public function token(): string
    {
        return $this->string('token')->toString();
    }

    public function password(): string
    {
        return $this->string('password')->toString();
    }
}
