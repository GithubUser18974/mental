# Project Rules — Anonymous Mental Health Community & Wellness Tracker

Source of truth for requirements: `srs.txt`. When a rule here conflicts with the SRS, the SRS wins — flag the conflict.

Stack-specific rules:
- PHP / Laravel backend → `.claude/rules/php-laravel.md` (applies to `backend/**`)
- Flutter mobile app → `.claude/rules/flutter.md` (applies to `mobile/**`)
- Visual design system (colors, typography, components) → `.claude/rules/design-system.md` (applies to `mobile/**`)

## Repository layout

```text
backend/   Laravel (PHP 8.3+) modular monolith — REST API /api/v1 + admin panel
mobile/    Flutter app (iOS + Android)
docs/      OpenAPI spec, ADRs, privacy/retention policy notes
```

## Non-negotiable privacy & safety rules (apply to ALL code)

1. **Two identities, never mixed.** `users` (email, phone, credentials) is the auth identity; `anonymous_profiles` is the public identity. No public/community response, payload, URL, log line or notification may contain `users.id`-derived data, email, phone or real name. Public APIs reference people only by anonymous profile id/username.
2. **Health data is private by default and owner-only.** Moods, symptoms, sleep, medications, medication logs/experiences, journals, insights: only the owner can read or modify them (BR-005/006/007). Moderators and admins do not get blanket access.
3. **Never join private health data into community responses.** Community features must not query tracking/medication/journal tables.
4. **Authorize by ownership, not existence.** Every private endpoint checks the record belongs to the authenticated user. Return `404` (not `403`) for other users' private records so existence isn't leaked.
5. **Publishing private content requires explicit user action** (BR-012) — e.g. journal → post, medication experience → post. Never auto-share.
6. **No health data in logs, analytics, crash reports, push notification bodies or exception messages.** Push notifications use generic text ("You have a reminder") — never medication names, dosages, moods or journal content.
7. **Respect blocking everywhere** — feeds, search, comments, reactions, follows, notifications, profiles.
8. **No medical claims.** No diagnosis, no treatment advice, no "prescription" wording in insights or UI copy (BR-010/011/015). Use empathetic, non-clinical, non-stigmatizing language.
9. **Crisis content** must route through the configured safety workflow; don't build features that bypass it or rank crisis content upward in feeds.
10. **Secrets never in source.** No keys, tokens, credentials, or `.env` files committed.

## Cross-stack conventions

- **Times:** store and transmit in UTC, ISO-8601 with `Z` (`2026-11-12T10:00:00Z`). Convert to the user's timezone only for display. Medication schedules must survive timezone and DST changes.
- **IDs:** UUIDs for all public-facing identifiers. Never expose auto-increment ids.
- **API envelope** (both sides depend on it — do not change without updating both):
  - Success: `{ "success": true, "message": "...", "data": ..., "meta": { pagination } }`
  - Error: `{ "success": false, "message": "...", "errors": { "field": ["..."] } }`
- **JSON keys:** `snake_case` on the wire. Flutter maps them to camelCase via `@JsonKey`/`fieldRename`.
- **Pagination:** cursor-based for feeds/comments/notifications; never return unbounded lists.
- **Localization:** Arabic and English; every user-facing string is translatable on both sides. Layouts must work in RTL and LTR.
- **Any API change** updates the OpenAPI spec in `docs/` in the same change.
- **Tests:** every new endpoint/feature ships with tests, including the relevant "critical test scenarios" from SRS §13.3 (cross-user access denied, blocked-user interactions, etc.).

## Working rules for Claude

- Don't add packages outside the SRS stack without asking first.
- Don't invent business rules — if the SRS is silent or ambiguous, ask.
- Keep changes scoped to the module/feature being worked on; don't refactor across modules unasked.
