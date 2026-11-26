---
paths:
  - "backend/**"
---

# PHP / Laravel Rules

Stack: PHP 8.3+, Laravel (latest stable), Sanctum, PostgreSQL, Redis, Laravel Queues/Scheduler/Notifications.

## Language & style

- `declare(strict_types=1);` at the top of every PHP file.
- PSR-12, enforced by **Laravel Pint**. Static analysis with **Larastan (PHPStan) level 8+**; new code must not add baseline entries.
- Type everything: parameter, return and property types. No `mixed` unless unavoidable. Use `readonly` properties/classes for DTOs and value objects.
- Use backed `enum`s for fixed sets (post status, reaction type, report reason, medication status, mood). Never raw strings/magic numbers.
- `final` classes by default (services, actions, controllers, jobs). Open only when inheritance is intended.
- Constructor injection only. No `app()`/`resolve()` service location inside business code; facades only in framework glue.
- No `env()` outside `config/` files — read through `config()`.

## Modular monolith structure

```text
backend/app/Modules/
  Auth/ Identity/ Community/ Moderation/ Tracking/
  Medication/ Journal/ Notifications/ Reporting/ Admin/
    Http/Controllers/  Http/Requests/  Http/Resources/
    Actions/  Services/  DTOs/  Models/  Policies/  Enums/
    Events/  Listeners/  Jobs/  Notifications/
    Database/Migrations/  Database/Factories/  Lang/
    Routes/api.php  ModuleServiceProvider.php   (extends App\Support\Modules\ModuleServiceProvider)
```

- Modules are auto-discovered. `Routes/api.php` is mounted at `/api/v1` with the `api` middleware group (request id, forced JSON, locale, `throttle:api`); `routes/api.php` stays empty.
- Tests live in `tests/Feature/<Module>/` and `tests/Unit/<Module>/` (not inside the module).
- A module may **not** use another module's Models directly — call the other module's public Service/Action or listen to its Events. **Exception (shared kernel):** Eloquent relations to `Auth`/`Identity` models (`User`, `AnonymousProfile`) are allowed.
- `Community`, `Moderation` and `Identity` must never depend on `Tracking`, `Medication` or `Journal` (enforced by arch test).
- Shared primitives live in `app/Support/` and never depend on modules (enforced by arch test).

## Request flow

`Route → FormRequest (validate + authorize) → Controller (thin) → Action/Service → Model → API Resource`

- **Controllers:** no business logic, no queries beyond route-model binding. ≤ ~10 lines per method.
- **Validation:** always a dedicated `FormRequest`. Never `$request->all()` — use `$request->validated()` or a DTO built from it. Never mass-assign unvalidated input.
- **Business logic:** single-purpose `Action` classes (`CreatePostAction`, `LogMedicationIntakeAction`) or a module Service. Wrap multi-write operations in `DB::transaction()`.
- **Responses:** always return `App\Support\Http\ApiResponse::success|created|noContent(...)` with a `JsonResource`/collection — it builds the envelope and `meta.pagination`. Never return Eloquent models or raw arrays from controllers.
- **Expected errors:** throw `App\Support\Exceptions\ApiException` (or a subclass) with a translated, data-free message and an HTTP status. Everything else is mapped centrally by `ApiExceptionRenderer` — don't catch-and-format in controllers.
- **Messages:** user-facing strings via `App\Support\Translation\Message::get('key')` (typed `__()`), with entries in both `lang/en` and `lang/ar` (or module `Lang/`).
- **Resources whitelist fields explicitly.** Public resources (`PostResource`, `PublicProfileResource`, `CommentResource`) expose the anonymous profile only — never `user_id`, email, phone, or `users` relations.

## Authorization & security

