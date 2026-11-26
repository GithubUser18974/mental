---
paths:
  - "mobile/**"
---

# Flutter Rules

Stack: Flutter 3.41 (stable), Dart 3.11, Riverpod 3 (hand-written providers), GoRouter, Dio, Freezed, json_serializable, flutter_secure_storage, shared_preferences (non-sensitive only), Hive/SQLite (encrypted), FCM, flutter_local_notifications.

App id `com.y.mindful`, Dart package `mindful`, display name "Y". API base URL via `--dart-define=API_BASE_URL=...` (default: Android emulator → local Docker).

## Language & style

- Lints: `very_good_analysis` (or `flutter_lints` + strict mode). `flutter analyze` must report zero issues. Enable `strict-casts`, `strict-inference`, `strict-raw-types`.
- Format with `dart format` (line length 100).
- No `dynamic` unless parsing raw JSON at the data boundary. No `!` null-assertion without a comment explaining why it's safe.
- Prefer `const` constructors and widgets. Prefer `final` everywhere.
- Files `snake_case.dart`, classes `PascalCase`, one public widget/class per file.
- No `print` — use a logger that is silenced in release and never receives health data or tokens.
- Generated files (`*.g.dart`, `*.freezed.dart`) are produced by `build_runner`; never hand-edit them.

## Architecture (feature-first Clean Architecture)

```text
lib/
  app/        app.dart, router/, theme/, localization/
  core/       network/, storage/, security/, errors/, widgets/, utils/
  features/<feature>/
    data/          datasources/  models/  repositories/   (impl)
    domain/        entities/  repositories/ (abstract)  usecases/
    presentation/  pages/  widgets/  providers/
```

- Dependency direction: `presentation → domain ← data`. `domain` is pure Dart — no Flutter, Dio, Hive or JSON imports.
- **No business logic in widgets.** Widgets render state and forward user intents to providers/notifiers.
- Features don't import each other's `data/` or `presentation/` internals. Share through `core/` or a domain interface. When core needs feature behaviour (e.g. server logout, session renewal), core defines a nullable provider **extension point** and `app/provider_overrides.dart` plugs the feature implementation in — core never imports features.
- `domain/usecases/` only when there is real logic to put there; screens may call a repository through a controller when the use case would be a pass-through.
- Shared visual building blocks live in `core/` (e.g. `core/avatar/AvatarView`, `core/widgets/FormPage`), not in one feature.
- `community`, `profile` features must never import from `tracking`, `medication` or `journal` (mirrors the backend privacy boundary). Journal → post sharing goes through an explicit use case with a user confirmation step.
- **Models vs entities:** `data/models` are Freezed + `json_serializable` DTOs matching the API (`snake_case` via `@JsonSerializable(fieldRename: FieldRename.snake)`); map them to `domain/entities` in the repository. UI never sees DTOs.

## State management (Riverpod)

