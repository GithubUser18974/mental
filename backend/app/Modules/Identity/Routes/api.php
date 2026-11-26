<?php

declare(strict_types=1);

use App\Modules\Auth\Http\Middleware\EnsureAccountIsActive;
use App\Modules\Identity\Http\Controllers\AvatarOptionsController;
use App\Modules\Identity\Http\Controllers\ConnectionController;
use App\Modules\Identity\Http\Controllers\ConnectionListController;
use App\Modules\Identity\Http\Controllers\SearchProfilesController;
use App\Modules\Identity\Http\Controllers\ShowOwnProfileController;
use App\Modules\Identity\Http\Controllers\ShowPublicProfileController;
use App\Modules\Identity\Http\Controllers\UpdatePreferencesController;
use App\Modules\Identity\Http\Controllers\UpdatePrivacyController;
use App\Modules\Identity\Http\Controllers\UpdateProfileController;
use App\Modules\Identity\Http\Controllers\UsernameAvailabilityController;
use App\Modules\Identity\Http\Controllers\UsernameSuggestionsController;
use Illuminate\Support\Facades\Route;

Route::middleware(['auth:sanctum', EnsureAccountIsActive::ALIAS])->group(function (): void {
    // Own profile & settings.
    Route::prefix('profile')->name('profile.')->group(function (): void {
        Route::get('/', ShowOwnProfileController::class)->name('show');
        Route::put('/', UpdateProfileController::class)->middleware('throttle:writes')->name('update');
        Route::put('preferences', UpdatePreferencesController::class)->name('preferences.update');
        Route::put('privacy', UpdatePrivacyController::class)->name('privacy.update');

        Route::middleware('throttle:username-checks')->group(function (): void {
            Route::get('username-availability', UsernameAvailabilityController::class)->name('username-availability');
            Route::get('username-suggestions', UsernameSuggestionsController::class)->name('username-suggestions');
        });

        Route::get('avatar-options', AvatarOptionsController::class)->name('avatar-options');
    });

    // My own connections (only I can see these lists).
    Route::get('profile/followers', [ConnectionListController::class, 'followers'])->name('profile.followers');
    Route::get('profile/following', [ConnectionListController::class, 'following'])->name('profile.following');
    Route::get('profile/blocks', [ConnectionListController::class, 'blocked'])->name('profile.blocks');

    // Follow / block by anonymous profile id (FR-COM-006, FR-COM-009).
    Route::middleware('throttle:reactions')->group(function (): void {
        Route::post('profiles/{profile}/follow', [ConnectionController::class, 'follow'])->name('profiles.follow');
        Route::delete('profiles/{profile}/follow', [ConnectionController::class, 'unfollow'])->name('profiles.unfollow');
        Route::post('profiles/{profile}/block', [ConnectionController::class, 'block'])->name('profiles.block');
        Route::delete('profiles/{profile}/block', [ConnectionController::class, 'unblock'])->name('profiles.unblock');
    });

    Route::get('search/profiles', SearchProfilesController::class)->middleware('throttle:search')->name('search.profiles');

    // Other members' public profiles.
    Route::get('profiles/{username}', ShowPublicProfileController::class)
        ->where('username', '[A-Za-z0-9_]{1,50}')
        ->name('profiles.show');
});
