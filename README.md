# Y — anonymous mental health community & wellness tracker

Monorepo for the **Y** app (`com.y.mindful`).

| Path | What |
|---|---|
| [`backend/`](backend/) | Laravel 13 / PHP 8.4 REST API (`/api/v1`), PostgreSQL, Redis — runs in Docker. See [backend/README.md](backend/README.md). |
| [`mobile/`](mobile/) | Flutter app (Android + iOS), Arabic & English. |
| [`docs/`](docs/) | OpenAPI spec (`docs/openapi/openapi.json`), screenshots, notes. |
| [`srs.txt`](srs.txt) | Software requirements specification (source of truth). |
| [`PROGRESS.md`](PROGRESS.md) | Task plan, status, decisions log. |

## Quick start

```sh
# Backend (http://localhost:8000/api/v1, Swagger UI on :8080)
cd backend && docker compose up -d --build

# Mobile (Android emulator reaches the local API at 10.0.2.2)
cd mobile && flutter pub get && flutter run
# iOS simulator / other host:
flutter run --dart-define=API_BASE_URL=http://localhost:8000/api/v1
```

## CI

GitHub Actions run on every push / PR touching each app:

- **Backend** (`.github/workflows/backend.yml`): composer validate → Pint → Larastan (level 8) → Pest on PostgreSQL + Redis → `composer audit`.
- **Mobile** (`.github/workflows/mobile.yml`): `dart format` check → `flutter analyze --fatal-infos` → `flutter test`; on pushes, also builds a debug APK (downloadable artifact).
- **Dependabot** (`.github/dependabot.yml`): weekly Composer & pub updates, monthly Docker & Actions updates.

Run the same checks locally:

```sh
cd backend && docker compose exec app composer ci
cd mobile && dart format --output=none --set-exit-if-changed lib test && flutter analyze --fatal-infos && flutter test
```
