<?php

declare(strict_types=1);

use Illuminate\Support\Facades\Schedule;

// Remove expired API tokens and stale password reset tokens.
Schedule::command('sanctum:prune-expired --hours=24')->daily();
Schedule::command('auth:clear-resets')->hourly();

// Unattached post images (uploads never used in a post).
Schedule::command('community:prune-orphan-media')->daily();
