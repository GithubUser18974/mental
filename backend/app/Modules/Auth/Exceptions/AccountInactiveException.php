<?php

declare(strict_types=1);

namespace App\Modules\Auth\Exceptions;

use App\Support\Exceptions\ApiException;
use App\Support\Translation\Message;

/**
 * The account exists but may not use the app (suspended / deactivated).
 */
final class AccountInactiveException extends ApiException
{
    public function __construct()
    {
        parent::__construct(Message::get('auth::messages.account_inactive'), 403);
    }
}
