<?php

declare(strict_types=1);

namespace App\Modules\Community\Enums;

enum FeedSort: string
{
    case Recent = 'recent';
    case Popular = 'popular';
}
