<?php

declare(strict_types=1);

use App\Modules\Identity\Enums\FollowPolicy;
use App\Modules\Identity\Events\ProfileFollowed;
use App\Modules\Identity\Models\AnonymousProfile;
use App\Modules\Identity\Models\UserPrivacySetting;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Str;

beforeEach(function (): void {
    $this->me = actAs(AnonymousProfile::factory()->create(['username' => 'SoftHarbor']));
    $this->other = AnonymousProfile::factory()->create(['username' => 'GentleWillow']);
});

/** @return list<string> */
function connectionIds(string $list): array
{
    return collect(test()->getJson('/api/v1/profile/'.$list)->assertOk()->json('data'))->pluck('id')->all();
}

it('requires authentication', function (string $method, string $uri): void {
    forgetAuth();

    $this->withHeader('Authorization', 'Bearer invalid')->json($method, $uri)->assertUnauthorized();
})->with([
    ['POST', '/api/v1/profiles/'.Str::uuid().'/follow'],
    ['DELETE', '/api/v1/profiles/'.Str::uuid().'/follow'],
    ['POST', '/api/v1/profiles/'.Str::uuid().'/block'],
    ['DELETE', '/api/v1/profiles/'.Str::uuid().'/block'],
    ['GET', '/api/v1/profile/followers'],
    ['GET', '/api/v1/profile/following'],
    ['GET', '/api/v1/profile/blocks'],
    ['GET', '/api/v1/search/profiles?q=ab'],
]);

it('follows and unfollows idempotently, and notifies once', function (): void {
    Event::fake([ProfileFollowed::class]);

    $this->postJson("/api/v1/profiles/{$this->other->id}/follow")->assertNoContent();
    $this->postJson("/api/v1/profiles/{$this->other->id}/follow")->assertNoContent();

    expect(connectionIds('following'))->toBe([$this->other->id]);
    Event::assertDispatchedTimes(ProfileFollowed::class, 1);
    Event::assertDispatched(ProfileFollowed::class, fn (ProfileFollowed $e): bool => $e->followedProfileId === $this->other->id
        && $e->followerProfileId === $this->me->id);

    $this->getJson('/api/v1/profiles/GentleWillow')
        ->assertJsonPath('data.stats.followers', 1)
        ->assertJsonPath('data.relationship.is_following', true)
        ->assertJsonPath('data.relationship.can_follow', false);

    $this->deleteJson("/api/v1/profiles/{$this->other->id}/follow")->assertNoContent();
    $this->deleteJson("/api/v1/profiles/{$this->other->id}/follow")->assertNoContent();
    expect(connectionIds('following'))->toBe([]);
});

it('lists my followers newest first with a follow-back flag', function (): void {
    $a = AnonymousProfile::factory()->create();
    $b = AnonymousProfile::factory()->create();
    foreach ([$a, $b] as $follower) {
        actAs($follower);
        $this->postJson("/api/v1/profiles/{$this->me->id}/follow")->assertNoContent();
        $this->travel(1)->minutes();
    }

    actAs($this->me);
    $this->postJson("/api/v1/profiles/{$a->id}/follow")->assertNoContent();

    $data = $this->getJson('/api/v1/profile/followers')->assertOk()->json('data');
    expect(collect($data)->pluck('id')->all())->toBe([$b->id, $a->id])
        ->and($data[0]['is_following'])->toBeFalse()
        ->and($data[1]['is_following'])->toBeTrue()
        ->and(array_keys($data[0]))->toBe(['id', 'username', 'avatar', 'is_following']);

    $this->getJson('/api/v1/profiles/SoftHarbor')
        ->assertJsonPath('data.stats', ['followers' => 2, 'following' => 1])
        ->assertJsonPath('data.relationship.is_self', true)
        ->assertJsonPath('data.relationship.can_follow', false);
});

it('respects "nobody can follow me"', function (): void {
    UserPrivacySetting::query()->create(['user_id' => $this->other->user_id, 'follow_policy' => FollowPolicy::Nobody]);

    $this->getJson('/api/v1/profiles/GentleWillow')->assertJsonPath('data.relationship.can_follow', false);
    $this->postJson("/api/v1/profiles/{$this->other->id}/follow")->assertForbidden();
    expect(connectionIds('following'))->toBe([]);
});

it('rejects following or blocking yourself', function (string $action): void {
    $this->postJson("/api/v1/profiles/{$this->me->id}/{$action}")
        ->assertUnprocessable()
        ->assertJsonValidationErrors('profile');
})->with(['follow', 'block']);

it('404s unknown, malformed and inactive profiles', function (): void {
    $this->other->user->forceFill(['status' => 'suspended'])->save();

    $this->postJson("/api/v1/profiles/{$this->other->id}/follow")->assertNotFound();
    $this->postJson('/api/v1/profiles/'.Str::uuid().'/block')->assertNotFound();
    $this->postJson('/api/v1/profiles/not-a-uuid/follow')->assertNotFound();
});

