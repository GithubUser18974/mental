<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Comments, supportive reactions and saved posts (FR-COM-004/005/007).
 *
 * Like posts, everything references ANONYMOUS PROFILES, never `users`.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('comments', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('post_id')->constrained('posts')->cascadeOnDelete();
            $table->foreignUuid('author_profile_id')->constrained('anonymous_profiles')->cascadeOnDelete();
            // One level of threading: replies always point at a top-level comment.
            $table->uuid('parent_id')->nullable();
            $table->text('content');
            $table->string('moderation_status', 16)->default('visible');
            $table->timestampTz('edited_at')->nullable();
            $table->timestampsTz();
            $table->softDeletesTz();

            $table->index(['post_id', 'parent_id', 'created_at']);
            $table->index(['parent_id', 'created_at']);
            $table->index('author_profile_id');
        });

        // Self-reference added once the primary key exists.
        Schema::table('comments', function (Blueprint $table): void {
            $table->foreign('parent_id')->references('id')->on('comments')->cascadeOnDelete();
        });

        DB::statement("ALTER TABLE comments ADD CONSTRAINT comments_moderation_status_valid CHECK (moderation_status IN ('visible', 'under_review', 'hidden', 'removed'))");

        Schema::create('post_reactions', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('post_id')->constrained('posts')->cascadeOnDelete();
            $table->foreignUuid('profile_id')->constrained('anonymous_profiles')->cascadeOnDelete();
            $table->string('type', 16);
            $table->timestampsTz();

            // FR-COM-005: at most one active reaction per member per post.
            $table->unique(['post_id', 'profile_id']);
            $table->index(['post_id', 'type']);
            $table->index('profile_id');
        });

        DB::statement("ALTER TABLE post_reactions ADD CONSTRAINT post_reactions_type_valid CHECK (type IN ('understand', 'support', 'not_alone', 'proud', 'thank_you'))");

        // Private bookmarks (FR-COM-007) — never exposed on profiles.
        Schema::create('saved_posts', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('profile_id')->constrained('anonymous_profiles')->cascadeOnDelete();
            $table->foreignUuid('post_id')->constrained('posts')->cascadeOnDelete();
            $table->timestampTz('created_at');

            $table->unique(['profile_id', 'post_id']);
            $table->index(['profile_id', 'created_at']);
            $table->index('post_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('saved_posts');
        Schema::dropIfExists('post_reactions');
        Schema::dropIfExists('comments');
    }
};
