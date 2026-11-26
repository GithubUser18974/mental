<?php

declare(strict_types=1);

use App\Modules\Auth\Http\Middleware\EnsureAccountIsActive;
use App\Modules\Community\Http\Controllers\CategoryController;
use App\Modules\Community\Http\Controllers\CommentController;
use App\Modules\Community\Http\Controllers\CommentRepliesController;
use App\Modules\Community\Http\Controllers\FeedController;
use App\Modules\Community\Http\Controllers\HashtagController;
use App\Modules\Community\Http\Controllers\InterestsController;
use App\Modules\Community\Http\Controllers\MediaController;
use App\Modules\Community\Http\Controllers\PostController;
use App\Modules\Community\Http\Controllers\ProfilePostsController;
use App\Modules\Community\Http\Controllers\ReactionController;
use App\Modules\Community\Http\Controllers\SavedPostController;
use Illuminate\Support\Facades\Route;

// Community content is for signed-in members only (guests can't view it — SRS §3.1).
Route::middleware(['auth:sanctum', EnsureAccountIsActive::ALIAS])->group(function (): void {
    Route::get('categories', CategoryController::class)->name('categories.index');

    Route::get('profile/interests', [InterestsController::class, 'show'])->name('profile.interests.show');
    Route::put('profile/interests', [InterestsController::class, 'update'])->name('profile.interests.update');

    Route::post('media', MediaController::class)->middleware('throttle:uploads')->name('media.store');

    Route::get('posts', FeedController::class)->name('posts.index');
    Route::post('posts', [PostController::class, 'store'])->middleware('throttle:writes')->name('posts.store');
    Route::get('posts/{post}', [PostController::class, 'show'])->name('posts.show');
    Route::put('posts/{post}', [PostController::class, 'update'])->middleware('throttle:writes')->name('posts.update');
    Route::delete('posts/{post}', [PostController::class, 'destroy'])->name('posts.destroy');

    // Comments (FR-COM-004) — one level of replies.
    Route::get('posts/{post}/comments', [CommentController::class, 'index'])->name('posts.comments.index');
    Route::post('posts/{post}/comments', [CommentController::class, 'store'])->middleware('throttle:writes')->name('posts.comments.store');
    Route::get('comments/{comment}/replies', CommentRepliesController::class)->withTrashed()->name('comments.replies');
    Route::put('comments/{comment}', [CommentController::class, 'update'])->middleware('throttle:writes')->name('comments.update');
    Route::delete('comments/{comment}', [CommentController::class, 'destroy'])->name('comments.destroy');

    // Supportive reactions (FR-COM-005) — one per member per post.
    Route::post('posts/{post}/reactions', [ReactionController::class, 'store'])->middleware('throttle:reactions')->name('posts.reactions.store');
    Route::delete('posts/{post}/reactions', [ReactionController::class, 'destroy'])->middleware('throttle:reactions')->name('posts.reactions.destroy');

    // Private bookmarks (FR-COM-007).
    Route::post('posts/{post}/save', [SavedPostController::class, 'store'])->middleware('throttle:reactions')->name('posts.save');
    Route::delete('posts/{post}/save', [SavedPostController::class, 'destroy'])->middleware('throttle:reactions')->name('posts.unsave');
    Route::get('saved-posts', [SavedPostController::class, 'index'])->name('saved-posts.index');

    // Discovery (FR-COM-008). Post text search is GET /posts?q=.
    Route::get('search/hashtags', [HashtagController::class, 'search'])->middleware('throttle:search')->name('search.hashtags');
    Route::get('hashtags/trending', [HashtagController::class, 'trending'])->name('hashtags.trending');

    Route::get('profiles/{username}/posts', ProfilePostsController::class)
        ->where('username', '[A-Za-z0-9_]{1,50}')
        ->name('profiles.posts');
});
