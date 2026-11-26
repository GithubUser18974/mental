<?php

declare(strict_types=1);

namespace App\Modules\Medication;

use App\Support\Modules\ModuleServiceProvider as BaseModuleServiceProvider;

/**
 * Private medication management (SRS §4.6): member-maintained records (never
 * prescriptions), schedules, intake logs, experiences, dose expansion for reminders.
 * Health data — owner-only, encrypted, never logged, unreachable from community code.
 */
final class ModuleServiceProvider extends BaseModuleServiceProvider {}
