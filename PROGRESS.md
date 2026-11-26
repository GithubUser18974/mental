# Project Progress & Task Plan

This file is the single source of truth for **where development stands**. Read it first when resuming work.

- Requirements: [srs.txt](srs.txt)
- Rules: [CLAUDE.md](CLAUDE.md), [.claude/rules/](.claude/rules/)
- Workflow: one task at a time → implement + tests → mark `🔍 review` → **user reviews** → mark `✅ done` → next task.

Status legend: `⬜ todo` · `🚧 in progress` · `🔍 awaiting review` · `✅ done` · `⏸ blocked`

## Current status

- **Active task:** T4.1 — awaiting user review (next: T4.2)
- **Last updated:** 2026-11-26

---

## Phase 0 — Foundation

| ID | Task | Status |
|---|---|---|
| T0.1 | Repo & backend scaffold: git, `.gitignore`, Docker dev stack (PHP 8.4-FPM, Nginx, PostgreSQL 16, Redis), Laravel install, Pint, Larastan, Pest, UTC/UUID defaults, `/api/v1/health` | ✅ |
| T0.2 | Backend core: API response envelope, centralized exception → JSON mapping, module auto-loading (`app/Modules/*`), rate limiters, structured logging w/ PII redaction, OpenAPI scaffold | ✅ |
| T0.3 | Flutter scaffold: project in `mobile/`, folder structure, lints, dependencies, design-system theme (light/dark), ar/en l10n + RTL, GoRouter skeleton, Dio client + envelope parsing + typed errors, secure storage | ✅ |
| T0.4 | CI: GitHub Actions for backend (pint, phpstan, pest, audit) and mobile (format, analyze, test) | ✅ |

## Phase 1 — Authentication & Identity

| ID | Task | Status |
|---|---|---|
| T1.1 | Backend **Auth**: users table, register/login/logout/logout-all/me, forgot/reset password, Sanctum tokens + expiry, Argon2id, throttling, 18+ confirmation (BR-001) | ✅ |
| T1.2 | Backend **Identity**: anonymous profile auto-generation (username + avatar), preferences (language/timezone), privacy settings, `/profile`, `/profiles/{username}` | ✅ |
| T1.3 | Flutter: splash, welcome, onboarding, register, login, password recovery, profile setup, privacy preferences, auth guard | ✅ |

## Phase 2 — Community

| ID | Task | Status |
|---|---|---|
| T2.1 | Backend posts: categories (seeded, admin-managed) + profile **topics of interest** (FR-ONB-002, deferred from T1.2), create/edit/delete post, hashtags, content warnings, image upload, feed (recent/popular/following/topic) w/ cursor pagination | ✅ |
| T2.2 | Backend comments (threaded), supportive reactions (1 per user/post), saved posts | ✅ |
| T2.3 | Backend follows, blocks (enforced across feed/search/comments/reactions/profiles), search & discovery | ✅ |
| T2.4 | Backend reports (posts/comments/profiles, reasons) → moderation queue | ✅ |
| T2.5 | Flutter: community home, feed, post details, create/edit post (category grid), comments, reactions | ✅ |
| T2.6 | Flutter: topic discovery, search, saved posts, followers/following, public profile, report & block flows | ✅ |

## Phase 3 — Mental Health Tracking

| ID | Task | Status |
|---|---|---|
| T3.1 | Backend moods, symptoms (categories), sleep, edit/delete, `/tracking/overview`, insights (queued, non-diagnostic) | ✅ |
| T3.2 | Flutter: daily check-in, mood selection, mood history, symptom & sleep tracking, insights | ✅ |

## Phase 4 — Medication

| ID | Task | Status |
|---|---|---|
| T4.1 | Backend medications (encrypted), schedules (timezone/DST-safe), intake logs, experiences, reminder scheduling that stops on discontinue | 🔍 |
| T4.2 | Flutter: medication list/add/details/schedule, intake history, experiences, local reminders (generic text) | ⬜ |

## Phase 5 — Private Journal

| ID | Task | Status |
|---|---|---|
| T5.1 | Backend journal entries (encrypted), tags, attachments, search/filter, explicit publish-to-community | ⬜ |
| T5.2 | Flutter: journal home, create/edit/details, search & filters, encrypted draft persistence, publish confirmation | ⬜ |

## Phase 6 — Progress Dashboard

| ID | Task | Status |
|---|---|---|
| T6.1 | Backend dashboard aggregates & personal milestones | ⬜ |
| T6.2 | Flutter progress dashboard & charts | ⬜ |

## Phase 7 — Notifications

| ID | Task | Status |
|---|---|---|
| T7.1 | Backend notifications, preferences, device registration, FCM delivery (queued, no health data in payloads) | ⬜ |
| T7.2 | Flutter: FCM setup, notification center, notification settings | ⬜ |

## Phase 8 — Safety & Moderation

| ID | Task | Status |
|---|---|---|
| T8.1 | Backend roles (user/moderator/admin), moderation actions (hide/remove/restrict/suspend), moderation logs, crisis-content detection workflow, crisis resources by country, audit logs | ⬜ |
| T8.2 | Flutter: crisis support resources screen, content warnings UI, community guidelines | ⬜ |

## Phase 9 — Administrative Dashboard

| ID | Task | Status |
|---|---|---|
| T9.1 | Admin web UI (Laravel): auth + RBAC, user management, categories, moderation queue, settings, notification templates, crisis resources, analytics, audit log viewer | ⬜ |

## Phase 10 — Account & Settings

| ID | Task | Status |
|---|---|---|
| T10.1 | Backend data export (queued) and account deletion workflow (anonymize/delete per policy, revoke sessions) | ⬜ |
| T10.2 | Flutter: my profile, edit profile, privacy/notification settings, blocked users, account security, data export, delete account, about & legal | ⬜ |

