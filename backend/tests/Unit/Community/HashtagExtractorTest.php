<?php

declare(strict_types=1);

use App\Modules\Community\Support\HashtagExtractor;

it('extracts Latin and Arabic hashtags, normalized and unique', function (): void {
    expect(HashtagExtractor::extract('Feeling better #Recovery #recovery and #الصحة_النفسية today #self_care'))
        ->toBe(['recovery', 'الصحة_النفسية', 'self_care']);
});

it('ignores emails, URL fragments, numbers-only and too-short tags', function (): void {
    expect(HashtagExtractor::extract('mail me@x.com, see page#section, #1 #2024 #a and #ok'))
        ->toBe(['ok']);
});

it('caps the number of tags per post', function (): void {
    $text = implode(' ', array_map(static fn (int $i): string => '#tag'.$i, range(1, 15)));

    expect(HashtagExtractor::extract($text))->toHaveCount(HashtagExtractor::MAX_PER_POST);
});

it('normalizes a query tag', function (): void {
    expect(HashtagExtractor::normalize(' #Recovery '))->toBe('recovery');
});
