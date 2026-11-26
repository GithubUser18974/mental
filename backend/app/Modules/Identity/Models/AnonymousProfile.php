<?php

declare(strict_types=1);

namespace App\Modules\Identity\Models;

use App\Modules\Auth\Enums\AccountStatus;
use App\Modules\Auth\Models\User;
use App\Modules\Identity\Database\Factories\AnonymousProfileFactory;
use App\Modules\Identity\Support\UsernamePolicy;
use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * Public pseudonymous identity (FR-AUTH-002). Its `id` is what other members see —
 * `user_id` must never leave the server in public responses.
 *
 * @property string $id
 * @property string $user_id
 * @property string $username
 * @property string $avatar
 * @property string|null $bio
 * @property CarbonImmutable|null $setup_completed_at
 * @property CarbonImmutable|null $username_changed_at
 * @property CarbonImmutable $created_at
 * @property CarbonImmutable $updated_at
 * @property-read User $user
 */
#[Fillable(['user_id', 'username', 'avatar', 'bio'])]
class AnonymousProfile extends Model
{
    /** @use HasFactory<AnonymousProfileFactory> */
    use HasFactory;

    use HasUuids;

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'setup_completed_at' => 'immutable_datetime',
            'username_changed_at' => 'immutable_datetime',
        ];
    }

    /**
     * @return BelongsTo<User, $this>
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Profiles of active accounts only — suspended / deactivated members disappear from
     * every community surface, exactly like unknown profiles.
     *
     * @param  Builder<self>  $query
     * @return Builder<self>
     */
    public function scopeActive(Builder $query): Builder
    {
        return $query->whereHas('user', static fn (Builder $q) => $q->where('status', AccountStatus::Active->value));
    }

    /**
     * Case-insensitive username match.
     *
     * @param  Builder<self>  $query
     * @return Builder<self>
     */
    public function scopeWithUsername(Builder $query, string $username): Builder
    {
        return $query->whereRaw('lower(username) = ?', [mb_strtolower($username)]);
    }

    /**
     * When the username may next be changed, or null if it can be changed now.
     * The first change during onboarding (before setup is complete) is always free.
     */
    public function usernameChangeAvailableAt(): ?CarbonImmutable
    {
        if ($this->setup_completed_at === null || $this->username_changed_at === null) {
            return null;
        }

        $next = $this->username_changed_at->addDays(UsernamePolicy::CHANGE_COOLDOWN_DAYS);

        return $next->isFuture() ? $next : null;
    }

    protected static function newFactory(): AnonymousProfileFactory
    {
        return AnonymousProfileFactory::new();
    }
}