## Phase 11 — Hardening & Release

| ID | Task | Status |
|---|---|---|
| T11.1 | Full SRS §13.3 critical-scenario test suite, security review, performance checks (N+1, indexes, p95) | ⬜ |
| T11.2 | OpenAPI completeness, deployment docs (staging/production), Flutter integration tests & release builds | ⬜ |

---

## Decisions log

| Date | Decision |
|---|---|
| 2026-11-12 | Backend dev runs fully in Docker (no local PHP/Composer on dev machine). |
| 2026-11-12 | Monorepo: `backend/` (Laravel), `mobile/` (Flutter), `docs/`. |
| 2026-11-12 | App display name **"Y"**; bundle/application id **`com.y.mindful`** (iOS + Android). |
| 2026-11-12 | Laravel 13 on PHP 8.4 (satisfies SRS "PHP 8.3+"). |
| 2026-11-12 | UUID PKs everywhere incl. Sanctum tokens (`App\Models\PersonalAccessToken`); all timestamps `timestamptz`. |
| 2026-11-12 | Tests run on PostgreSQL `mental_test` DB (not SQLite); Argon2id hashing with low cost in tests only. |
| 2026-11-12 | Removed Laravel's abstract base `Controller` — controllers are `final` and standalone. Removed skeleton's Boost `CLAUDE.md`/`AGENTS.md` (conflicted with Docker-only setup). |
| 2026-11-12 | `users` table still has skeleton `name` column — will be reshaped (email/phone/status, no real name) in T1.1. |
| 2026-11-12 | OpenAPI spec hand-written as JSON at `docs/openapi/openapi.json` (no YAML lib → no new dependency). A test fails if any `/api/v1` route is missing from the spec or vice versa. Swagger UI on :8080. |
| 2026-11-12 | Error envelope omits `errors` when empty; client-facing error messages are always generic translations (never exception text). Missing/other-user records → 404. |
| 2026-11-12 | Module tests live in `tests/Feature/<Module>`; cross-module Eloquent relations allowed only toward Auth/Identity (shared kernel). |
| 2026-11-12 | Logs: redaction tap on every channel; DB exceptions logged with SQL placeholders only; `zend.exception_ignore_args=On`; `json` channel (stderr) for production. |
| 2026-11-12 | Arabic translations of Laravel's built-in validation messages still pending — do in T1.1 (first real validation). |
| 2026-11-12 | Flutter 3.41 / Dart 3.11. `riverpod_generator` incompatible with Freezed 3 on this SDK → Riverpod 3 providers written by hand. Freezed + json_serializable kept (`build.yaml`: snake_case). |
| 2026-11-12 | Fonts bundled (OFL): Urbanist variable + IBM Plex Sans Arabic as `fontFamilyFallback`. Weight changes must use `TextStyle.withWeight()` (variable-font axis). |
| 2026-11-12 | Palette tuned for WCAG AA (enforced by test): primary `#7C4DEB`, button gradient `#8455F0→#6D3AE0`, danger `#C23B57`; `primaryLight` is decorative only. |
| 2026-11-12 | Material outlined/rounded icons for now (no icon package). |
| 2026-11-12 | T1.1 scope: email + password only. Phone/OTP, Apple, Google sign-in later (SRS lists them as supported; phone column reserved). |
| 2026-11-12 | BR-001 via self-declared `age_confirmed` checkbox (timestamp stored, no birth date — data minimization). `terms_accepted` stores consent timestamp. |
| 2026-11-12 | Tokens: Sanctum, 30-day expiry (`SANCTUM_TOKEN_EXPIRATION`), prefix `y_`, `/auth/refresh` rotates token, `/auth/logout-all` added (FR-AUTH-003). Expired tokens pruned daily. |
| 2026-11-12 | Password policy: min 10, letters + numbers; breached-password check (HIBP k-anonymity) in production only. |
| 2026-11-12 | Dev Docker: php-fpm workers run as root (Windows bind mount can't be chown'd) — dev only; nginx re-resolves `app` via Docker DNS. |
| 2026-11-13 | Identity: anonymous profile id ≠ users.id; generated usernames `AdjectiveNoun####` (never from email); avatars = fixed catalog `icon-color` (12×8, no photo uploads). Username 3–20 chars, case-insensitive unique, reserved/impersonation list; **30-day cooldown** on username changes after setup (onboarding changes free). |
| 2026-11-13 | Privacy settings: `profile_visibility` public/private (private hides bio), `follow_policy` everyone/nobody (enforced in T2.3), `analytics_consent` default off. Preferences: language (en/ar, from registration locale), timezone (default UTC). Notification preferences → T7.1. |
| 2026-11-13 | Profiles require sign-in to view; suspended/deactivated → 404. Topics of interest moved to T2.1 (needs categories). Blocking on profiles applied in T2.3. |
| 2026-11-14 | Reset links: `PASSWORD_RESET_URL=ymindful://app/reset-password` (Android intent-filter + iOS URL scheme). Caveat: some email clients don't make custom-scheme links clickable — fine for dev/testing; needs an https domain before launch. |
| 2026-11-14 | Onboarding order: welcome → intro (5 slides, shown once) → register → profile setup (username/avatar/bio) → privacy → home. Privacy is saved before the profile; saving the profile marks setup complete and the router moves on. |
| 2026-11-14 | Sessions: token expiry stored in secure storage; tokens with < 7 days left are renewed on app start. Sign-out = server revoke (best effort) + wipe secure storage. |
| 2026-11-14 | Device timezone not yet sent (needs an IANA-timezone plugin, not in stack) — do with reminders in T4.2; server default UTC meanwhile. |
| 2026-11-15 | Posts reference `anonymous_profiles` (`author_profile_id`), never `users`. Visibility (author: community / only_me) is separate from moderation status (visible / under_review / hidden / removed). Others see only community+visible; authors also see their own non-removed posts. Deleted = soft delete → 404 everywhere. |
| 2026-11-15 | Content warnings = fixed list (self_harm, suicide, eating_disorder, substance_use, abuse_trauma, sensitive) — app blurs behind a label. **Popular feed** = last 7 days by `score` (filled by reactions/comments in T2.2), **excludes posts with a content warning** (FR-COM-001 no amplification). |
| 2026-11-15 | Images: separate upload (`POST /media`), re-encoded with GD → all EXIF/GPS removed, max 2048 px, JPEG (or WebP if PNG/WebP), private disk, 30-min signed URLs; max 4 per post; orphans pruned daily. Image processing is synchronous (bounded 8 MB) — move to a queue if uploads get slow. |
| 2026-11-15 | Topics of interest = categories (`profile_interests`) via `GET/PUT /profile/interests` in the Community module. Mobile setup step for interests → T2.5. Following feed & public interests on profiles → T2.3/T2.6. |
| 2026-11-15 | Comments: **one level of threading** (replying to a reply attaches to its top-level comment), max 1000 chars, oldest first. Visibility follows the post (post not visible → comments 404). A deleted/moderated top-level comment with visible replies stays as an anonymous placeholder (`is_removed`, no text/author). Only the comment author may edit/delete (post author can't delete others' comments — SRS says "own"). `allow_comments=false` → 403 for everyone. |
| 2026-11-15 | Reactions: 5 SRS types (`understand`, `support`, `not_alone`, `proud`, `thank_you`), one per member per post (unique index; another type replaces). API exposes **counts only, never who reacted**. Score = reactions×1 + visible comments×2, recomputed from source rows, **excluding the author's own** reactions/comments. |
| 2026-11-15 | Saved posts: private, idempotent, newest-saved first; posts no longer visible drop out of the list. `PostResource` now carries `reactions`, `comments_count`, `is_saved` (loaded in the same query — no N+1). Events `PostReacted` / `CommentCreated` (ids only, never the actor) are emitted for Phase 7 notifications; no listeners yet. New `reactions` rate limit (60/min) for reactions & bookmarks. Malformed `{post}`/`{comment}` ids → 404. |
| 2026-11-26 | Follows & blocks live in **Identity** (`profile_follows`, `profile_blocks`, between anonymous profiles); other modules use the `SocialGraph` service only. Blocking is **symmetric for content**: either side blocking hides each from the other in feeds, post details, comments (thread placeholders if they have replies), saved list, profile posts, search; every interaction → 404. Block removes follows both ways. The blocker can still open the blocked profile (to unblock; bio hidden); the blocked member gets 404. Blocking someone who already blocked you succeeds silently (no leak). |
| 2026-11-26 | Follow permission `nobody` → 403 on new follows; **existing followers are kept** when switching. Follower/following/blocked lists are **owner-only** (no public lists); public profile shows counts + your `relationship`. Following feed = `GET /posts?following=1`. |
| 2026-11-26 | Search (FR-COM-008): post text `GET /posts?q=` (combinable with category/hashtag/following), `GET /search/profiles` (usernames, prefix-first, max 20), `GET /search/hashtags` (with public post counts), `GET /hashtags/trending` (7 days, **posts with content warnings never count**). Topics/categories = category filter. Literal matching (LIKE wildcards escaped), `pg_trgm` GIN indexes, `search` rate limit 60/min. Public interests on profiles deferred to T2.6 (needs profile-privacy rules). |
| 2026-11-26 | Reports live in the new **Moderation** module (`reports`: polymorphic target post/comment/profile, no FK so reports survive deletion, owner profile captured at report time). Reasons = SRS FR-COM-010 list (`other` requires details ≤ 500). **Priority from reason**: suicidal content / self-harm encouragement = critical, harassment / dangerous medical advice = high, spam / other = normal; response flags `crisis_support` for critical reasons (app shows crisis resources, FR-SAFETY-002). One pending report per member per target (partial unique index; repeat → 200 with existing). Only visible targets reportable (404 otherwise); own content → 422; a profile you blocked stays reportable. Reporter never revealed; details never logged. **No automatic hiding** on report counts (SRS: automation must not be the sole basis for decisions) — moderators decide in T8.1. Queue = pending reports grouped per target, critical → most reporters → oldest (`BuildReportQueue`). `ContentReported` event for the T8.1 safety workflow. |
| 2026-11-26 | Mobile shell: bottom navigation (Community, Me); Me = identity + sign-out until T2.6/Phase 10. Community = greeting + disclaimer ("personal experiences, not medical advice", BR-011) + segmented Recent/Popular/Following + category chips + feed. Posts render through one **post store** (optimistic reactions/saves, edits, deletes, comment counts update every screen; reverted on failure). Feed → detail hands the post over for instant display. Content warnings blur posts until "Show post"; suicide/self-harm also show a gentle "contact emergency services / someone you trust" hint. Comment edit/delete in a menu; reply-to chip; removed comments as placeholders. |
| 2026-11-26 | **Image upload in the composer is pending** — needs `image_picker` (not in the agreed stack; asked the user). Existing post images display (signed URLs; calm placeholder when expired). Interests step in onboarding moved to T2.6 (with discovery). |
| 2026-11-26 | Tracking data belongs to the **account** (`user_id`), never the anonymous profile; community/moderation/identity can't use the module (arch test). Check-in = `mood` (required, 5 SRS options) + optional 1–10 score/anxiety/stress/energy + notes. Multiple check-ins per day allowed. Symptoms: admin-configurable categories (8 SRS examples seeded) + severity 1–10, optional duration (≤ 7 days) and notes. Sleep: duration (≤ 24 h) + optional quality; attributed to the wake-up day. Notes encrypted at rest; entries **hard-deleted** on delete; history filters by local days in the member's timezone (`user_preferences.timezone`, via Identity `AccountPreferences`). |
| 2026-11-26 | Insights (FR-TRACK-005): recomputed by a queued, unique, after-commit job (account id only) after every change; stored encrypted as `{key, params}` and rendered in the reader's language, always with a "not a medical assessment" disclaimer. Rules (product choices — review): trends compare last 14 days vs the 14 before, need ≥ 3 entries in each, "higher/lower" at ≥ 0.75 points; most frequent mood (30 days, ≥ 3 entries, ties → most recent); sleep pattern = mood after ≥ 7 h vs < 6 h sleep (≥ 3 days each, worded as a pattern, never a cause); milestones = first check-in, 7-day streak, 30 check-ins (habit only, never "recovery"). Streak = consecutive local days, not broken until the day ends. |
| 2026-11-26 | Mobile tracking: new **Track** tab (Community · Track · Me), built only when opened so no health data is fetched up front; tracking data lives only in memory (autoDispose providers, wiped on sign-out) — **no local cache**. Charts are drawn in-app (no chart package): 7-day bar strip + month mood calendar. Optional scales start empty ("Add") so skipping never records a made-up value. "Very sad" uses a frowning face (the Material "very dissatisfied" icon has X-eyes — inappropriate here). Sleep is logged as hours in half-hour steps; symptom duration as preset chips. Not yet: hiding tracking screens from the app switcher (needs a platform flag/plugin — revisit with journal in T5.2). |
| 2026-11-26 | Medication (FR-MED-*): member-maintained records, **not prescriptions**; owned by the account. Encrypted: name, dosage, instructions, clinician, notes, log notes, experience text (so lists sort by date added; the app sorts by name). Units = fixed list. One schedule per medication: `daily` (1–8 times), `weekly` (ISO weekdays), `interval` (every 2–90 days from start), `as_needed`; temporary = start/end dates. Status active / paused / discontinued (discontinued_at stamped). Hard delete with schedule, logs, experiences. |
| 2026-11-26 | Reminders: SRS asks for **local notifications** → the backend exposes `GET /medications/doses` (local days, ≤ 31) for **active** medications, ids only (no names), each with `reminder` and its log; the app schedules notifications from it (T4.2). Times are wall-clock in the member's **current** timezone (follows travel); DST: nonexistent times move forward, repeated times fire once. Paused/discontinued → no doses (SRS §13.3 #7). Logging the same scheduled dose again updates it; `taken_at` required for taken/delayed only. "Missed" is recorded by the member (no automatic marking yet — revisit with adherence in T6.1). |
| 2026-11-12 | CI = GitHub Actions (backend + mobile workflows, path-filtered) + Dependabot. Deploy stages (SRS §14.3 steps 8–9) deferred to T11.2 (no hosting chosen yet). Android APK build runs on pushes only, not PRs. |
| 2026-11-12 | Debug-only `/dev/design` showcase route; welcome "Get started" opens it until T1.3. Android debug build allows cleartext to local API; iOS `NSAllowsLocalNetworking`. |

