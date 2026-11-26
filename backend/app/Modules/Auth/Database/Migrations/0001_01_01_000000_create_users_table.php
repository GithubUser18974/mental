<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Authentication identity (SRS §7.1 `users`). Holds NO real name and is never
 * exposed in community responses — the public identity is `anonymous_profiles` (T1.2).
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->string('email', 254)->unique();
            $table->string('phone', 32)->nullable()->unique(); // reserved for phone/OTP sign-in (later)
            $table->string('password');
            $table->string('status', 20)->default('active')->index();
            $table->timestampTz('email_verified_at')->nullable();
            $table->timestampTz('age_confirmed_at');   // BR-001 self-declared 18+
            $table->timestampTz('terms_accepted_at');  // terms + privacy policy consent
            $table->timestampTz('last_login_at')->nullable();
            $table->rememberToken();
            $table->timestampsTz();
        });

        // Defence in depth: emails are always stored normalized; status is a known value.
        DB::statement('ALTER TABLE users ADD CONSTRAINT users_email_lowercase CHECK (email = lower(email))');
        DB::statement("ALTER TABLE users ADD CONSTRAINT users_status_valid CHECK (status IN ('active', 'suspended', 'deactivated'))");

        Schema::create('password_reset_tokens', function (Blueprint $table): void {
            $table->string('email', 254)->primary();
            $table->string('token');
            $table->timestampTz('created_at')->nullable();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('password_reset_tokens');
        Schema::dropIfExists('users');
    }
};
