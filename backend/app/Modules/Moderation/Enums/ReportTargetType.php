<?php

declare(strict_types=1);

namespace App\Modules\Moderation\Enums;

enum ReportTargetType: string
{
    case Post = 'post';
    case Comment = 'comment';
    case Profile = 'profile';
}
