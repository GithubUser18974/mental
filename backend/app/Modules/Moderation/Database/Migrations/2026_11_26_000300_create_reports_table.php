<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Member reports (FR-COM-010) feeding the moderation queue (FR-SAFETY-003, SRS §5.3).
 *
 * Polymorphic target (post / comment / profile) by id with no foreign key: a report must
 * survive the target being deleted (retention, BR-014). People are referenced by
 * anonymous profile. Reporter identity is never shown to the reported member.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('reports', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('reporter_profile_id')->constrained('anonymous_profiles')->cascadeOnDelete();
            $table->string('target_type', 16);
            $table->uuid('target_id');
            // Author of the reported content (or the reported profile) at report time.
            $table->foreignUuid('target_owner_profile_id')->nullable()->constrained('anonymous_profiles')->nullOnDelete();
            $table->string('reason', 32);
            $table->text('details')->nullable();
            $table->string('status', 16)->default('open');
            $table->unsignedTinyInteger('priority');
            // Filled by moderators (T8.1): decision, moderator, action date, reason, audit history.
            $table->timestampTz('resolved_at')->nullable();
            $table->timestampsTz();

            $table->index(['status', 'priority', 'created_at']);
            $table->index(['target_type', 'target_id']);
            $table->index(['reporter_profile_id', 'created_at']);
            $table->index('target_owner_profile_id');
        });

        DB::statement("ALTER TABLE reports ADD CONSTRAINT reports_target_type_valid CHECK (target_type IN ('post', 'comment', 'profile'))");
        DB::statement("ALTER TABLE reports ADD CONSTRAINT reports_reason_valid CHECK (reason IN ('harassment', 'dangerous_medical_advice', 'spam', 'self_harm_encouragement', 'suicidal_content', 'other'))");
        DB::statement("ALTER TABLE reports ADD CONSTRAINT reports_status_valid CHECK (status IN ('open', 'reviewing', 'actioned', 'dismissed'))");
        DB::statement('ALTER TABLE reports ADD CONSTRAINT reports_priority_valid CHECK (priority BETWEEN 1 AND 3)');
        // One pending report per member per target (repeat taps don't flood the queue).
        DB::statement("CREATE UNIQUE INDEX reports_one_pending_per_reporter ON reports (reporter_profile_id, target_type, target_id) WHERE status IN ('open', 'reviewing')");
    }

    public function down(): void
    {
        Schema::dropIfExists('reports');
    }
};
