<?php

declare(strict_types=1);

namespace App\Support\Logging;

use Illuminate\Log\Logger;
use Monolog\Logger as Monolog;

/**
 * Log channel "tap" that installs the {@see RedactingProcessor} on a channel.
 * Configured on every channel in config/logging.php.
 */
final class RedactSensitiveData
{
    public function __invoke(Logger $logger): void
    {
        $monolog = $logger->getLogger();

        if ($monolog instanceof Monolog) {
            $monolog->pushProcessor(new RedactingProcessor);
        }
    }
}
