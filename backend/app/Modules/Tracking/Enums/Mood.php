<?php

declare(strict_types=1);

namespace App\Modules\Tracking\Enums;

use App\Support\Translation\Message;

/**
 * Overall emotional state (FR-TRACK-002), lowest to highest.
 */
enum Mood: string
{
    case VerySad = 'very_sad';
    case Sad = 'sad';
    case Neutral = 'neutral';
    case Good = 'good';
    case VeryGood = 'very_good';

    public function label(): string
    {
        return Message::get('tracking::messages.mood_'.$this->value);
    }
}
