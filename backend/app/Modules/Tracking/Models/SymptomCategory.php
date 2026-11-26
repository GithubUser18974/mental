<?php

declare(strict_types=1);

namespace App\Modules\Tracking\Models;

use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\App;

/**
 * Admin-configurable symptom type (FR-TRACK-003). Reference data seeded by migration.
 *
 * @property string $id
 * @property string $slug
 * @property string $name_en
 * @property string $name_ar
 * @property string $icon
 * @property int $sort_order
 * @property bool $is_active
 * @property CarbonImmutable $created_at
 * @property CarbonImmutable $updated_at
 */
class SymptomCategory extends Model
{
    use HasUuids;

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return ['is_active' => 'boolean', 'sort_order' => 'integer'];
    }

    /**
     * @param  Builder<self>  $query
     * @return Builder<self>
     */
    public function scopeActive(Builder $query): Builder
    {
        return $query->where('is_active', true)->orderBy('sort_order');
    }

    public function localizedName(): string
    {
        return App::getLocale() === 'ar' ? $this->name_ar : $this->name_en;
    }
}
