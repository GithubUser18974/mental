<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

/**
 * Community posts (SRS §7.2, FR-COM-001/002/003).
 *
 * Posts reference the AUTHOR'S ANONYMOUS PROFILE, never `users` — community data must
 * not be linkable to the account identity through the community schema.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('post_categories', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->string('slug', 50)->unique();
            $table->string('name_en', 80);
            $table->string('name_ar', 80);
            $table->string('description_en', 255);
            $table->string('description_ar', 255);
            $table->string('icon', 40);
            $table->unsignedSmallInteger('sort_order')->default(0);
            $table->boolean('is_active')->default(true)->index();
            $table->timestampsTz();
        });

        Schema::create('profile_interests', function (Blueprint $table): void {
            $table->foreignUuid('anonymous_profile_id')->constrained('anonymous_profiles')->cascadeOnDelete();
            $table->foreignUuid('category_id')->constrained('post_categories')->cascadeOnDelete();
            $table->primary(['anonymous_profile_id', 'category_id']);
        });

        Schema::create('posts', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('author_profile_id')->constrained('anonymous_profiles')->cascadeOnDelete();
            $table->foreignUuid('category_id')->constrained('post_categories')->restrictOnDelete();
            $table->text('content');
            $table->string('content_warning', 32)->nullable();
            $table->boolean('allow_comments')->default(true);
            $table->string('visibility', 16)->default('community');
            $table->string('moderation_status', 16)->default('visible');
            // Engagement score for the "popular" feed; maintained by reactions/comments (T2.2).
            $table->unsignedInteger('score')->default(0);
            $table->timestampTz('edited_at')->nullable();
            $table->timestampsTz();
            // Soft delete: removed from every public endpoint, kept for moderation/retention (BR-014).
            $table->softDeletesTz();

            $table->index(['author_profile_id', 'created_at']);
            $table->index(['category_id', 'created_at']);
            $table->index(['visibility', 'moderation_status', 'created_at']);
            $table->index(['score', 'created_at']);
        });

        DB::statement("ALTER TABLE posts ADD CONSTRAINT posts_visibility_valid CHECK (visibility IN ('community', 'only_me'))");
        DB::statement("ALTER TABLE posts ADD CONSTRAINT posts_moderation_status_valid CHECK (moderation_status IN ('visible', 'under_review', 'hidden', 'removed'))");

        Schema::create('post_media', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('uploader_profile_id')->constrained('anonymous_profiles')->cascadeOnDelete();
            $table->foreignUuid('post_id')->nullable()->constrained('posts')->nullOnDelete();
            $table->string('disk', 32);
            $table->string('path');
            $table->string('mime', 32);
            $table->unsignedInteger('width');
            $table->unsignedInteger('height');
            $table->unsignedInteger('size_bytes');
            $table->unsignedTinyInteger('position')->default(0);
            $table->timestampsTz();

            $table->index(['post_id', 'position']);
            $table->index(['uploader_profile_id', 'post_id']);
        });

        Schema::create('hashtags', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->string('name', 50)->unique(); // stored normalized (lowercase), without '#'
            $table->timestampsTz();
        });

        Schema::create('post_hashtags', function (Blueprint $table): void {
            $table->foreignUuid('post_id')->constrained('posts')->cascadeOnDelete();
            $table->foreignUuid('hashtag_id')->constrained('hashtags')->cascadeOnDelete();
            $table->primary(['post_id', 'hashtag_id']);
            $table->index('hashtag_id');
        });

        $this->seedInitialCategories();
    }

    public function down(): void
    {
        Schema::dropIfExists('post_hashtags');
        Schema::dropIfExists('hashtags');
        Schema::dropIfExists('post_media');
        Schema::dropIfExists('posts');
        Schema::dropIfExists('profile_interests');
        Schema::dropIfExists('post_categories');
    }

    /**
     * FR-COM-003 initial categories (reference data every environment needs).
     * Admins manage them afterwards (T9).
     */
    private function seedInitialCategories(): void
    {
        $now = now();
        $categories = [
            ['my-story', 'My Story', 'قصتي', 'Personal mental health experiences', 'تجارب شخصية في الصحة النفسية', 'auto_stories'],
            ['need-support', 'Need Support', 'أحتاج دعمًا', 'Seeking emotional support', 'طلب الدعم العاطفي', 'volunteer_activism'],
            ['daily-thoughts', 'Daily Thoughts', 'أفكار يومية', 'Sharing daily feelings', 'مشاركة المشاعر اليومية', 'wb_sunny'],
            ['medication-experience', 'Medication Experience', 'تجربة مع الدواء', 'Personal medication experiences', 'تجارب شخصية مع الأدوية', 'medication'],
            ['recovery-journey', 'Recovery Journey', 'رحلة التعافي', 'Sharing personal progress', 'مشاركة التقدم الشخصي', 'trending_up'],
            ['questions', 'Questions', 'أسئلة', 'Asking community questions', 'طرح الأسئلة على المجتمع', 'help_outline'],
            ['mental-wellness', 'Mental Wellness', 'العافية النفسية', 'General wellness discussions', 'نقاشات عامة حول العافية', 'self_improvement'],
        ];

        foreach ($categories as $order => [$slug, $nameEn, $nameAr, $descEn, $descAr, $icon]) {
            DB::table('post_categories')->insert([
                'id' => (string) Str::uuid7(),
                'slug' => $slug,
                'name_en' => $nameEn,
                'name_ar' => $nameAr,
                'description_en' => $descEn,
                'description_ar' => $descAr,
                'icon' => $icon,
                'sort_order' => $order + 1,
                'is_active' => true,
                'created_at' => $now,
                'updated_at' => $now,
            ]);
        }
    }
};
