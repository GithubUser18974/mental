<?php

declare(strict_types=1);

namespace App\Modules\Medication\Http\Requests;

use App\Support\Translation\Message;
use Carbon\CarbonImmutable;
use DateTimeZone;
use Illuminate\Foundation\Http\FormRequest;

/**
 * Local calendar days to expand doses for (default: today; at most 31 days).
 */
final class DoseWindowRequest extends FormRequest
{
    public const int MAX_DAYS = 31;

    public function authorize(): bool
    {
        return true;
    }

    /**
     * @return array<string, list<string>>
     */
    public function rules(): array
    {
        return [
            'from' => ['sometimes', 'date_format:Y-m-d'],
            'to' => ['sometimes', 'date_format:Y-m-d', 'after_or_equal:from'],
        ];
    }

    public function withValidator(\Illuminate\Validation\Validator $validator): void
    {
        $validator->after(function (\Illuminate\Validation\Validator $v): void {
            if ($this->filled(['from', 'to'])) {
                $from = CarbonImmutable::parse($this->string('from')->toString());
                $to = CarbonImmutable::parse($this->string('to')->toString());
                if ($from->diffInDays($to) >= self::MAX_DAYS) {
                    $v->errors()->add('to', Message::get('medication::messages.window_too_long', ['days' => self::MAX_DAYS]));
                }
            }
        });
    }

    /**
     * UTC bounds of the requested local days (end exclusive).
     *
     * @return array{0: CarbonImmutable, 1: CarbonImmutable}
     */
    public function utcWindow(DateTimeZone $tz): array
    {
        $today = CarbonImmutable::now($tz)->startOfDay();
        $from = $this->filled('from')
            ? CarbonImmutable::createFromFormat('!Y-m-d', $this->string('from')->toString(), $tz) ?? $today
            : $today;
        $to = $this->filled('to')
            ? CarbonImmutable::createFromFormat('!Y-m-d', $this->string('to')->toString(), $tz) ?? $from
            : $from;

        return [$from->utc(), $to->addDay()->utc()];
    }
}
