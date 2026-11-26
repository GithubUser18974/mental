<?php

declare(strict_types=1);

use App\Modules\Identity\Models\AnonymousProfile;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/*
| Feature tests run against the PostgreSQL `mental_test` database (never SQLite —
| behaviour differs) and are wrapped in RefreshDatabase.
| Module tests live in tests/Feature/<Module> and tests/Unit/<Module>.
*/

pest()->extend(TestCase::class)
    ->use(RefreshDatabase::class)
    ->in('Feature');

/**
 * The auth guard caches the resolved user for the lifetime of the test's app instance.
 * Call between requests that should be authenticated independently (e.g. after logout).
 */
function forgetAuth(): void
{
    app('auth')->forgetGuards();
}

/**
 * Act as the account behind an anonymous profile (resets the cached guard first).
 */
function actAs(AnonymousProfile $profile): AnonymousProfile
{
    forgetAuth();
    Sanctum::actingAs($profile->user);

    return $profile;
}
