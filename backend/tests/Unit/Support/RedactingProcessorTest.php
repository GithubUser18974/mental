<?php

declare(strict_types=1);

use App\Support\Logging\RedactingProcessor;
use Illuminate\Database\QueryException;
use Monolog\Level;
use Monolog\LogRecord;

function logRecord(array $context, array $extra = []): LogRecord
{
    return new LogRecord(new DateTimeImmutable, 'test', Level::Info, 'message', $context, $extra);
}

it('redacts credentials, PII and health fields, keeping safe context', function (): void {
    $record = (new RedactingProcessor)(logRecord([
        'user_id' => 'abc-123',
        'request_id' => 'req-1',
        'email' => 'someone@example.com',
        'Password' => 'hunter2',
        'access_token' => 'tok',
        'headers' => ['Authorization' => 'Bearer x', 'accept' => 'application/json'],
        'entry' => ['content' => 'my private journal', 'mood' => 'sad', 'dosage' => '20mg', 'status' => 'saved'],
    ], ['ip' => '10.0.0.1', 'device_token' => 'fcm']));

    expect($record->context)->toBe([
        'user_id' => 'abc-123',
        'request_id' => 'req-1',
        'email' => RedactingProcessor::REDACTED,
        'Password' => RedactingProcessor::REDACTED,
        'access_token' => RedactingProcessor::REDACTED,
        'headers' => ['Authorization' => RedactingProcessor::REDACTED, 'accept' => 'application/json'],
        'entry' => [
            'content' => RedactingProcessor::REDACTED,
            'mood' => RedactingProcessor::REDACTED,
            'dosage' => RedactingProcessor::REDACTED,
            'status' => 'saved',
        ],
    ])->and($record->extra)->toBe(['ip' => '10.0.0.1', 'device_token' => RedactingProcessor::REDACTED]);
});

it('strips bound values from database exceptions', function (): void {
    $exception = new QueryException(
        'pgsql',
        'insert into users (email) values (?)',
        ['someone@example.com'],
        new PDOException('Key (email)=(someone@example.com) already exists.'),
    );

    // report($e) logs the exception message as the record message.
    $record = (new RedactingProcessor)(new LogRecord(
        new DateTimeImmutable, 'test', Level::Error, $exception->getMessage(), ['exception' => $exception],
    ));
    $sanitized = $record->context['exception'];

    expect($sanitized)->toBeArray()
        ->and($sanitized['class'])->toBe(QueryException::class)
        ->and($sanitized['message'])->toContain('insert into users (email) values (?)')
        ->and($sanitized['trace'])->toBeString()
        ->and(json_encode($sanitized))->not->toContain('someone@example.com')
        ->and($record->message)->not->toContain('someone@example.com')
        ->and($record->message)->toContain('values (?)');
});

it('strips row values from raw PDO exceptions', function (): void {
    $record = (new RedactingProcessor)(new LogRecord(
        new DateTimeImmutable, 'test', Level::Error, 'Key (email)=(someone@example.com) already exists.',
        ['exception' => new PDOException('Key (email)=(someone@example.com) already exists.')],
    ));

    expect($record->message)->not->toContain('someone@example.com')
        ->and($record->context['exception']['message'])->toBe('Database error [SQLSTATE 0]');
});
