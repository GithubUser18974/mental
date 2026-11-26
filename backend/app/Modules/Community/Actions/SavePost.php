<?php

declare(strict_types=1);

namespace App\Modules\Community\Actions;

use App\Modules\Community\Models\Hashtag;
use App\Modules\Community\Models\Post;
use App\Modules\Community\Models\PostMedia;
use App\Modules\Community\Support\HashtagExtractor;
use App\Modules\Identity\Models\AnonymousProfile;
use App\Support\Translation\Message;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

/**
 * Creates or updates a post: fields, hashtags (parsed from the text) and attached images.
 */
final class SavePost
{
    public const int MAX_MEDIA = 4;

    /**
     * @param  array{category_id?: string, content?: string, content_warning?: string|null,
     *               allow_comments?: bool, visibility?: string, media_ids?: list<string>}  $data
     */
    public function create(AnonymousProfile $author, array $data): Post
    {
        return DB::transaction(function () use ($author, $data): Post {
            $post = new Post([
                'author_profile_id' => $author->id,
                'category_id' => $data['category_id'] ?? null,
                'content' => $data['content'] ?? '',
                'content_warning' => $data['content_warning'] ?? null,
                'allow_comments' => $data['allow_comments'] ?? true,
                'visibility' => $data['visibility'] ?? 'community',
            ]);
            $post->save();

            $this->syncHashtags($post);
            $this->syncMedia($post, $author, $data['media_ids'] ?? []);

            return $post;
        });
    }

    /**
     * @param  array{category_id?: string, content?: string, content_warning?: string|null,
     *               allow_comments?: bool, visibility?: string, media_ids?: list<string>}  $data
     */
    public function update(Post $post, array $data): Post
    {
        return DB::transaction(function () use ($post, $data): Post {
            $post->fill(array_intersect_key($data, array_flip([
                'category_id', 'content', 'content_warning', 'allow_comments', 'visibility',
            ])));

            if ($post->isDirty('content')) {
                $post->edited_at = CarbonImmutable::now();
            }
            $post->save();

            if (array_key_exists('content', $data)) {
                $this->syncHashtags($post);
            }
            if (array_key_exists('media_ids', $data)) {
                $this->syncMedia($post, $post->author()->firstOrFail(), $data['media_ids']);
            }

            return $post;
        });
    }

    private function syncHashtags(Post $post): void
    {
        $ids = [];
        foreach (HashtagExtractor::extract($post->content) as $name) {
            $ids[] = Hashtag::query()->firstOrCreate(['name' => $name])->id;
        }

        $post->hashtags()->sync($ids);
    }

    /**
     * Attaches exactly the given uploads (in order). Each must belong to the author and be
     * unattached or already on this post — never another member's image.
     *
     * @param  list<string>  $mediaIds
     */
    private function syncMedia(Post $post, AnonymousProfile $author, array $mediaIds): void
    {
        $mediaIds = array_values(array_unique($mediaIds));

        $media = PostMedia::query()
            ->whereIn('id', $mediaIds)
            ->where('uploader_profile_id', $author->id)
            ->where(fn ($q) => $q->whereNull('post_id')->orWhere('post_id', $post->id))
            ->lockForUpdate()
            ->get()
            ->keyBy('id');

        if ($media->count() !== count($mediaIds)) {
            throw ValidationException::withMessages([
                'media_ids' => [Message::get('community::messages.media_invalid')],
            ]);
        }

        // Detach images removed from the post (they become orphans and get pruned).
        PostMedia::query()
            ->where('post_id', $post->id)
            ->whereNotIn('id', $mediaIds)
            ->update(['post_id' => null]);

        foreach ($mediaIds as $position => $id) {
            /** @var PostMedia $item */
            $item = $media->get($id);
            $item->forceFill(['post_id' => $post->id, 'position' => $position])->save();
        }
    }
}
