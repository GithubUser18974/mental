<?php

declare(strict_types=1);

namespace App\Support\Logging;

use Illuminate\Database\QueryException;
use Monolog\LogRecord;
use Monolog\Processor\ProcessorInterface;
use PDOException;

/**
 * Removes credentials, personal identifiers and health data from log context.
 *
 * Privacy rule: no health data, tokens or PII in logs. Logging code should not
 * put such data in context in the first place — this is the safety net.
 */
final class RedactingProcessor implements ProcessorInterface
{
    public const string REDACTED = '[REDACTED]';

    private const int MAX_DEPTH = 8;

    /** Keys redacted when they CONTAIN one of these fragments (case-insensitive). */
    private const array SENSITIVE_FRAGMENTS = [
        'password', 'token', 'secret', 'authorization', 'cookie', 'api_key', 'apikey', 'otp',
    ];

    /** Keys redacted on exact match (case-insensitive): PII and health/journal fields. */
    private const array SENSITIVE_KEYS = [
        // identity
        'email', 'phone', 'phone_number', 'name', 'first_name', 'last_name', 'birth_date', 'date_of_birth',
        // free text that may contain anything personal
        'content', 'body', 'title', 'bio', 'description', 'notes', 'note', 'message_body', 'payload',
        // health & medication
        'mood', 'score', 'severity', 'symptom', 'symptoms', 'sleep', 'quality', 'duration',
        'medication', 'medication_name', 'dosage', 'unit', 'schedule_data', 'experience',
        // journal
        'journal', 'journal_entry', 'tags',
    ];

    public function __invoke(LogRecord $record): LogRecord
    {
        $context = $this->redact($record->context);
        $message = $record->message;

        // report($e) uses the exception message as the log message — replace it too.
        $original = $record->context['exception'] ?? null;
        if ($original instanceof PDOException) {
            $message = $this->sanitizedMessage($original);
        }

        return $record->with(
            message: $message,
            context: $context,
            extra: $this->redact($record->extra),
        );
    }

    /**
     * @param  array<array-key, mixed>  $data
     * @return array<array-key, mixed>
     */
    public function redact(array $data, int $depth = 0): array
    {
        foreach ($data as $key => $value) {
            if (is_string($key) && $this->isSensitive($key)) {
                $data[$key] = self::REDACTED;

                continue;
            }

            // QueryException extends PDOException.
            if ($value instanceof PDOException) {
                $data[$key] = $this->sanitizeDatabaseException($value);

                continue;
            }

            if (is_array($value)) {
                $data[$key] = $depth >= self::MAX_DEPTH ? self::REDACTED : $this->redact($value, $depth + 1);
            }
        }

        return $data;
    }

    private function isSensitive(string $key): bool
    {
        $key = strtolower($key);

        if (in_array($key, self::SENSITIVE_KEYS, true)) {
            return true;
        }

        foreach (self::SENSITIVE_FRAGMENTS as $fragment) {
            if (str_contains($key, $fragment)) {
                return true;
            }
        }

        return false;
    }

    /**
     * Database exception messages embed bound values (and PostgreSQL echoes row values on
     * constraint violations). Keep class, location, SQL with placeholders, SQLSTATE and the
     * trace (safe: `zend.exception_ignore_args=On` strips call arguments).
     *
     * @return array{class: class-string, message: string, file: string, line: int, trace: string}
     */
    private function sanitizeDatabaseException(PDOException $e): array
    {
        return [
            'class' => $e::class,
            'message' => $this->sanitizedMessage($e),
            'file' => $e->getFile(),
            'line' => $e->getLine(),
            'trace' => $e->getTraceAsString(),
        ];
    }

    private function sanitizedMessage(PDOException $e): string
    {
        $sqlState = is_string($e->errorInfo[0] ?? null) ? $e->errorInfo[0] : (string) $e->getCode();

        if ($e instanceof QueryException) {
            return sprintf(
                'Database query failed [SQLSTATE %s] on connection [%s]: %s',
                $sqlState,
                $e->getConnectionName(),
                $e->getSql(),
            );
        }

        return sprintf('Database error [SQLSTATE %s]', $sqlState);
    }
}
