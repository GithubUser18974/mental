<?php

declare(strict_types=1);

namespace App\Modules\Identity\Models;

use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;

/**
 * Private per-user settings. `language` is used for server-generated content
 * (emails, push notifications); `timezone` for displaying dates and scheduling
 * reminders in the user's local time.
 *
 * @property string $id
 * @property string $user_id
 * @property string $language
 * @property string $timezone
 * @property CarbonImmutable $created_at
 * @property CarbonImmutable $updated_at
 */
#[Fillable(['user_id', 'language', 'timezone'])]
class UserPreference extends Model
{
    use HasUuids;

    /** @var array<string, mixed> */
    protected $attributes = [
        'language' => 'en',
        'timezone' => 'UTC',
    ];
}
