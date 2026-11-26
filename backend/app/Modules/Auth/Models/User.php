<?php

declare(strict_types=1);

namespace App\Modules\Auth\Models;

use App\Modules\Auth\Database\Factories\UserFactory;
use App\Modules\Auth\Enums\AccountStatus;
use App\Modules\Auth\Notifications\ResetPasswordNotification;
use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Attributes\Hidden;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use SensitiveParameter;

/**
 * Authentication identity (private). NEVER serialize into community/public responses —
 * public identity is the anonymous profile (Identity module).
 *
 * @property string $id
 * @property string $email
 * @property string|null $phone
 * @property string $password
 * @property AccountStatus $status
 * @property CarbonImmutable|null $email_verified_at
 * @property CarbonImmutable $age_confirmed_at
 * @property CarbonImmutable $terms_accepted_at
 * @property CarbonImmutable|null $last_login_at
 * @property CarbonImmutable $created_at
 * @property CarbonImmutable $updated_at
 */
#[Fillable(['email', 'password', 'status', 'age_confirmed_at', 'terms_accepted_at'])]
#[Hidden(['password', 'remember_token'])]
class User extends Authenticatable
{
    use HasApiTokens;

    /** @use HasFactory<UserFactory> */
    use HasFactory;

    use HasUuids;
    use Notifiable;

    /** @var array<string, mixed> */
    protected $attributes = [
        'status' => 'active',
    ];

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'password' => 'hashed',
            'status' => AccountStatus::class,
            'email_verified_at' => 'immutable_datetime',
            'age_confirmed_at' => 'immutable_datetime',
            'terms_accepted_at' => 'immutable_datetime',
            'last_login_at' => 'immutable_datetime',
        ];
    }

    /**
     * Localized, queued reset email that deep-links into the app.
     *
     * @param  string  $token
     */
    public function sendPasswordResetNotification(#[SensitiveParameter] $token): void
    {
        $this->notify((new ResetPasswordNotification($token))->locale(app()->getLocale()));
    }

    protected static function newFactory(): UserFactory
    {
        return UserFactory::new();
    }
}
