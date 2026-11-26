<?php

declare(strict_types=1);

namespace App\Modules\Auth\Notifications;

use App\Modules\Auth\Models\User;
use App\Support\Translation\Message;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;
use SensitiveParameter;

/**
 * Password reset email with a link the app opens (deep/universal link).
 * Contains no health or community data.
 */
final class ResetPasswordNotification extends Notification implements ShouldQueue
{
    use Queueable;

    public function __construct(#[SensitiveParameter] public readonly string $token) {}

    /**
     * @return list<string>
     */
    public function via(User $notifiable): array
    {
        return ['mail'];
    }

    public function toMail(User $notifiable): MailMessage
    {
        $expire = config('auth.passwords.users.expire');

        return (new MailMessage)
            ->subject(Message::get('auth::messages.reset_mail_subject'))
            ->greeting(Message::get('auth::messages.reset_mail_greeting'))
            ->line(Message::get('auth::messages.reset_mail_intro'))
            ->action(Message::get('auth::messages.reset_mail_action'), $this->resetUrl($notifiable))
            ->line(Message::get('auth::messages.reset_mail_expiry', [
                'minutes' => is_numeric($expire) ? (int) $expire : 60,
            ]))
            ->line(Message::get('auth::messages.reset_mail_ignore'));
    }

    public function resetUrl(User $notifiable): string
    {
        $base = config('auth.password_reset_url');

        return rtrim(is_string($base) ? $base : '', '?').'?'.http_build_query([
            'token' => $this->token,
            'email' => $notifiable->email,
        ]);
    }
}
