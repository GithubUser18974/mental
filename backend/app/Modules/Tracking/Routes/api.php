<?php

declare(strict_types=1);

use App\Modules\Auth\Http\Middleware\EnsureAccountIsActive;
use App\Modules\Tracking\Http\Controllers\MoodEntryController;
use App\Modules\Tracking\Http\Controllers\SleepEntryController;
use App\Modules\Tracking\Http\Controllers\SymptomEntryController;
use App\Modules\Tracking\Http\Controllers\TrackingSummaryController;
use Illuminate\Support\Facades\Route;

/*
| Private mental-health tracking (SRS §8.5). Owner-only: there is no route through which
| anyone — moderators and admins included — can read another member's entries.
*/
Route::middleware(['auth:sanctum', EnsureAccountIsActive::ALIAS])
    ->prefix('tracking')
    ->name('tracking.')
    ->group(function (): void {
        Route::get('overview', [TrackingSummaryController::class, 'overview'])->name('overview');
        Route::get('insights', [TrackingSummaryController::class, 'insights'])->name('insights');
        Route::get('symptom-categories', [TrackingSummaryController::class, 'symptomCategories'])->name('symptom-categories');

        $resources = [
            'moods' => MoodEntryController::class,
            'symptoms' => SymptomEntryController::class,
            'sleep' => SleepEntryController::class,
        ];

        foreach ($resources as $path => $controller) {
            Route::get($path, [$controller, 'index'])->name("{$path}.index");
            Route::post($path, [$controller, 'store'])->middleware('throttle:tracking')->name("{$path}.store");
            Route::get("{$path}/{id}", [$controller, 'show'])->whereUuid('id')->name("{$path}.show");
            Route::put("{$path}/{id}", [$controller, 'update'])->whereUuid('id')->middleware('throttle:tracking')->name("{$path}.update");
            Route::delete("{$path}/{id}", [$controller, 'destroy'])->whereUuid('id')->name("{$path}.destroy");
        }
    });
