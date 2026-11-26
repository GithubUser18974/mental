<?php

declare(strict_types=1);

use App\Modules\Community\Enums\ModerationStatus;
use App\Modules\Community\Models\Comment;
use App\Modules\Community\Models\Post;
use App\Modules\Identity\Models\AnonymousProfile;
use App\Modules\Moderation\Actions\BuildReportQueue;
use App\Modules\Moderation\Enums\ReportPriority;
use App\Modules\Moderation\Enums\ReportReason;
use App\Modules\Moderation\Enums\ReportStatus;
use App\Modules\Moderation\Enums\ReportTargetType;
use App\Modules\Moderation\Events\ContentReported;
use App\Modules\Moderation\Models\Report;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;

beforeEach(function (): void {
    $this->me = actAs(AnonymousProfile::factory()->create());
    $this->author = AnonymousProfile::factory()->create(['username' => 'LoudStorm']);
    $this->post = Post::factory()->create(['author_profile_id' => $this->author->id]);
});

/** @param  array<string, mixed>  $overrides */
function fileReport(array $overrides = []): Illuminate\Testing\TestResponse
{
    return test()->postJson('/api/v1/reports', [
        'target_type' => 'post',
        'target_id' => test()->post->id,
        'reason' => 'harassment',
        ...$overrides,
    ]);
}

it('requires authentication', function (string $method): void {
    forgetAuth();

    $this->withHeader('Authorization', 'Bearer invalid')->json($method, '/api/v1/reports')->assertUnauthorized();
})->with(['GET', 'POST']);

it('files a post report into the queue with a priority from the reason', function (): void {
    Event::fake([ContentReported::class]);

    fileReport(['reason' => 'dangerous_medical_advice', 'details' => 'Says to double the dose'])
        ->assertCreated()
        ->assertJsonPath('message', 'Thank you for letting us know. Our moderators will review this.')
        ->assertJsonPath('data.status', 'open')
        ->assertJsonPath('data.reason', 'dangerous_medical_advice')
        ->assertJsonPath('data.crisis_support', false);

    $report = Report::query()->sole();
    expect($report->reporter_profile_id)->toBe($this->me->id)
        ->and($report->target_owner_profile_id)->toBe($this->author->id)
        ->and($report->priority)->toBe(ReportPriority::High)
        ->and($report->details)->toBe('Says to double the dose');

    Event::assertDispatched(ContentReported::class, fn (ContentReported $e): bool => $e->reportId === $report->id
        && $e->priority === ReportPriority::High);
});

it('marks suicide and self-harm reports critical and offers crisis support', function (string $reason): void {
    fileReport(['reason' => $reason])->assertCreated()->assertJsonPath('data.crisis_support', true);

    expect(Report::query()->sole()->priority)->toBe(ReportPriority::Critical);
})->with(['suicidal_content', 'self_harm_encouragement']);

it('reports comments and profiles', function (): void {
    $comment = Comment::factory()->create(['post_id' => $this->post->id]);

    fileReport(['target_type' => 'comment', 'target_id' => $comment->id, 'reason' => 'spam'])->assertCreated();
    fileReport(['target_type' => 'profile', 'target_id' => $this->author->id])->assertCreated();

    expect(Report::query()->pluck('target_owner_profile_id', 'target_type')->all())->toBe([
        'comment' => $comment->author_profile_id,
        'profile' => $this->author->id,
    ]);
});

it('does not duplicate a pending report from the same member', function (): void {
    Event::fake([ContentReported::class]);

    $first = fileReport()->assertCreated()->json('data.id');
    fileReport(['reason' => 'spam'])->assertOk()->assertJsonPath('data.id', $first);

    expect(Report::query()->count())->toBe(1);
    Event::assertDispatchedTimes(ContentReported::class, 1);

    // Once resolved, the member can report the same thing again.
    Report::query()->whereKey($first)->update(['status' => ReportStatus::Dismissed->value]);
    fileReport()->assertCreated();
});

it('404s targets the reporter cannot see, without revealing they exist', function (string $type, Closure $target): void {
    fileReport(['target_type' => $type, 'target_id' => $target()])->assertNotFound();

    expect(Report::query()->count())->toBe(0);
})->with([
    'unknown post' => ['post', fn () => (string) Str::uuid()],
    'private post' => ['post', fn () => Post::factory()->onlyMe()->create()->id],
    'hidden post' => ['post', fn () => Post::factory()->moderated(ModerationStatus::Hidden)->create()->id],
    'deleted post' => ['post', fn () => tap(Post::factory()->create())->delete()->id],
    'unknown comment' => ['comment', fn () => (string) Str::uuid()],
    'comment on private post' => ['comment', fn () => Comment::factory()->create(['post_id' => Post::factory()->onlyMe()->create()->id])->id],
    'deleted comment' => ['comment', fn () => tap(Comment::factory()->create())->delete()->id],
    'unknown profile' => ['profile', fn () => (string) Str::uuid()],
    'suspended profile' => ['profile', function (): string {
        $p = AnonymousProfile::factory()->create();
        $p->user->forceFill(['status' => 'suspended'])->save();

        return $p->id;
    }],
]);

