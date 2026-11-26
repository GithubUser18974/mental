<?php

declare(strict_types=1);

namespace App\Modules\Tracking\Models;

use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Model;

/**
 * Latest computed insights for an account. `items` is an encrypted list of
 * `{key, params}` — rendered into the reader's language at response time.
 *
 * @property string $user_id
 * @property list<array{key: string, params: array<string, string|int|float>}> $items
 * @property CarbonImmutable $computed_at
 */
class TrackingInsight extends Model
{
    public $incrementing = false;

    public $timestamps = false;

    protected $primaryKey = 'user_id';

    protected $keyType = 'string';

    /** @var list<string> */
    protected $fillable = ['user_id', 'items', 'computed_at'];

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'items' => 'encrypted:array',
            'computed_at' => 'immutable_datetime',
        ];
    }
}
