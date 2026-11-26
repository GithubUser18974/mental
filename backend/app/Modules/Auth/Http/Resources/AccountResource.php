<?php

declare(strict_types=1);

namespace App\Modules\Auth\Http\Resources;

use App\Modules\Auth\Models\User;
use App\Support\Time\Iso8601;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * The signed-in user's OWN private account data. Only ever returned to the owner
 * (auth endpoints) — never embed in community/public resources.
 *
 * @mixin User
 */
final class AccountResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        /** @var User $user */
        $user = $this->resource;

        return [
            'id' => $user->id,
            'email' => $user->email,
            'email_verified' => $user->email_verified_at !== null,
            'status' => $user->status->value,
            'created_at' => Iso8601::format($user->created_at),
        ];
    }
}