it('rejects reporting my own content', function (): void {
    $mine = Post::factory()->create(['author_profile_id' => $this->me->id]);

    fileReport(['target_id' => $mine->id])->assertUnprocessable()->assertJsonValidationErrors('target_id');
    fileReport(['target_type' => 'profile', 'target_id' => $this->me->id])->assertUnprocessable();
});

it('respects blocks: content hidden by a block cannot be reported, but a profile I blocked can', function (): void {
    $this->postJson("/api/v1/profiles/{$this->author->id}/block")->assertNoContent();

    fileReport()->assertNotFound();
    fileReport(['target_type' => 'profile', 'target_id' => $this->author->id])->assertCreated();

    // ...while someone who blocked me can't be reported through their (hidden) profile.
    $blocker = AnonymousProfile::factory()->create();
    actAs($blocker);
    $this->postJson("/api/v1/profiles/{$this->me->id}/block")->assertNoContent();
    actAs($this->me);
    fileReport(['target_type' => 'profile', 'target_id' => $blocker->id])->assertNotFound();
});

it('validates the report', function (array $payload, array $errors): void {
    $this->postJson('/api/v1/reports', $payload)->assertUnprocessable()->assertJsonValidationErrors($errors);
})->with([
    'empty' => [[], ['target_type', 'target_id', 'reason']],
    'bad values' => [['target_type' => 'journal', 'target_id' => 'x', 'reason' => 'dislike'], ['target_type', 'target_id', 'reason']],
    'other without details' => [['target_type' => 'post', 'target_id' => '01a1df57-bc12-73c6-89be-30d64bdd7ad6', 'reason' => 'other'], ['details']],
    'details too long' => [['target_type' => 'post', 'target_id' => '01a1df57-bc12-73c6-89be-30d64bdd7ad6', 'reason' => 'spam', 'details' => str_repeat('a', 501)], ['details']],
]);

it('accepts "other" with details', function (): void {
    fileReport(['reason' => 'other', 'details' => 'Selling things in every comment'])->assertCreated();
});

it('never tells the reported member who reported them or exposes reports to others', function (): void {
    fileReport()->assertCreated();

    actAs($this->author);
    expect($this->getJson('/api/v1/reports')->assertOk()->json('data'))->toBe([]);
    $this->getJson("/api/v1/posts/{$this->post->id}")->assertOk();
    expect($this->getJson("/api/v1/posts/{$this->post->id}")->getContent())->not->toContain($this->me->id);
});

it('lists my own reports newest first with their status', function (): void {
    $first = fileReport()->json('data.id');
    $this->travel(1)->minutes();
    $second = fileReport(['target_type' => 'profile', 'target_id' => $this->author->id])->json('data.id');

    $data = $this->getJson('/api/v1/reports')->assertOk()->json('data');
    expect(collect($data)->pluck('id')->all())->toBe([$second, $first])
        ->and(array_keys($data[0]))->toBe(['id', 'target_type', 'target_id', 'reason', 'status', 'crisis_support', 'created_at']);
});

it('never logs the report details', function (): void {
    Log::spy();

    fileReport(['reason' => 'other', 'details' => 'SECRET-DETAIL-TEXT'])->assertCreated();

    Log::shouldHaveReceived('info')->withArgs(function (string $message, array $context): bool {
        expect(json_encode($context))->not->toContain('SECRET-DETAIL-TEXT');

        return $message === 'moderation.report_created';
    })->once();
});

it('rate limits reports', function (): void {
    $targets = Post::factory()->count(21)->create();
    foreach ($targets->take(20) as $post) {
        fileReport(['target_id' => $post->id])->assertCreated();
    }

    fileReport(['target_id' => $targets->last()->id])->assertTooManyRequests();
});

it('builds the moderation queue: critical first, then most reporters, then oldest', function (): void {
    $spamTarget = (string) Str::uuid();
    $harassTarget = (string) Str::uuid();
    $crisisTarget = (string) Str::uuid();

    Report::factory()->reason(ReportReason::Spam)->count(3)->create(['target_id' => $spamTarget]);
    Report::factory()->reason(ReportReason::Harassment)->create(['target_id' => $harassTarget]);
    Report::factory()->reason(ReportReason::Spam)->create(['target_id' => $harassTarget]);
    Report::factory()->reason(ReportReason::SuicidalContent)->create([
        'target_id' => $crisisTarget,
        'target_type' => ReportTargetType::Comment,
    ]);
    Report::factory()->reason(ReportReason::Harassment)->status(ReportStatus::Dismissed)->count(5)->create();

    $queue = app(BuildReportQueue::class)();

    expect($queue->pluck('target_id')->all())->toBe([$crisisTarget, $harassTarget, $spamTarget])
        ->and((int) $queue[0]->getAttribute('top_priority'))->toBe(ReportPriority::Critical->value)
        ->and((int) $queue[1]->getAttribute('reporters_count'))->toBe(2)
        ->and((int) $queue[2]->getAttribute('reporters_count'))->toBe(3);
});
