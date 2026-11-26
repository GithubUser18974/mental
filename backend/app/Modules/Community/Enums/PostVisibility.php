<?php

declare(strict_types=1);

namespace App\Modules\Community\Enums;

/**
 * Author-controlled visibility ("Hide from community" in the design).
 */
enum PostVisibility: string
{
    /** Shown in the community feed. */
    case Community = 'community';

    /** Kept by the author, invisible to everyone else. */
    case OnlyMe = 'only_me';
}
