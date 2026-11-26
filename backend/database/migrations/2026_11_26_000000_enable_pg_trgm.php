<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

/**
 * Trigram indexes power substring search (usernames, hashtags, post text — FR-COM-008)
 * for both Latin and Arabic text. pg_trgm ships with PostgreSQL (contrib).
 */
return new class extends Migration
{
    public function up(): void
    {
        DB::statement('CREATE EXTENSION IF NOT EXISTS pg_trgm');
    }

    public function down(): void
    {
        // Left installed: other objects may depend on it.
    }
};
