<?php

declare(strict_types=1);

use App\Modules\Auth\Models\User;
use App\Support\Exceptions\ApiException;
use App\Support\Http\ApiResponse;
use Illuminate\Auth\Access\AuthorizationException;
use Illuminate\Cache\RateLimiting\Limit;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Str;

beforeEach(function (): void {
    RateLimiter::for('test-limit', static fn (): Limit => Limit::perMinute(1));

    Route::middleware('api')->prefix('api/v1/_test')->group(function (): void {
        Route::post('validation', static fn (Request $request): array => $request->validate([
            'score' => ['required', 'integer', 'between:1,10'],
        ]));
        Route::get('auth', static fn (): string => 'secret')->middleware('auth:sanctum');
        Route::get('forbidden', static fn () => throw new AuthorizationException('internal policy reason'));
        Route::get('users/{user}', static fn (User $user) => ApiResponse::success(['id' => $user->id]));
        Route::get('crash', static fn () => throw new RuntimeException('SQLSTATE[23505] email=a@b.com'));
        Route::get('domain', static fn () => throw new ApiException('Your account is suspended.', 423));
        Route::get('paginated', static fn () => ApiResponse::success(
            JsonResource::collection(User::query()->orderBy('id')->cursorPaginate(2)),
        ));
        Route::post('created', static fn () => ApiResponse::created(['id' => 'abc']));
        Route::delete('nothing', static fn () => ApiResponse::noContent());
        Route::get('limited', static fn () => ApiResponse::success())->middleware('throttle:test-limit');
    });
});

describe('success responses', function (): void {
    it('wraps created data in the envelope with 201', function (): void {
        $this->postJson('/api/v1/_test/created')
            ->assertCreated()
            ->assertExactJson(['success' => true, 'message' => 'Created successfully.', 'data' => ['id' => 'abc']]);
    });

    it('returns an empty 204 for no-content responses', function (): void {
        $this->deleteJson('/api/v1/_test/nothing')->assertNoContent();
    });

    it('adds normalized cursor pagination meta for paginated resources', function (): void {
        User::factory()->count(3)->create();

        $first = $this->getJson('/api/v1/_test/paginated')
            ->assertOk()
            ->assertJsonPath('success', true)
            ->assertJsonCount(2, 'data')
            ->assertJsonPath('meta.pagination.per_page', 2)
            ->assertJsonPath('meta.pagination.has_more', true)
            ->assertJsonMissingPath('links');

        $cursor = $first->json('meta.pagination.next_cursor');
        expect($cursor)->toBeString();

        $this->getJson('/api/v1/_test/paginated?cursor='.$cursor)
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('meta.pagination.has_more', false)
            ->assertJsonPath('meta.pagination.next_cursor', null);
    });
});

describe('error responses', function (): void {
    it('maps validation errors to 422 with field errors', function (): void {
        $this->postJson('/api/v1/_test/validation', ['score' => 11])
            ->assertUnprocessable()
            ->assertExactJson([
                'success' => false,
                'message' => 'Validation failed.',
                'errors' => ['score' => ['The score field must be between 1 and 10.']],
            ]);
    });

    it('returns 401 JSON (not a redirect) when unauthenticated, even without Accept header', function (): void {
        $this->get('/api/v1/_test/auth')
            ->assertUnauthorized()
            ->assertExactJson(['success' => false, 'message' => 'Please sign in to continue.']);
    });

    it('returns a generic 403 without the internal reason', function (): void {
        $response = $this->getJson('/api/v1/_test/forbidden')
            ->assertForbidden()
            ->assertExactJson(['success' => false, 'message' => 'You are not allowed to perform this action.']);

        expect($response->getContent())->not->toContain('internal policy reason');
    });

    it('returns a generic 404 for a missing model without leaking the model class', function (): void {
        $response = $this->getJson('/api/v1/_test/users/'.Str::uuid())
            ->assertNotFound()
            ->assertExactJson(['success' => false, 'message' => 'The requested resource was not found.']);

        expect($response->getContent())->not->toContain('App\\\\Models');
    });

    it('returns 404 (not a database error) for a malformed uuid', function (): void {
        $this->getJson('/api/v1/_test/users/not-a-uuid')->assertNotFound();
    });

    it('returns 404 JSON for unknown API routes', function (): void {
        $this->get('/api/v1/does-not-exist')
            ->assertNotFound()
            ->assertJsonPath('success', false);
    });

    it('returns 405 for unsupported methods', function (): void {
        $this->getJson('/api/v1/_test/created')
            ->assertMethodNotAllowed()
            ->assertJsonPath('message', 'This method is not supported for this endpoint.');
    });

    it('renders domain ApiExceptions with their message and status', function (): void {
        $this->getJson('/api/v1/_test/domain')
            ->assertStatus(423)
            ->assertExactJson(['success' => false, 'message' => 'Your account is suspended.']);
    });

    it('hides unexpected exception details behind a generic 500', function (): void {
        $response = $this->getJson('/api/v1/_test/crash')
            ->assertInternalServerError()
            ->assertExactJson([
                'success' => false,
                'message' => 'Something went wrong on our side. Please try again later.',
            ]);

        expect($response->getContent())->not->toContain('SQLSTATE')->not->toContain('a@b.com');
    });

    it('returns 429 with Retry-After when a rate limit is exceeded', function (): void {
        $this->getJson('/api/v1/_test/limited')->assertOk();

        $this->getJson('/api/v1/_test/limited')
            ->assertTooManyRequests()
            ->assertHeader('Retry-After')
            ->assertJsonPath('message', 'Too many requests. Please try again shortly.');
    });
});

describe('localization', function (): void {
    it('responds in Arabic when requested', function (): void {
        $this->getJson('/api/v1/_test/forbidden', ['Accept-Language' => 'ar'])
            ->assertForbidden()
            ->assertHeader('Content-Language', 'ar')
            ->assertJsonPath('message', 'لا تملك صلاحية القيام بهذا الإجراء.');
    });

    it('falls back to English for unsupported languages', function (): void {
        $this->getJson('/api/v1/_test/forbidden', ['Accept-Language' => 'fr-FR'])
            ->assertHeader('Content-Language', 'en')
            ->assertJsonPath('message', 'You are not allowed to perform this action.');
    });
});

describe('request id', function (): void {
    it('assigns a UUID X-Request-Id to every API response', function (): void {
        $id = $this->getJson('/api/v1/health')->headers->get('X-Request-Id');

        expect(Str::isUuid((string) $id))->toBeTrue();
    });

    it('echoes a valid client request id and replaces an invalid one', function (): void {
        $valid = (string) Str::uuid();

        $this->getJson('/api/v1/health', ['X-Request-Id' => $valid])->assertHeader('X-Request-Id', $valid);

        $replaced = $this->getJson('/api/v1/health', ['X-Request-Id' => "evil\nlog-line"])->headers->get('X-Request-Id');
        expect(Str::isUuid((string) $replaced))->toBeTrue();
    });
});
