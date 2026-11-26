<?php

declare(strict_types=1);

namespace App\Modules\Auth\Http\Resources;

use App\Modules\Auth\DTOs\IssuedToken;
use App\Support\Time\Iso8601;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * @property IssuedToken $resource
 */
final class AuthTokenResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'token' => $this->resource->plainTextToken,
            'token_type' => 'Bearer',
            'expires_at' => Iso8601::format($this->resource->expiresAt),
            'account' => new AccountResource($this->resource->user),
        ];
    }
}