## Open questions for the user

- Admin panel tech (T9.1): Filament vs. custom Blade — decide before Phase 9.
- ~~Registration email enumeration~~ → 2026-11-13: keep current behavior for v1; revisit with email verification.
- ~~Email verification~~ → 2026-11-13: later (not in v1 scope yet).
- Password reset link: **no domain yet** → app uses custom scheme `ymindful://app/reset-password` (decided 2026-11-14). Switch to an https universal link when a domain exists (same in-app route).
- ~~App name / bundle id~~ → answered 2026-11-12 (see decisions log).

## Session log

### 2026-11-12
- Wrote project rules (CLAUDE.md, php-laravel, flutter, design-system).
- Created this task plan. Started T0.1.
- **T0.1 finished** (awaiting review):
  - `git init` (nothing committed yet), root `.gitignore`.
  - `backend/`: Laravel 13 + Sanctum (`install:api`), Docker stack in `backend/docker-compose.yml` + `backend/docker/` (php, nginx, postgres init creating `mental_test`).
  - `.env`/`.env.example`: pgsql, redis cache/queue/session, argon2id, encrypted sessions.
  - `AppServiceProvider`: strict models (non-prod), prohibit destructive DB commands (prod), immutable dates, UUID Sanctum token model.
  - `GET /api/v1/health` (`app/Http/Controllers/Api/V1/HealthController.php`) — DB + Redis checks, no error detail leakage.
  - Tooling: `pint.json` (strict types enforced), `phpstan.neon` (Larastan L8), Pest + arch tests, composer scripts `lint|format|analyse|test|ci`.
  - Verified: pint ✔, phpstan ✔ (0 errors), pest 7/7 ✔, composer audit ✔, live health endpoint ✔.