it('blocking removes follows both ways and prevents new ones (FR-COM-009)', function (): void {
    $this->postJson("/api/v1/profiles/{$this->other->id}/follow")->assertNoContent();
    actAs($this->other);
    $this->postJson("/api/v1/profiles/{$this->me->id}/follow")->assertNoContent();

    actAs($this->me);
    $this->postJson("/api/v1/profiles/{$this->other->id}/block")->assertNoContent();
    $this->postJson("/api/v1/profiles/{$this->other->id}/block")->assertNoContent(); // idempotent

    expect(DB::table('profile_follows')->count())->toBe(0)
        ->and(connectionIds('blocks'))->toBe([$this->other->id]);

    // Neither side can follow the other now (SRS §13.3: blocked users cannot interact).
    $this->postJson("/api/v1/profiles/{$this->other->id}/follow")->assertNotFound();
    actAs($this->other);
    $this->postJson("/api/v1/profiles/{$this->me->id}/follow")->assertNotFound();
});

it('hides my profile from someone I blocked, but keeps theirs reachable for me to unblock', function (): void {
    $this->postJson("/api/v1/profiles/{$this->other->id}/block")->assertNoContent();

    $this->getJson('/api/v1/profiles/GentleWillow')
        ->assertOk()
        ->assertJsonPath('data.relationship.is_blocked', true)
        ->assertJsonPath('data.relationship.can_follow', false)
        ->assertJsonPath('data.bio', null);

    actAs($this->other);
    $this->getJson('/api/v1/profiles/SoftHarbor')->assertNotFound();
});

it('unblocks', function (): void {
    $this->postJson("/api/v1/profiles/{$this->other->id}/block")->assertNoContent();
    $this->deleteJson("/api/v1/profiles/{$this->other->id}/block")->assertNoContent();

    expect(connectionIds('blocks'))->toBe([]);
    actAs($this->other);
    $this->getJson('/api/v1/profiles/SoftHarbor')->assertOk()->assertJsonPath('data.relationship.is_blocked', false);
});

it('does not reveal that someone blocked me when I block them back', function (): void {
    actAs($this->other);
    $this->postJson("/api/v1/profiles/{$this->me->id}/block")->assertNoContent();

    actAs($this->me);
    $this->postJson("/api/v1/profiles/{$this->other->id}/block")->assertNoContent();
    expect(connectionIds('blocks'))->toBe([$this->other->id]);
});

it('keeps my connection lists private to me', function (): void {
    actAs($this->other);
    $this->postJson("/api/v1/profiles/{$this->me->id}/follow")->assertNoContent();

    actAs(AnonymousProfile::factory()->create());
    expect(connectionIds('followers'))->toBe([]);
});

it('drops hidden and inactive members from follower lists', function (): void {
    $blockedLater = AnonymousProfile::factory()->create();
    $suspended = AnonymousProfile::factory()->create();
    foreach ([$this->other, $blockedLater, $suspended] as $follower) {
        actAs($follower);
        $this->postJson("/api/v1/profiles/{$this->me->id}/follow")->assertNoContent();
    }
    $suspended->user->forceFill(['status' => 'suspended'])->save();

    actAs($blockedLater);
    $this->postJson("/api/v1/profiles/{$this->me->id}/block")->assertNoContent();

    actAs($this->me);
    expect(connectionIds('followers'))->toBe([$this->other->id]);
});

it('searches members by username, prefix matches first, without hidden or inactive ones', function (): void {
    $starts = AnonymousProfile::factory()->create(['username' => 'WillowBreeze']);
    $blocker = AnonymousProfile::factory()->create(['username' => 'WillowShade']);
    $gone = AnonymousProfile::factory()->create(['username' => 'WillowGone']);
    $gone->user->forceFill(['status' => 'deactivated'])->save();
    actAs($blocker);
    $this->postJson("/api/v1/profiles/{$this->me->id}/block")->assertNoContent();

    actAs($this->me);
    $data = $this->getJson('/api/v1/search/profiles?q=@willow')->assertOk()->json('data');

    expect(collect($data)->pluck('id')->all())->toBe([$starts->id, $this->other->id])
        ->and($data[0])->toHaveKey('is_following');
});

it('treats search text literally (no LIKE wildcards)', function (): void {
    AnonymousProfile::factory()->create(['username' => 'Calm_Sea']);

    expect($this->getJson('/api/v1/search/profiles?q=%25%25')->assertOk()->json('data'))->toBe([])
        ->and($this->getJson('/api/v1/search/profiles?q=m_s')->json('data.0.username'))->toBe('Calm_Sea')
        ->and($this->getJson('/api/v1/search/profiles?q=mxs')->json('data'))->toBe([]);
});

it('validates search input', function (): void {
    $this->getJson('/api/v1/search/profiles')->assertUnprocessable()->assertJsonValidationErrors('q');
    $this->getJson('/api/v1/search/profiles?q=a')->assertUnprocessable()->assertJsonValidationErrors('q');
});
