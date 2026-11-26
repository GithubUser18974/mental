<?php

declare(strict_types=1);

namespace App\Modules\Tracking\Http\Requests;

use Carbon\CarbonImmutable;
use DateTimeZone;
use Illuminate\Foundation\Http\FormRequest;

/**
 * History filters (FR-PROGRESS-003 "filter by date range"): `from` / `to` are calendar
 * days in the member's own timezone; both optional.
 */
final class HistoryRequest extends FormRequest
{
    public const int MAX_PER_PAGE = 100;

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
            'per_page' => ['sometimes', 'integer', 'min:1', 'max:'.self::MAX_PER_PAGE],
            'cursor' => ['sometimes', 'string'],
        ];
    }

    /**
     * UTC bounds for the requested local days (inclusive start, exclusive end).
     *
     * @return array{0: CarbonImmutable|null, 1: CarbonImmutable|null}
     */
    public function utcRange(DateTimeZone $timezone): array
    {
        $from = $this->filled('from')
            ? CarbonImmutable::createFromFormat('!Y-m-d', $this->string('from')->toString(), $timezone)
            : null;
        $to = $this->filled('to')
            ? CarbonImmutable::createFromFormat('!Y-m-d', $this->string('to')->toString(), $timezone)
            : null;

        return [$from?->utc(), $to?->addDay()->utc()];
    }

    public function perPage(): int
    {
        return max(1, min(self::MAX_PER_PAGE, $this->integer('per_page', 30)));
    }
}
