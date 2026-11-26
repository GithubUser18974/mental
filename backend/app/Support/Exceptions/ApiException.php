<?php

declare(strict_types=1);

namespace App\Support\Exceptions;

use RuntimeException;
use Throwable;

/**
 * Base class for expected, user-facing domain errors (e.g. "account suspended").
 *
 * The message IS shown to the client, so it must be a translated, data-free sentence.
 * Never put health data, identifiers or internal details into it.
 */
class ApiException extends RuntimeException
{
    /**
     * @param  array<string, list<string>>  $errors
     */
    public function __construct(
        string $message,
        private readonly int $status = 400,
        private readonly array $errors = [],
        ?Throwable $previous = null,
    ) {
        parent::__construct($message, 0, $previous);
    }

    public function status(): int
    {
        return $this->status;
    }

    /**
     * @return array<string, list<string>>
     */
    public function errors(): array
    {
        return $this->errors;
    }
}