- The account model is `App\Modules\Auth\Models\User` (private auth identity). Every authenticated route group uses `['auth:sanctum', 'account.active']` — the second blocks suspended/deactivated accounts holding valid tokens.
- Auth flows must not reveal whether an email has an account (same response for unknown email vs wrong password, forgot-password always 200, reset errors identical).
- API timestamps are formatted with `App\Support\Time\Iso8601::format()` (`2026-11-12T10:00:00Z`).
- Feature tests that make several authenticated requests call `forgetAuth()` between them (the guard caches the user).

- Every model with an owner has a **Policy**; every controller action calls `authorize()` / uses `can` middleware. Ownership queries are scoped: `$request->user()->medications()->findOrFail($id)` — never `Medication::find($id)` then check.
- Return `404` for another user's private records.
- Roles (user / moderator / admin) via a dedicated role/permission check; moderator & admin routes in separate route groups with their own middleware. Moderators have no route to journals or medication records.
- Admin access to sensitive data writes an `audit_logs` entry.
- Sanctum tokens: set expiration, support "logout from all devices" (revoke all tokens), rate-limit auth routes (`throttle:` named limiters).
- Passwords: `Hash` with **Argon2id** driver.
- Sensitive health columns (journal content, medication name/dosage/notes, experience text, symptom notes) use `encrypted` / `encrypted:array` casts. These columns cannot be searched in SQL — design around it.
- File uploads: validate MIME + extension + size, re-encode images, store on object storage with private visibility, serve via signed/temporary URLs. Never trust client filenames.
- No raw SQL with interpolated input. If `DB::raw`/`whereRaw` is needed, use bindings.
- Never log request bodies, health fields, tokens or PII. Use structured logging with context ids only.

## Database (PostgreSQL)

- UUID primary keys (`HasUuids`) on all tables.
- Foreign keys with explicit `cascadeOnDelete`/`restrictOnDelete` chosen deliberately per retention policy.
- `timestamptz` for all timestamps; app timezone is `UTC`.
- Index every foreign key and every column used in `where`/`orderBy` on hot paths (feeds, history lists).
- Unique constraints enforce business rules at DB level: `anonymous_profiles.username`, one reaction per (user, post), one follow per pair, one block per pair.
- Soft deletes only where retention policy justifies it; deleted/hidden content must be excluded by default (global scope) from all public queries.
- Migrations are forward-only once merged; never edit a merged migration.
- Every model has a Factory; seeders contain no real personal data.

## Performance

- Prevent N+1: eager load in queries; enable `Model::preventLazyLoading()` outside production.
- Cursor pagination (`cursorPaginate`) for feeds, comments, notifications; max page size enforced.
- Heavy work (insights calculation, image processing, push fan-out, data export, account deletion) runs in **queued jobs**. Jobs are idempotent, have `tries`/`backoff`, and receive ids — not models with health data — in their payloads.
- Cache with Redis using namespaced keys; never cache another user's private data under a shared key.
- Medication reminders are driven by the Scheduler, computed in the user's timezone and stop immediately when a medication is discontinued.

## Errors

- Centralized handling in `bootstrap/app.php` `withExceptions`: map domain exceptions, `ValidationException`, `AuthenticationException`, `AuthorizationException`, `ModelNotFoundException` to the standard error envelope with correct status codes.
- Never return stack traces or exception messages containing data to clients. `APP_DEBUG=false` outside local.

## API

- Routes under `/api/v1`, plural resource nouns, kebab-case paths, matching SRS §8 endpoints.
- Correct status codes: `201` create, `204` delete, `422` validation, `401`/`403`/`404`, `429` throttle.
- Keep the OpenAPI spec in sync with every route change.

## Testing (Pest)

- Feature test for every endpoint: happy path, validation failure, unauthenticated, **another user's record → 404**, blocked-user case where relevant.
- Unit tests for Actions/Services with non-trivial logic (schedules, DST, insights).
- Tests use `RefreshDatabase` against PostgreSQL (not SQLite — behaviour differs).
- `Queue::fake()`, `Notification::fake()`, `Storage::fake()` for side effects; assert that notifications contain no health data.
- CI must pass: `pint --test`, `phpstan`, `pest`, `composer audit`.
