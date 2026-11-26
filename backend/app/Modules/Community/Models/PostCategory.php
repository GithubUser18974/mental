<?php

declare(strict_types=1);

namespace App\Modules\Community\Models;

use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;

/**
 * FR-COM-003 post category (admin-managed; seeded with the SRS list).
 *
 * @property string $id
 * @property string $slug
 * @property string $name_en
 * @property string $name_ar
 * @property string $description_en
 * @property string $description_ar
 * @property string $icon
 * @property int $sort_order
 * @property bool $is_active
 * @property CarbonImmutable $created_at
 * @property CarbonImmutable $updated_at
 */
#[Fillable(['slug', 'name_en', 'name_ar', 'description_en', 'description_ar', 'icon', 'sort_order', 'is_active'])]
class PostCategory extends Model
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
        return app()->getLocale() === 'ar' ? $this->name_ar : $this->name_en;
    }

    public function localizedDescription(): string
    {
        return app()->getLocale() === 'ar' ? $this->description_ar : $this->description_en;
    }
}
