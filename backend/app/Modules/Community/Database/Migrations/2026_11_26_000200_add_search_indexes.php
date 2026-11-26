<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

/**
 * Substring search over post text and hashtags (FR-COM-008). Requires pg_trgm.
 */
return new class extends Migration
{
    public function up(): void
    {
        DB::statement('CREATE INDEX posts_content_trgm ON posts USING gin (content gin_trgm_ops)');
        DB::statement('CREATE INDEX hashtags_name_trgm ON hashtags USING gin (name gin_trgm_ops)');
    }

    public function down(): void
    {
        DB::statement('DROP INDEX IF EXISTS hashtags_name_trgm');
        DB::statement('DROP INDEX IF EXISTS posts_content_trgm');
    }
};
