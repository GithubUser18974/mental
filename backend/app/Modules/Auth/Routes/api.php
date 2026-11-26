<?php

declare(strict_types=1);

use App\Modules\Auth\Http\Controllers\ForgotPasswordController;
use App\Modules\Auth\Http\Controllers\LoginController;
use App\Modules\Auth\Http\Controllers\LogoutAllDevicesController;
use App\Modules\Auth\Http\Controllers\LogoutController;
use App\Modules\Auth\Http\Controllers\MeController;
use App\Modules\Auth\Http\Controllers\RefreshTokenController;
use App\Modules\Auth\Http\Controllers\RegisterController;
use App\Modules\Auth\Http\Controllers\ResetPasswordController;
use App\Modules\Auth\Http\Middleware\EnsureAccountIsActive;
use Illuminate\Support\Facades\Route;

Route::prefix('auth')->name('auth.')->group(function (): void {
    // Public — brute-force protected (FR-AUTH-003).
    Route::middleware('throttle:auth')->group(function (): void {
        Route::post('register', RegisterController::class)->name('register');
        Route::post('login', LoginController::class)->name('login');
    });

    Route::middleware('throttle:password-reset')->group(function (): void {
        Route::post('forgot-password', ForgotPasswordController::class)->name('forgot-password');
        Route::post('reset-password', ResetPasswordController::class)->name('reset-password');
    });

    // Authenticated.
    Route::middleware(['auth:sanctum', EnsureAccountIsActive::ALIAS])->group(function (): void {
        Route::get('me', MeController::class)->name('me');
        Route::post('refresh', RefreshTokenController::class)->name('refresh');
        Route::post('logout', LogoutController::class)->name('logout');
        Route::post('logout-all', LogoutAllDevicesController::class)->name('logout-all');
    });
});
