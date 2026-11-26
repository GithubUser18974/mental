<?php

declare(strict_types=1);

namespace App\Modules\Community\Http\Controllers;

use App\Modules\Community\Http\Requests\UpdateInterestsRequest;
use App\Modules\Community\Http\Resources\CategoryResource;
use App\Modules\Community\Models\PostCategory;
use App\Modules\Community\Support\ViewerProfile;
use App\Support\Http\ApiResponse;
use App\Support\Translation\Message;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/**
 * The member's topics of interest (FR-ONB-002) — categories they want to see more of.
 */
final class InterestsController
{
    public function __construct(private readonly ViewerProfile $viewer) {}

    public function show(Request $request): JsonResponse
    {
        return ApiResponse::success(CategoryResource::collection($this->interests($request)));
    }

    public function update(UpdateInterestsRequest $request): JsonResponse
    {
        $profile = $this->viewer->require($request->user());
        $ids = PostCategory::query()->whereIn('slug', $request->slugs())->pluck('id');

        DB::transaction(static function () use ($profile, $ids): void {
            DB::table('profile_interests')->where('anonymous_profile_id', $profile->id)->delete();
            DB::table('profile_interests')->insert(
                $ids->map(static fn (string $id): array => [
                    'anonymous_profile_id' => $profile->id,
                    'category_id' => $id,
                ])->all(),
            );
        });

        return ApiResponse::success(
            CategoryResource::collection($this->interests($request)),
            Message::get('community::messages.interests_updated'),
        );
    }

    /**
     * @return \Illuminate\Database\Eloquent\Collection<int, PostCategory>
     */
    private function interests(Request $request): \Illuminate\Database\Eloquent\Collection
    {
        $profile = $this->viewer->require($request->user());

        return PostCategory::query()
            ->active()
            ->whereIn('id', DB::table('profile_interests')
                ->where('anonymous_profile_id', $profile->id)
                ->select('category_id'))
            ->get();
    }
}
