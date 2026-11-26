<?php

declare(strict_types=1);

namespace App\Modules\Tracking;

use App\Support\Modules\ModuleServiceProvider as BaseModuleServiceProvider;

/**
 * Private mental-health tracking: check-ins, symptoms, sleep, overview and insights
 * (SRS §4.5, FR-PROGRESS-001). Health data — owner-only, notes encrypted, never logged,
 * never reachable from community code (arch-tested).
 */
final class ModuleServiceProvider extends BaseModuleServiceProvider {}
