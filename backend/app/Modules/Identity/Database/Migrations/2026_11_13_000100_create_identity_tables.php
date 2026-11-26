<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Public anonymous identity + per-user settings (SRS §7.1, FR-AUTH-002, FR-ONB-002/003).
 *
 * `anonymous_profiles.id` is the ONLY identifier other members ever see; it is
 * deliberately a different UUID from `users.id`.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('anonymous_profiles', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('user_id')->unique()->constrained('users')->cascadeOnDelete();
            $table->string('username', 20);
            $table->string('avatar', 40);
            $table->string('bio', 300)->nullable();
            $table->timestampTz('setup_completed_at')->nullable();
            $table->timestampTz('username_changed_at')->nullable();
            $table->timestampsTz();
        });

        // Usernames are unique case-insensitively but keep the user's chosen casing.
        DB::statement('CREATE UNIQUE INDEX anonymous_profiles_username_lower_unique ON anonymous_profiles (lower(username))');

        Schema::create('user_preferences', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('user_id')->unique()->constrained('users')->cascadeOnDelete();
            $table->string('language', 5)->default('en');
            $table->string('timezone', 64)->default('UTC');
            $table->timestampsTz();
        });

        DB::statement("ALTER TABLE user_preferences ADD CONSTRAINT user_preferences_language_valid CHECK (language IN ('en', 'ar'))");

        Schema::create('user_privacy_settings', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('user_id')->unique()->constrained('users')->cascadeOnDelete();
            $table->string('profile_visibility', 16)->default('public');
            $table->string('follow_policy', 16)->default('everyone');
            $table->boolean('analytics_consent')->default(false); // optional processing: off by default
            $table->timestampsTz();
        });

        DB::statement("ALTER TABLE user_privacy_settings ADD CONSTRAINT user_privacy_visibility_valid CHECK (profile_visibility IN ('public', 'private'))");
        DB::statement("ALTER TABLE user_privacy_settings ADD CONSTRAINT user_privacy_follow_policy_valid CHECK (follow_policy IN ('everyone', 'nobody'))");
    }

    public function down(): void
    {
        Schema::dropIfExists('user_privacy_settings');
        Schema::dropIfExists('user_preferences');
        Schema::dropIfExists('anonymous_profiles');
    }
};