- Providers are **hand-written** (`riverpod_generator` can't resolve alongside Freezed 3 on this SDK): `NotifierProvider` / `AsyncNotifierProvider` (+ `.autoDispose`) for mutable state; plain `Provider` for DI (Dio, repositories, use cases). Revisit codegen when the SDK is upgraded.
- HTTP goes through `core/network/ApiClient` (`apiClientProvider`) — it parses the envelope and throws typed `AppException`s. Show errors with `error.localizedMessage(l10n)` / `ErrorView`.
- Auth state lives in `authSessionProvider` (`AuthStatus`); the router guard is the pure `appRedirect()` function.
- Every async screen handles **loading, data, empty and error** states explicitly (`AsyncValue.when`).
- No global mutable singletons; inject via providers so tests can override them.
- Use `ref.watch` in `build`, `ref.read` in callbacks. Never `ref.watch` inside callbacks.
- Paginated lists use a dedicated notifier holding items + cursor + `hasMore` + loading flag.
- Dispose correctly: `autoDispose` by default; `keepAlive` only with a reason.
- On logout, invalidate all user-scoped providers so no previous user's data survives. User-scoped providers `ref.watch(authSessionProvider)` so they rebuild (and drop data) on sign-out.
- **Never capture a provider's own `Ref` in a closure that runs later** (Riverpod 3 disposes unlistened providers → "Ref used after dispose"). Extension-point callbacks take the *caller's* `Ref` as a parameter, and a notifier must never `ref.read` its own provider (return values instead).
- After every `await` inside a notifier, check `ref.mounted` before touching `state` or `ref`.
- Form submit controllers: `Notifier<AsyncValue<void>>` (`.autoDispose`) with `AsyncValue.guard`; screens show `ValidationException.firstErrorFor(field)` under fields and other errors via `showErrorSnackBar`.
- `ProviderScope(retry: (_, _) => null)`: no silent automatic retries; screens offer "Try again".

## Navigation (GoRouter)

- Single router in `app/router/`, paths as constants in `AppRoutes` — no string literals scattered in widgets.
- Auth guard via `redirect` driven by an auth-state provider (`refreshListenable`). Private health routes are unreachable when logged out.
- Deep links must not open private screens without authentication, and never carry health data in path/query params.

## Networking (Dio)

- One configured Dio instance in `core/network/` with interceptors for: auth token, `Accept-Language` (ar/en), 401 handling (refresh or logout), and error mapping.
- HTTPS only. No logging interceptor in release builds; debug logging must redact `Authorization` headers and request/response bodies of private endpoints.
- Parse the standard envelope (`success`, `message`, `data`, `errors`, `meta`) once, centrally.
- Repositories return `Result`/`Either`-style values or throw typed `AppException`s (`NetworkException`, `ValidationException` with field errors, `UnauthorizedException`, `NotFoundException`, `ServerException`) — never raw `DioException` to the UI.
- Retry only idempotent requests (GET, PUT, DELETE). Never auto-retry POSTs that create records.

## Storage & security

- Tokens only in `flutter_secure_storage`. Never in SharedPreferences, Hive, or logs.
- Journal, medication, mood and symptom data must **not** be stored unencrypted locally. If cached, use an encrypted Hive box / SQLCipher with the key held in secure storage. Default: don't cache them.
- SharedPreferences only for non-sensitive prefs (theme, locale, onboarding seen).
- Clear all local data, caches and secure storage on logout and account deletion.
- Hide sensitive screens from app switcher snapshots where feasible (journal, medications).
- Crash reporting / analytics: never attach health data, journal text, medication names or user identifiers beyond an opaque id.

## Notifications

- Local reminders (`flutter_local_notifications`) and push (FCM) use **generic text** — e.g. "Time for your reminder" — never medication names, dosages, or mood content.
- Reminders are scheduled with timezone awareness (`timezone` package) and cancelled when a medication is discontinued or the user logs out.

## UI, accessibility & localization

- All user-facing strings in ARB files (`app_en.arb`, `app_ar.arb`) via `flutter gen-l10n`. No hard-coded strings in widgets.
- RTL-safe layouts: use `EdgeInsetsDirectional`, `AlignmentDirectional`, `start`/`end` — never `left`/`right`. Test every screen in Arabic.
- Light and dark themes from `app/theme/`; use `Theme.of(context)` tokens — no hard-coded colors or text styles in widgets.
- Accessibility: semantic labels on icons/images, min tap target 48×48, support text scaling without overflow, sufficient contrast.
- Copy is empathetic and non-clinical; no diagnostic language in insights.
- Show offline/connectivity state; never silently drop a user's input (journal drafts persist encrypted until saved).
- Keep widgets small: extract sub-widgets as classes (not helper methods returning widgets) once a `build` grows beyond ~60 lines.

## Testing

- Unit tests for use cases, repositories (mock data sources), notifiers (`ProviderContainer` with overrides).
- Widget tests for each page covering loading/empty/error/data and RTL.
- Golden tests for key screens in light/dark and en/ar.
- Integration tests for auth flow, daily check-in, medication add + reminder, journal create, post create.
- Mocking with `mocktail`. Tests never hit the real API.
- Full-app flow tests: `pumpYApp()` (test/helpers) boots the real router/providers against a `FakeBackend` (route → JSON handler, records request bodies) via `httpClientAdapterProvider`, on a phone-sized viewport. Use `tapVisible()` for widgets inside scrolling forms.
- Unit tests of notifiers must keep them alive like the app does (`container.listen(provider, ...)`), and wait by polling for the expected state, not fixed sleeps.
- Freezed / json_serializable output (`*.freezed.dart`, `*.g.dart`) is committed; regenerate with `dart run build_runner build --delete-conflicting-outputs`.
- CI must pass: `dart format --set-exit-if-changed`, `flutter analyze --fatal-infos`, `flutter test`.
