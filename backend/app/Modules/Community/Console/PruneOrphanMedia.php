<?php

declare(strict_types=1);

namespace App\Modules\Community\Console;

use App\Modules\Community\Models\PostMedia;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Storage;

/**
 * Deletes uploaded images that were never attached to a post (or were removed from one).
 */
final class PruneOrphanMedia extends Command
{
    protected $signature = 'community:prune-orphan-media {--hours=24 : Minimum age of unattached uploads}';

    protected $description = 'Delete post images that are not attached to any post';

    public function handle(): int
    {
        $cutoff = now()->subHours((int) $this->option('hours'));
        $deleted = 0;

        PostMedia::query()
            ->whereNull('post_id')
            ->where('updated_at', '<', $cutoff)
            ->chunkById(200, function ($batch) use (&$deleted): void {
                foreach ($batch as $media) {
                    Storage::disk($media->disk)->delete($media->path);
                    $media->delete();
                    $deleted++;
                }
            });

        $this->info("Deleted {$deleted} orphan image(s).");

        return self::SUCCESS;
    }
}
