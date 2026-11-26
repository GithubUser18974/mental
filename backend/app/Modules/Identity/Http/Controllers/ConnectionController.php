<?php

declare(strict_types=1);

namespace App\Modules\Identity\Http\Controllers;

use App\Modules\Identity\Actions\ManageConnection;
use App\Modules\Identity\Models\AnonymousProfile;
use App\Modules\Identity\Support\CurrentProfile;
use App\Support\Http\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

/**
 * POST|DELETE /profiles/{profile}/follow and /profiles/{profile}/block (SRS §8).
 * `{profile}` is the anonymous profile id; unknown or inactive → 404.
 */
final class ConnectionController
{
    public function __construct(private readonly CurrentProfile $current, private readonly ManageConnection $connections) {}

    public function follow(Request $request, AnonymousProfile $profile): Response
    {
        $this->connections->follow($this->current->require($request->user()), $profile);

        return ApiResponse::noContent();
    }

    public function unfollow(Request $request, AnonymousProfile $profile): Response
    {
        $this->connections->unfollow($this->current->require($request->user()), $profile);

        return ApiResponse::noContent();
    }

    public function block(Request $request, AnonymousProfile $profile): Response
    {
        $this->connections->block($this->current->require($request->user()), $profile);

        return ApiResponse::noContent();
    }

    public function unblock(Request $request, AnonymousProfile $profile): Response
    {
        $this->connections->unblock($this->current->require($request->user()), $profile);

        return ApiResponse::noContent();
    }
}
