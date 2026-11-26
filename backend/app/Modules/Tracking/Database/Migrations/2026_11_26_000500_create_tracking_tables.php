<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

/**
 * Private mental-health tracking (SRS §4.5, §7.3): check-ins (mood + optional scales),
 * symptoms, sleep, and computed insights.
 *
 * Owned by the ACCOUNT (`users`), never by the anonymous profile — community code can't
 * reach these tables (arch-tested). Free-text notes are encrypted at rest (app-level).
 * Deleting an entry removes it for good (no soft delete for private health data).
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('mood_entries', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('user_id')->constrained('users')->cascadeOnDelete();
            $table->string('mood', 16);
            $table->unsignedTinyInteger('score')->nullable();
            $table->unsignedTinyInteger('anxiety')->nullable();
            $table->unsignedTinyInteger('stress')->nullable();
            $table->unsignedTinyInteger('energy')->nullable();
            $table->text('notes')->nullable(); // encrypted
            $table->timestampTz('recorded_at');
            $table->timestampsTz();

            $table->index(['user_id', 'recorded_at']);
        });

        DB::statement("ALTER TABLE mood_entries ADD CONSTRAINT mood_entries_mood_valid CHECK (mood IN ('very_sad', 'sad', 'neutral', 'good', 'very_good'))");
        foreach (['score', 'anxiety', 'stress', 'energy'] as $scale) {
            DB::statement("ALTER TABLE mood_entries ADD CONSTRAINT mood_entries_{$scale}_range CHECK ({$scale} IS NULL OR {$scale} BETWEEN 1 AND 10)");
        }

        // Admin-configurable list (FR-TRACK-003); managed in the admin panel (T9).
        Schema::create('symptom_categories', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->string('slug', 50)->unique();
            $table->string('name_en', 80);
            $table->string('name_ar', 80);
            $table->string('icon', 40);
            $table->unsignedSmallInteger('sort_order')->default(0);
            $table->boolean('is_active')->default(true)->index();
            $table->timestampsTz();
        });

        Schema::create('symptom_entries', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('user_id')->constrained('users')->cascadeOnDelete();
            $table->foreignUuid('category_id')->constrained('symptom_categories')->restrictOnDelete();
            $table->unsignedTinyInteger('severity');
            $table->unsignedInteger('duration_minutes')->nullable();
            $table->text('notes')->nullable(); // encrypted
            $table->timestampTz('recorded_at');
            $table->timestampsTz();

            $table->index(['user_id', 'recorded_at']);
            $table->index(['user_id', 'category_id']);
        });

        DB::statement('ALTER TABLE symptom_entries ADD CONSTRAINT symptom_entries_severity_range CHECK (severity BETWEEN 1 AND 10)');

        Schema::create('sleep_entries', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('user_id')->constrained('users')->cascadeOnDelete();
            $table->unsignedSmallInteger('duration_minutes');
            $table->unsignedTinyInteger('quality')->nullable();
            // When the member woke up — the night is attributed to that day.
            $table->timestampTz('recorded_at');
            $table->timestampsTz();

            $table->index(['user_id', 'recorded_at']);
        });

        DB::statement('ALTER TABLE sleep_entries ADD CONSTRAINT sleep_entries_quality_range CHECK (quality IS NULL OR quality BETWEEN 1 AND 10)');
        DB::statement('ALTER TABLE sleep_entries ADD CONSTRAINT sleep_entries_duration_range CHECK (duration_minutes BETWEEN 1 AND 1440)');

        // Latest computed insights per account (encrypted payload; recomputed by a job).
        Schema::create('tracking_insights', function (Blueprint $table): void {
            $table->foreignUuid('user_id')->primary()->constrained('users')->cascadeOnDelete();
            $table->text('items'); // encrypted JSON
            $table->timestampTz('computed_at');
        });

        $this->seedSymptomCategories();
    }

    public function down(): void
    {
        Schema::dropIfExists('tracking_insights');
        Schema::dropIfExists('sleep_entries');
        Schema::dropIfExists('symptom_entries');
        Schema::dropIfExists('symptom_categories');
        Schema::dropIfExists('mood_entries');
    }

    /**
     * FR-TRACK-003 example symptoms (reference data; admins manage them afterwards).
     */
    private function seedSymptomCategories(): void
    {
        $now = now();
        $categories = [
            ['anxiety', 'Anxiety', 'القلق', 'psychology_alt'],
            ['low-energy', 'Low energy', 'انخفاض الطاقة', 'battery_2_bar'],
            ['difficulty-concentrating', 'Difficulty concentrating', 'صعوبة التركيز', 'center_focus_weak'],
            ['irritability', 'Irritability', 'سرعة الانفعال', 'bolt'],
            ['sleep-disturbances', 'Sleep disturbances', 'اضطرابات النوم', 'bedtime'],
            ['loss-of-motivation', 'Loss of motivation', 'فقدان الحافز', 'trending_down'],
            ['restlessness', 'Restlessness', 'التململ', 'directions_run'],
            ['sadness', 'Sadness', 'الحزن', 'water_drop'],
        ];

        foreach ($categories as $order => [$slug, $en, $ar, $icon]) {
            DB::table('symptom_categories')->insert([
                'id' => (string) Str::uuid7(),
                'slug' => $slug,
                'name_en' => $en,
                'name_ar' => $ar,
                'icon' => $icon,
                'sort_order' => $order + 1,
                'is_active' => true,
                'created_at' => $now,
                'updated_at' => $now,
            ]);
        }
    }
};
