<?php

declare(strict_types=1);

namespace App\Modules\Moderation\Http\Requests;

use App\Modules\Moderation\Enums\ReportReason;
use App\Modules\Moderation\Enums\ReportTargetType;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

final class SubmitReportRequest extends FormRequest
{
    public const int MAX_DETAILS = 500;

    public function authorize(): bool
    {
        return true;
    }

    /**
     * @return array<string, list<mixed>>
     */
    public function rules(): array
    {
        return [
            'target_type' => ['required', 'string', Rule::enum(ReportTargetType::class)],
            'target_id' => ['required', 'uuid'],
            'reason' => ['required', 'string', Rule::enum(ReportReason::class)],
            // "Other" needs a short explanation; optional otherwise.
            'details' => ['nullable', 'string', 'max:'.self::MAX_DETAILS, 'required_if:reason,'.ReportReason::Other->value],
        ];
    }

    public function targetType(): ReportTargetType
    {
        return ReportTargetType::from($this->string('target_type')->toString());
    }

    public function targetId(): string
    {
        return strtolower($this->string('target_id')->toString());
    }

    public function reason(): ReportReason
    {
        return ReportReason::from($this->string('reason')->toString());
    }

    public function details(): ?string
    {
        return $this->filled('details') ? $this->string('details')->toString() : null;
    }
}