- **T0.1 approved.** Started T0.2.
- **T0.2 finished** (awaiting review):
  - `app/Support/Http/ApiResponse` (success/created/noContent/error + normalized `meta.pagination`), `app/Support/Exceptions/ApiException` + `ApiExceptionRenderer` (422/401/403/404/405/413/429/5xx → envelope, generic translated messages).
  - API middleware (prepended to `api` group): `AssignRequestId` (`X-Request-Id` + log Context), `ForceJsonResponse`, `SetLocaleFromHeader` (ar/en, `Content-Language`); `throttle:api` on all API routes.
  - Modules: `App\Support\Modules\ModuleServiceProvider` base + `App\Providers\ModulesServiceProvider` auto-discovery and module factory guessing. Health endpoint moved to `app/Modules/System`.
  - `RateLimitServiceProvider`: `api`, `auth`, `password-reset`, `writes`, `reports`, `uploads` (hashed identifiers in keys).
  - Logging: `RedactingProcessor` + `RedactSensitiveData` tap; `json` channel.
  - `lang/en/api.php`, `lang/ar/api.php`; `Message::get()` typed translation helper.
  - `docs/openapi/openapi.json` + Swagger UI service; `../docs` mounted into containers.
  - Rules updated in `.claude/rules/php-laravel.md`.
  - Found & fixed during verification: DB exception messages (with bound emails) leaked into log message line; `QueryException` extends `PDOException` ordering bug.
  - Verified: `composer ci` ✔ (pint, phpstan 0 errors, pest 39/39, audit clean); end-to-end log check shows no PII.
