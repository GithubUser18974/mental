<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Private medication records (SRS §4.6, §7.4). Member-maintained, NOT prescriptions.
 *
 * Owned by the account (`users`). Names, dosages, instructions, clinician, notes and
 * experience text are encrypted at rest (app-level), so they can't be searched or
 * sorted in SQL. Deleting removes everything for good.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('medications', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('user_id')->constrained('users')->cascadeOnDelete();
            $table->text('name');          // encrypted
            $table->text('dosage');        // encrypted (e.g. "50", "0.5")
            $table->string('unit', 16);
            $table->date('start_date');
            $table->date('end_date')->nullable();
            $table->text('instructions')->nullable(); // encrypted
            $table->text('clinician')->nullable();    // encrypted
            $table->text('notes')->nullable();        // encrypted
            $table->boolean('reminders_enabled')->default(true);
            $table->string('status', 16)->default('active');
            $table->timestampTz('discontinued_at')->nullable();
            $table->timestampsTz();

            $table->index(['user_id', 'status']);
        });

        DB::statement("ALTER TABLE medications ADD CONSTRAINT medications_status_valid CHECK (status IN ('active', 'paused', 'discontinued'))");
        DB::statement("ALTER TABLE medications ADD CONSTRAINT medications_unit_valid CHECK (unit IN ('mg', 'mcg', 'g', 'ml', 'drops', 'tablet', 'capsule', 'puff', 'patch', 'unit', 'other'))");
        DB::statement('ALTER TABLE medications ADD CONSTRAINT medications_dates_valid CHECK (end_date IS NULL OR end_date >= start_date)');

        // One schedule per medication (FR-MED-002). Times are local wall-clock "HH:MM" in
        // the member's CURRENT timezone, so reminders follow travel and DST changes.
        Schema::create('medication_schedules', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('medication_id')->unique()->constrained('medications')->cascadeOnDelete();
            $table->string('type', 16);
            $table->jsonb('times');                      // ["08:00", "20:00"]
            $table->jsonb('days_of_week')->nullable();   // ISO 1 (Mon) … 7 (Sun), for `weekly`
            $table->unsignedSmallInteger('interval_days')->nullable(); // for `interval`
            $table->timestampsTz();
        });

        DB::statement("ALTER TABLE medication_schedules ADD CONSTRAINT medication_schedules_type_valid CHECK (type IN ('daily', 'weekly', 'interval', 'as_needed'))");

        Schema::create('medication_logs', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('medication_id')->constrained('medications')->cascadeOnDelete();
            $table->foreignUuid('user_id')->constrained('users')->cascadeOnDelete();
            $table->timestampTz('scheduled_at')->nullable(); // null for as-needed doses
            $table->timestampTz('taken_at')->nullable();
            $table->string('status', 16);
            $table->text('notes')->nullable(); // encrypted
            $table->timestampsTz();

            $table->index(['medication_id', 'scheduled_at']);
            $table->index(['user_id', 'created_at']);
        });

        DB::statement("ALTER TABLE medication_logs ADD CONSTRAINT medication_logs_status_valid CHECK (status IN ('taken', 'skipped', 'missed', 'delayed'))");
        // One record per scheduled dose — logging the same dose again updates it.
        DB::statement('CREATE UNIQUE INDEX medication_logs_one_per_dose ON medication_logs (medication_id, scheduled_at) WHERE scheduled_at IS NOT NULL');

        Schema::create('medication_experiences', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('medication_id')->constrained('medications')->cascadeOnDelete();
            $table->foreignUuid('user_id')->constrained('users')->cascadeOnDelete();
            $table->string('kind', 16);
            $table->text('description'); // encrypted
            $table->date('observed_on');
            $table->timestampsTz();

            $table->index(['medication_id', 'observed_on']);
        });

        DB::statement("ALTER TABLE medication_experiences ADD CONSTRAINT medication_experiences_kind_valid CHECK (kind IN ('benefit', 'side_effect', 'change', 'general'))");
    }

    public function down(): void
    {
        Schema::dropIfExists('medication_experiences');
        Schema::dropIfExists('medication_logs');
        Schema::dropIfExists('medication_schedules');
        Schema::dropIfExists('medications');
    }
};
