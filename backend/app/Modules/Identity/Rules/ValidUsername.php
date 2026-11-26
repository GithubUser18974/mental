<?php

declare(strict_types=1);

namespace App\Modules\Identity\Rules;

use App\Modules\Identity\Support\UsernamePolicy;
use App\Support\Translation\Message;
use Closure;
use Illuminate\Contracts\Validation\ValidationRule;

/**
 * Format + reserved-name check. Pass `$exceptProfileId` to also require availability.
 */
final readonly class ValidUsername implements ValidationRule
{
    public function __construct(private bool $checkAvailability = true, private ?string $exceptProfileId = null) {}

    public function validate(string $attribute, mixed $value, Closure $fail): void
    {
        if (! is_string($value) || ! UsernamePolicy::isWellFormed($value)) {
            $fail(Message::get('identity::messages.username_format'));

            return;
        }

        if (UsernamePolicy::isReserved($value)) {
            $fail(Message::get('identity::messages.username_reserved'));

            return;
        }

        if ($this->checkAvailability && UsernamePolicy::isTaken($value, $this->exceptProfileId)) {
            $fail(Message::get('identity::messages.username_taken'));
        }
    }
}