- **T0.2 approved.** Started T0.3.
- **T0.3 finished** (awaiting review):
  - `mobile/` Flutter app `com.y.mindful` "Y" (Android + iOS), RTL enabled, iOS `CFBundleLocalizations` en/ar, `allowBackup=false`.
  - Theme: `app/theme/` (`AppPalette` ThemeExtension light/dark, `AppSpacing/AppRadius/AppSizes/AppMotion`, `AppShadows`, `AppTypography`, `AppTheme`, `ThemeModeController`).
  - Widgets: `PrimaryButton`, `SecondaryButton`, `CircleIconButton`, `AppCard`, `ContextBadge`, `SelectableTile`, `PillOption`, `RoundSelector`, `AppBackground`, `LoadingView/EmptyView/ErrorView`.
  - l10n: ARB en/ar in `app/localization/arb`, `LocaleController` (persisted).
  - Core: `ApiClient` + `dioProvider` (auth/locale/retry interceptors, debug log w/o bodies), `ApiEnvelope`/`CursorPagination`, sealed `AppException` + `mapDioException` + localized messages, `TokenStorage` (secure storage), `AuthSession`.
  - Router: GoRouter with auth guard (`appRedirect`), splash → welcome / home.
  - Verified: `flutter analyze` 0 issues, `flutter test` 41/41, debug APK builds, ran on Pixel 9a emulator (EN light, AR RTL, dark) — screenshots in `docs/screenshots/t0.3/`.
  - Found & fixed during verification: variable-font weights not applied (`withWeight`), danger color failed AA contrast.
- **T0.3 approved.** Started T0.4.
- **T0.4 finished** (awaiting review):
  - `.github/workflows/backend.yml`: PHP 8.4 + Postgres 16 + Redis 7 services; composer validate, Pint, Larastan (GitHub annotations), Pest, composer audit.
  - `.github/workflows/mobile.yml`: Flutter 3.41.2; gen-l10n, format check, analyze `--fatal-infos`, tests (GitHub reporter); debug APK build + artifact on push.
  - `.github/dependabot.yml`: composer, pub, docker, github-actions.
  - Root `README.md` (layout, quick start, CI).
  - Verified: `actionlint` 1.7.7 clean on both workflows; every CI command run locally and passing. Workflows not yet executed on GitHub (no remote configured).
- **T0.4 approved.** Started T1.1 (scope confirmed: email + password only).
- **T1.1 finished** (awaiting review):
  - New `app/Modules/Auth`: `User` + `PersonalAccessToken` models (moved from `app/Models`), `AccountStatus` enum, migrations (users w/o name + lowercase/status CHECK constraints, password_reset_tokens, tokens), factory.
  - Endpoints: `POST /auth/register|login|refresh|logout|logout-all|forgot-password|reset-password`, `GET /auth/me`.
  - Actions: `RegisterUser` (fires `UserRegistered` for T1.2), `AuthenticateUser` (timing-safe, generic errors, blocks inactive), `IssueAccessToken`, `SendPasswordResetLink`, `ResetPassword` (revokes all tokens).
  - `account.active` middleware; queued localized `ResetPasswordNotification` with app deep link.
  - `lang/ar/validation.php` (Arabic validation messages + attribute names); module `Lang/en|ar/messages.php`.
  - OpenAPI: 8 auth paths + `Account`/`AuthToken` schemas.
  - Tests: 30 new (register, login, sessions, password reset, enumeration, throttling, Arabic).
  - Found & fixed: dev stack returned 500 on any request that logs (storage not writable by php-fpm); nginx 502 after app rebuild.
  - Verified: `composer ci` ✔ (pint, phpstan 0, pest 76/76, audit), live smoke test (register → me → refresh → old token 401 → forgot-password (ar) → queued Arabic email with reset link), no password/token in logs.

