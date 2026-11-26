<?php

declare(strict_types=1);

use App\Modules\Auth\Http\Middleware\EnsureAccountIsActive;
use App\Modules\Moderation\Http\Controllers\ReportController;
use Illuminate\Support\Facades\Route;

Route::middleware(['auth:sanctum', EnsureAccountIsActive::ALIAS])->group(function (): void {
    // Member reports (FR-COM-010). Moderator routes arrive with T8.1 in their own group.
    Route::post('reports', [ReportController::class, 'store'])->middleware('throttle:reports')->name('reports.store');
    Route::get('reports', [ReportController::class, 'index'])->name('reports.index');
});
