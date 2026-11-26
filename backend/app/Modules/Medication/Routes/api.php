<?php

declare(strict_types=1);

use App\Modules\Auth\Http\Middleware\EnsureAccountIsActive;
use App\Modules\Medication\Http\Controllers\DoseController;
use App\Modules\Medication\Http\Controllers\MedicationController;
use App\Modules\Medication\Http\Controllers\MedicationExperienceController;
use App\Modules\Medication\Http\Controllers\MedicationLogController;
use Illuminate\Support\Facades\Route;

/*
| Private medication records (SRS §8.6). Owner-only: there is no route through which
| anyone — moderators and admins included — can read another member's medications.
*/
Route::middleware(['auth:sanctum', EnsureAccountIsActive::ALIAS])
    ->prefix('medications')
    ->name('medications.')
    ->group(function (): void {
        Route::get('doses', DoseController::class)->name('doses');

        Route::get('/', [MedicationController::class, 'index'])->name('index');
        Route::post('/', [MedicationController::class, 'store'])->middleware('throttle:tracking')->name('store');

        Route::whereUuid(['id', 'logId', 'experienceId'])->group(function (): void {
            Route::get('{id}', [MedicationController::class, 'show'])->name('show');
            Route::put('{id}', [MedicationController::class, 'update'])->middleware('throttle:tracking')->name('update');
            Route::delete('{id}', [MedicationController::class, 'destroy'])->name('destroy');

            Route::get('{id}/logs', [MedicationLogController::class, 'index'])->name('logs.index');
            Route::post('{id}/logs', [MedicationLogController::class, 'store'])->middleware('throttle:tracking')->name('logs.store');
            Route::delete('{id}/logs/{logId}', [MedicationLogController::class, 'destroy'])->name('logs.destroy');

            Route::get('{id}/experiences', [MedicationExperienceController::class, 'index'])->name('experiences.index');
            Route::post('{id}/experiences', [MedicationExperienceController::class, 'store'])->middleware('throttle:tracking')->name('experiences.store');
            Route::delete('{id}/experiences/{experienceId}', [MedicationExperienceController::class, 'destroy'])->name('experiences.destroy');
        });
    });
