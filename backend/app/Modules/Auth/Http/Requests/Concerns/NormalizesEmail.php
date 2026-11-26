<?php

declare(strict_types=1);

namespace App\Modules\Auth\Http\Requests\Concerns;

/**
 * Emails are case-insensitive: trim + lowercase before validation and lookup.
 */
trait NormalizesEmail
{
    protected function prepareForValidation(): void
    {
        $email = $this->input('email');

        if (is_string($email)) {
            $this->merge(['email' => mb_strtolower(trim($email))]);
        }
    }

    public function email(): string
    {
        return $this->string('email')->toString();
    }

    public function deviceName(): ?string
    {
        $name = $this->input('device_name');

        return is_string($name) ? $name : null;
    }
}
