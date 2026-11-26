<?php

declare(strict_types=1);

use Illuminate\Support\Facades\DB;

it('reports healthy when database and redis are reachable', function (): void {
    $this->getJson('/api/v1/health')
        ->assertOk()
        ->assertExactJson([
            'success' => true,
            'message' => 'Service is healthy.',
            'data' => ['status' => 'ok'],
        ]);
});

it('reports degraded with 503 when the database is unreachable, without leaking error details', function (): void {
    DB::shouldReceive('select')->andThrow(new RuntimeException('SQLSTATE secret connection details'));

    $response = $this->getJson('/api/v1/health');

    $response->assertStatus(503)
        ->assertExactJson([
            'success' => false,
            'message' => 'Service is degraded.',
            'errors' => ['database' => ['Unavailable.']],
        ]);

    expect($response->getContent())->not->toContain('SQLSTATE');
});

it('uses PostgreSQL and UTC in the test environment', function (): void {
    expect(DB::connection()->getDriverName())->toBe('pgsql')
        ->and(config('app.timezone'))->toBe('UTC');
});
