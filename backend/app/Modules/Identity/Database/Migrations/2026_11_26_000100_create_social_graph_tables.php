<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Follows and blocks between ANONYMOUS PROFILES (FR-COM-006, FR-COM-009) — never between
 * accounts, so the social graph can't be tied to real identities.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('profile_follows', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('follower_profile_id')->constrained('anonymous_profiles')->cascadeOnDelete();
            $table->foreignUuid('followed_profile_id')->constrained('anonymous_profiles')->cascadeOnDelete();
            $table->timestampTz('created_at');

            $table->unique(['follower_profile_id', 'followed_profile_id']);
            $table->index(['followed_profile_id', 'created_at']);
            $table->index(['follower_profile_id', 'created_at']);
        });

        DB::statement('ALTER TABLE profile_follows ADD CONSTRAINT profile_follows_not_self CHECK (follower_profile_id <> followed_profile_id)');

        Schema::create('profile_blocks', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('blocker_profile_id')->constrained('anonymous_profiles')->cascadeOnDelete();
            $table->foreignUuid('blocked_profile_id')->constrained('anonymous_profiles')->cascadeOnDelete();
            $table->timestampTz('created_at');

            $table->unique(['blocker_profile_id', 'blocked_profile_id']);
            $table->index(['blocked_profile_id']);
            $table->index(['blocker_profile_id', 'created_at']);
        });

        DB::statement('ALTER TABLE profile_blocks ADD CONSTRAINT profile_blocks_not_self CHECK (blocker_profile_id <> blocked_profile_id)');

        // Username search (FR-COM-008).
        DB::statement('CREATE INDEX anonymous_profiles_username_trgm ON anonymous_profiles USING gin (lower(username) gin_trgm_ops)');
    }

    public function down(): void
    {
        DB::statement('DROP INDEX IF EXISTS anonymous_profiles_username_trgm');
        Schema::dropIfExists('profile_blocks');
        Schema::dropIfExists('profile_follows');
    }
};