### 2026-11-13
- **T1.1 approved.** Decisions: email verification later; no domain yet. Started T1.2.
- **T1.2 finished** (awaiting review):
  - New `app/Modules/Identity`: `AnonymousProfile`, `UserPreference`, `UserPrivacySetting` models + migration (case-insensitive unique username index, CHECK constraints); `AvatarCatalog`, `UsernamePolicy`, `UsernameGenerator`.
  - `EnsureIdentity` (idempotent, collision-safe via savepoints) runs on `UserRegistered` inside the registration transaction; `UpdateProfile` (setup completion, cooldown).
  - Endpoints: `GET|PUT /profile`, `PUT /profile/preferences`, `PUT /profile/privacy`, `GET /profile/username-availability`, `GET /profile/username-suggestions`, `GET /profile/avatar-options`, `GET /profiles/{username}`.
  - OpenAPI: 8 paths + `OwnProfile`/`PublicProfile` schemas. en/ar messages.
  - Tests: 48 new (creation & collision retry, rollback, own profile, validation matrix, cooldown, privacy hides bio, SRS §13.3 #4 no credentials in public profile, 404 for inactive accounts, rate limit, Arabic).
  - Fix: `PersonalAccessToken` made non-final (Sanctum::actingAs mocks it).
  - Verified: `composer ci` ✔ (pint, phpstan 0, pest 124/124, audit); live two-user smoke test (generated identity in ar, suggestions, profile setup, public view, private hides bio).

### 2026-11-14
- **T1.2 approved.** Started T1.3.
- **T1.3 finished** (awaiting review):
  - Screens: splash (with retry/sign-out on error), welcome, onboarding intro (FR-ONB-001, 5 slides), register (18+ & terms consents), login, forgot password (non-revealing), reset password (deep link), profile setup step 1 (avatar picker, username w/ live availability + shuffle, bio) and step 2 (privacy), placeholder home with sign-out.
  - Data/domain: `authentication` + `profile` features (Freezed DTOs → entities, repositories over `ApiClient`); controllers per form; `currentProfileProvider` + `setupStatusProvider` drive routing.
  - Core: `AvatarView`/`AvatarCatalog`, `AppTextField`, `ConsentCheckbox`, `FormPage`, `Validators`, error snackbar; sign-out & session-renewal extension points wired in `app/provider_overrides.dart`.
  - ~100 new en/ar strings; Android/iOS `ymindful://` scheme; backend `PASSWORD_RESET_URL`.
  - Tests: 67 (router guard matrix, full-app flows vs `FakeBackend`: register→setup→home, login, 401→welcome, offline sign-out, splash retry, forgot/reset, renewal, avatar picker).
  - Found & fixed: Riverpod disposed-`Ref` bug that silently broke token renewal; provider reading itself; header badge overflow; avatar picker one-per-row layout; faint checkboxes.
  - Verified on Pixel 9a emulator against the real Docker API: intro → register (client validation, consents) → setup (avatar, shuffle) → privacy → home → sign-out → reset deep link. Screenshots in `docs/screenshots/t1.3/`.

### 2026-11-15
- **T1.3 approved.** Started T2.1.
- **T2.1 finished** (awaiting review):
  - New `app/Modules/Community`: migration (categories seeded with the 7 SRS categories in en/ar, interests, posts w/ soft delete + CHECK constraints, media, hashtags), models, `PostPolicy`, `SavePost`, `BuildFeed`, `StorePostMedia` + `ImageSanitizer`, `HashtagExtractor` (Arabic + Latin), `community:prune-orphan-media` (scheduled daily).
  - Endpoints: `GET /categories`, `GET|PUT /profile/interests`, `POST /media`, `GET|POST /posts`, `GET|PUT|DELETE /posts/{post}`, `GET /profiles/{username}/posts`.
  - OpenAPI: 10 operations + Category/Media/Post/PostInput schemas.
  - Tests: 57 new (CRUD, authorization 403/404 matrix, SRS §13.3 #6 deleted posts & #8 no posting for others, no account data in responses, media ownership, feed ordering/filters/pagination, popular-feed safety, EXIF stripping, downscaling, file-type spoofing, N+1 guard, rate limit, Arabic).
  - Verified: `composer ci` ✔ (pint, phpstan 0, pest 181/181, audit); live smoke test (upload → sanitized WebP 912×2048, post with Arabic hashtag, feed, signed URL 200, forged signature 403).- **T2.1 approved.** Started T2.2.
- **T2.2 finished** (awaiting review):
  - Migration `comments` (one-level threads, soft delete, moderation status), `post_reactions` (unique per post+profile, CHECK on type), `saved_posts`. Models `Comment`, `PostReaction`, `SavedPost` + factories; `CommentPolicy`.
  - Actions: `SaveComment`, `BuildCommentThread` (placeholders for removed comments with replies), `ReactToPost` (upsert), `BookmarkPost`, `RefreshPostScore` (recomputed, author's own engagement excluded). `Post::withEngagement()` adds counts / my reaction / is_saved in the same query.
  - Endpoints: `GET|POST /posts/{post}/comments`, `GET /comments/{comment}/replies`, `PUT|DELETE /comments/{comment}`, `POST|DELETE /posts/{post}/reactions`, `POST|DELETE /posts/{post}/save`, `GET /saved-posts`. Events `CommentCreated`, `PostReacted` for Phase 7.
  - Larastan now reads module migrations (`databaseMigrationsPath`) so column checks cover module tables. `actAs()` test helper moved to `tests/Pest.php`.
  - OpenAPI: 10 operations + Comment/CommentInput/ReactionSummary schemas; Post gains `reactions`, `comments_count`, `is_saved`.
  - Tests: 48 new (comment CRUD + 403/404 matrix, flattening, comments-off, placeholders, reply pagination, reactions one-per-member, counts without reactor identity, score rules, saved privacy & drop-out, cursor pagination, N+1 guard for comments).
  - Verified: `composer ci` ✔ (pint, phpstan 0, pest 229/229, audit); live smoke test (react → change type, Arabic comment, reply, delete parent → placeholder + reply still reachable, save → saved list with counts, score = 1).

### 2026-11-26
- Ran the app on the Android emulator against the Docker backend (user request).
- **T2.2 approved.** Started T2.3.
- **T2.3 finished** (awaiting review):
  - Identity: migration `profile_follows` / `profile_blocks` (unique pairs, no-self CHECKs) + username trigram index; `SocialGraph` (scoped service, hidden-id cache), `CurrentProfile` (per-request viewer), `ManageConnection`, `ListConnections`, `ProfileFollowed` event; `AnonymousProfile::active()` / `withUsername()` scopes; `{profile}` route binding = active profiles only.
  - Endpoints: `POST|DELETE /profiles/{profile}/follow`, `POST|DELETE /profiles/{profile}/block`, `GET /profile/followers|following|blocks`, `GET /search/profiles`, `GET /search/hashtags`, `GET /hashtags/trending`; `GET /posts` gains `following` and `q`; public profile gains `stats` + `relationship`.
  - Block enforcement in Community: `BuildFeed` (all feeds, saved, search), `PostPolicy` (view → 404 both ways, covers comments/reactions/saves), comment lists & replies (placeholders), reply targets, profile posts.
  - Infra: `pg_trgm` extension migration, `App\Support\Database\LikePattern`, `search` rate limiter. Symfony packages patched 8.1.11 → 8.1.12 (5 new advisories published 2026-11-25 made `composer audit` fail).
  - Fixed while testing: follow-policy check compared an enum to a string (would have let anyone follow "nobody" profiles).
  - OpenAPI: 9 new operations + ProfileCard/Hashtag schemas; PublicProfile and feed params updated.
  - Tests: 39 new (follow/unfollow/policy/self, block both directions × feeds/post/comments/reactions/saves/profile/search, placeholders, owner-only lists, inactive members, literal search, Arabic search, trending safety).
  - Verified: `composer ci` ✔ (pint, phpstan 0, pest 268/268, audit); live smoke test (follow → following feed, text/username/hashtag search, trending; block → 404s, follow removed, hidden from search).
- **T2.3 approved** (after re-running the app on the emulator — no visible change expected: T2.1–T2.3 are backend-only). Started T2.4.
- **T2.4 finished** (awaiting review):
  - New `app/Modules/Moderation`: `reports` migration (CHECKs, partial unique index for pending reports), `Report` model + factory, enums `ReportReason` (with priority + crisis flag), `ReportPriority`, `ReportStatus`, `ReportTargetType`; actions `SubmitReport`, `ListOwnReports`, `BuildReportQueue`; `ContentReported` event; en/ar messages.
  - Community exposes `ContentLookup` (visible post/comment → author) so Moderation never touches Community tables.
  - Endpoints: `POST /reports` (throttle `reports` 20/h), `GET /reports` (own). OpenAPI: 2 operations, `Safety` tag, Report/ReportInput schemas.
  - Tests: 28 new (all target types, priorities, crisis flag, dedupe + re-report after resolution, 404 matrix incl. blocks, own content, validation, reporter anonymity, no details in logs, rate limit, queue ordering).
  - Verified: `composer ci` ✔ (pint, phpstan 0, pest 298/298, audit); live smoke test (Arabic message, critical priority, dedupe 200, own-content 422).
- **T2.4 approved.** Started T2.5.
- **T2.5 finished** (awaiting review):
  - `features/community`: domain entities (Post, Comment, Category, ReactionSummary w/ optimistic prediction, enums), Freezed DTOs, `CommunityRepository(Impl)`; providers: `postStoreProvider`, `postActionsProvider`, `feedControllerProvider` (family, cursor paging), `commentsControllerProvider` (top-level + reply threads), `postComposerController`, `categoriesProvider`, `postDetailProvider`.
  - Screens: app shell (`HomePage` with NavigationBar), `CommunityPage`, `PostDetailPage`, `PostComposerPage` (create/edit), `MePage`. Widgets: PostCard, FeedTabs, CategoryFilter, FeedSliver, ContentWarningCover, ReactionPicker, ActionWell, HashtagText (Arabic + Latin), PostImages, CommentThread/Tile, CommentInputBar, composer options. Theme: navigation bar, popup menu, dialog. `ApiClient.postNoContent` for 204 POSTs. Routes `/posts/new`, `/posts/:id`, `/posts/:id/edit`. 92 en/ar strings.
  - Tests: 28 new (feed states, pagination, following/category query, CW reveal + crisis hint, reaction + revert on failure, save, delete own post, no menu on others' posts, comments add/reply/thread/placeholder/delete/comments-off, 404 post, composer validation/submit/server errors, RTL Arabic, unit: reaction prediction, DTO mapping incl. verbatim API contract, relative time). Existing sign-out tests now open the Me tab.
  - Found on the emulator (not by tests): the category DTO required an `id` the API doesn't send → fixtures now mirror the real resources + a verbatim-response contract test. Also: feed tabs didn't fit a phone width (Following off-screen) → equal-width segmented control.
  - Verified: `dart format`, `flutter analyze --fatal-infos` 0, `flutter test` 95/95; on the Pixel emulator against the Docker API: feed (Arabic RTL post, CW blur), post detail with comments, reaction picker → optimistic update, comment saved under the pseudonym, feed counts updated without refetch, composer category grid. Screenshots in `docs/screenshots/t2.5/`.
- User asked to proceed autonomously until 3 pm → T2.5 treated as approved; T2.6 built without a review stop. `image_picker` not added (awaiting the user's answer).
- **T2.6 finished** (awaiting review):
  - Domain/data: `social.dart` entities (PublicProfile, Relationship, MemberCard, HashtagStat, ReportReason/TargetType, ReportReceipt), `SocialRepository(Impl)` + Freezed DTOs.
  - Providers: generic `PagedController<T>` (cursor paging) → `postListProvider` (saved / profile / hashtag / search sources) and `memberListProvider` (followers / following / blocked); `publicProfileProvider`, `trendingHashtagsProvider`, `socialActionsProvider` (follow / block reload affected lists).
  - Screens: `PublicProfilePage` (stats, follows-you, follow/unfollow, block with confirm, report, posts; blocked → notice + Unblock, own → no actions), `SearchPage` (posts / people / hashtags, debounced, trending when idle), `PostListPage` (saved, hashtag feed), `MembersPage` (followers / following / blocked with Unblock), Me tab links. Report sheet for posts, comments, profiles (6 SRS reasons, "something else" needs details, crisis-support dialog when the server flags it). Authors tappable → profile. Shared `SegmentedPills` in core. Search button in the community header.
  - Found while testing: menu items without a value never fire `onSelected` → "Report" did nothing; fixed (tests caught it). Greeting truncated with two header buttons → smaller title style.
  - Tests: 12 new flow tests (report + crisis dialog + details rule, profile follow/block/self, saved, blocked → unblock, followers empty, trending → hashtag feed, post & people search, min length). `flutter test` 107/107, analyze 0, format clean.
  - Verified on the emulator against the Docker API: report menus, profile → Follow (count 0 → 1, "Following ✓", posts listed), search with trending hashtags (warned post's hashtag excluded, Arabic tag shown). Screenshots in `docs/screenshots/t2.6/`.
  - Not done in T2.6 (carried over): interests step in onboarding + public interests on profiles (needs a backend endpoint respecting profile privacy); image upload (needs `image_picker` decision).
- First git commit `93c27d8` (Phases 0–2) at the user's request. `health/` (empty folder with an empty nested git repo, not created by Claude) left untracked.
- **T2.6 approved** ("continue"). Started T3.1.
- **T3.1 finished** (awaiting review):
  - New `app/Modules/Tracking`: migration (mood/symptom/sleep entries with CHECK ranges, symptom categories seeded en/ar, `tracking_insights`), models with `ownedBy()` scope + factories, `Mood` enum, `TrackingEntries` (owner-scoped CRUD, hard delete, dispatches refresh), `BuildOverview`, `ComputeInsights`, `RefreshInsights` job (unique, after commit, retries), `LocalDays` (timezone days, streak). Identity gains `AccountPreferences::timezone()`.
  - Endpoints (SRS §8.5): `GET|POST /tracking/moods`, `GET|PUT|DELETE /tracking/moods/{id}`, same for `symptoms` and `sleep`, `GET /tracking/symptom-categories`, `GET /tracking/overview`, `GET /tracking/insights`. New `tracking` rate limit (60/min). OpenAPI: 15 operations + schemas, `Tracking` tag.
  - Tests: 46 new (SRS §13.3 #3 cross-user 404 for all entry types, #10 invalid mood scores, partial edit, hard delete, encryption at rest, timezone day filtering, categories active/localized, symptom & sleep validation, overview incl. other users' data excluded, streak, insight rules & minimum data, non-diagnostic wording check en, ar rendering, queued job carries no health data, insights owner-only).
  - Verified: `composer ci` ✔ (pint, phpstan 0, pest 344/344, audit); live smoke test with the real Redis queue worker (check-in + sleep + symptom → insights computed in the background, overview averages, notes encrypted in Postgres).
- **T3.1 approved.** Started T3.2.
- **T3.2 finished** (awaiting review):
  - `features/tracking`: entities, Freezed DTOs, `TrackingRepository(Impl)` (follows cursors for month ranges), providers (overview, insights, symptom categories, month history, entry by id, `TrackingActions` refreshing summaries after every change).
  - Screens: `TrackPage` (check-in card, streak, 7-day chart, averages, quick log, top symptoms, insights preview, history link), `CheckInPage` (mood picker + optional scales + private notes; edit & delete), `SymptomLogPage` (category tiles, severity, duration chips), `SleepLogPage` (hours slider, quality), `HistoryPage` (Moods/Symptoms/Sleep × month navigation, mood calendar), `InsightsPage` (observations, milestones, disclaimer). Widgets: `MoodPicker`, `ScaleField`, `WeekChart`, `MonthCalendar`, entry form actions. Slider theme. `ListPageScaffold` moved to `core/widgets` (shared by features).
  - Tests: 9 new flow tests (no tracking requests before the tab opens, first-check-in state, latest/streak/averages, check-in validation + body with skipped scales null, symptom, sleep defaults, history range query + edit + delete, insights + disclaimer, Arabic RTL). `flutter test` 116/116, analyze 0.
  - Verified on the emulator against the Docker API: empty Track tab → check-in (Good + mood score) → overview updates (streak 1, chart bar, average 5) and the server-computed insight appears. Screenshots in `docs/screenshots/t3.2/`.
- **T3.2 approved.** Started T4.1.
- **T4.1 finished** (awaiting review):
  - New `app/Modules/Medication`: migration (medications, schedules, logs with one-per-dose partial unique index, experiences; CHECKs), enums (status, unit, schedule type, intake status, experience kind), models (encrypted casts, `ownedBy`) + factories, `DoseCalendar` (timezone/DST-safe expansion), actions `SaveMedication`, `ListMedications`, `BuildDoses`, `RecordIntake`, `FindMedication` (owner-scoped 404s).
  - Endpoints (SRS §8.6 + extras): `GET|POST /medications`, `GET|PUT|DELETE /medications/{id}`, `GET|POST /medications/{id}/logs`, `DELETE …/logs/{logId}`, `GET|POST /medications/{id}/experiences`, `DELETE …/experiences/{experienceId}`, `GET /medications/doses`. OpenAPI: 12 operations, `Medication` tag.
  - Tests: 45 new (every schedule type, SRS §13.3 #1 cross-user 404 on every route, #7 discontinue/pause stops doses, #9 invalid records, encryption at rest, current vs past, partial edit, cascade delete, intake upsert & validation, experiences, timezone-aware doses, weekdays/interval/temporary, DST spring-forward & fall-back incl. nonexistent/repeated times, timezone change).
  - Verified: `composer ci` ✔ (pint, phpstan 0, pest 389/389, audit); live smoke test (doses listed, intake recorded, discontinue → no doses, name encrypted in Postgres).
