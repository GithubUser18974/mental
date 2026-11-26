<?php

declare(strict_types=1);

namespace App\Modules\Moderation;

use App\Support\Modules\ModuleServiceProvider as BaseModuleServiceProvider;

/**
 * Reports and the moderation queue (FR-COM-010, FR-SAFETY-003, BR-009). Moderator roles,
 * decisions and the crisis workflow arrive with T8.1. Must never depend on Tracking,
 * Medication or Journal — moderators have no route to private health data.
 */
final class ModuleServiceProvider extends BaseModuleServiceProvider {}
