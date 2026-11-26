<?php

declare(strict_types=1);

namespace App\Modules\Identity\Enums;

enum ProfileVisibility: string
{
    /** Signed-in members can see bio and profile details. */
    case Public = 'public';

    /** Others only see username, avatar and joined date. */
    case Private = 'private';
}
