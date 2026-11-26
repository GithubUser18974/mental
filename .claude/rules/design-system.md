---
paths:
  - "mobile/**"
---

# Design System — "Soft Lavender"

Visual reference: soft, calm, airy UI on a pale lavender canvas with white floating cards, a single violet accent, large rounded corners, pill buttons and outlined line icons. Everything feels light, gentle and low-contrast except primary actions.

All values below live in `lib/app/theme/` as tokens (`AppColors`, `AppSpacing`, `AppRadius`, `AppShadows`, `AppTextStyles`) and are exposed through `ThemeData` + `ThemeExtension`s. **Widgets never hard-code colors, radii, shadows or font sizes.**

## Color tokens

### Light (primary theme)

| Token | Hex | Use |
|---|---|---|
| `primary` | `#7C4DEB` | Main accent: selected states, active icons, toggles, hashtags/links text |
| `primaryDark` | `#6D3AE0` | Gradient end, pressed state |
| `primaryLight` | `#B79CFA` | Decorative only: focus borders, selected-tile border, icons in empty states (fails contrast as text) |
| `primarySoft` | `#EDE6FE` | Selected tile fill, chips, tags background |
| `background` | `#F3F0FC` | Scaffold background (pale lavender) |
| `backgroundTint` | `#E9E4FA` | Top-of-screen gradient tint, section backgrounds |
| `surface` | `#FFFFFF` | Cards, inputs, bottom bars, secondary buttons |
| `surfaceMuted` | `#F8F6FE` | Unselected tiles, icon button wells |
| `border` | `#E6E1F5` | Hairline borders on cards/inputs (1px) |
| `textPrimary` | `#1E1B3A` | Titles, names, body (deep indigo-navy, not pure black) |
| `textSecondary` | `#6E6A85` | Body secondary, labels |
| `textTertiary` | `#A5A1BA` | Hints, timestamps, counters ("215/300") |
| `onPrimary` | `#FFFFFF` | Text/icons on primary |
| `success` | `#2E9E6A` | Positive confirmations (sparingly) |
| `warning` | `#B7791F` | Gentle warnings |
| `danger` | `#C23B57` | Destructive actions, errors — softened, never harsh red |

**Primary gradient** (filled primary buttons, selected round icon buttons):
`LinearGradient(begin: topStart, end: bottomEnd, colors: [#8455F0, #6D3AE0])` — both ends keep white labels ≥ 4.5:1 (enforced by `test/app/theme/palette_contrast_test.dart`).

**Screen background**: vertical gradient `backgroundTint → background`, subtle; no flat gray.

### Dark (required by SRS §9.6)

Keep the same mood — deep violet night, not pure black.

| Token | Hex |
|---|---|
| `background` | `#15122A` |
| `backgroundTint` | `#1C1836` |
| `surface` | `#221E3D` |
| `surfaceMuted` | `#2A2549` |
| `border` | `#352F58` |
| `primary` | `#A584FA` |
| `primarySoft` | `#3A2F6B` |
| `textPrimary` | `#F2F0FA` |
| `textSecondary` | `#B4AFCC` |
| `textTertiary` | `#7D7899` |

Contrast: body text must meet WCAG AA (4.5:1) against its surface in both themes. `textTertiary` is for non-essential info only.

## Typography

- **Latin:** `Urbanist` (fallback `DM Sans`) — rounded geometric sans.
- **Arabic:** `IBM Plex Sans Arabic`, configured as the `fontFamilyFallback` of every style — Arabic glyphs automatically render in Plex in either locale. Never set font families per widget.
- Fonts are bundled in `mobile/assets/fonts/` (OFL). Urbanist is a **variable** font: change weight only with `style.withWeight(FontWeight.wXXX)` (sets the `wght` axis) — `copyWith(fontWeight: …)` alone does NOT change Urbanist's rendered weight.

| Style | Size / Weight | Use |
|---|---|---|
| `display` | 28 / 700 | Screen hero titles ("Add New Post") |
| `title` | 20 / 600 | App bar titles, profile names |
| `subtitle` | 16 / 600 | Card titles, section headers ("Post Type", "Comments") |
| `body` | 15 / 400, height 1.45 | Post content, comments |
| `label` | 14 / 500 | Buttons, chips, tile labels |
| `caption` | 12 / 400 | Meta lines ("25 Total Posts", "1m ago"), counters |

Sentence case for everything except the display title. No all-caps UI text.

## Shape & spacing

| Token | Value | Use |
|---|---|---|
| `radiusSm` | 12 | Chips, tags, small icon wells |
| `radiusMd` | 16 | Inputs, comment cards |
| `radiusLg` | 24 | Cards, image containers, category tiles |
| `radiusXl` | 32 | Bottom sheets, phone-level containers |
| `radiusPill` | 999 | All buttons, segmented options, comment input bar |

Spacing scale: `4, 8, 12, 16, 20, 24, 32, 40`. Screen horizontal padding **20**. Card internal padding **16**. Gap between cards **12–16**.

## Elevation

Soft, diffuse, violet-tinted shadows — never gray/black hard shadows.

- `shadowSoft`: `BoxShadow(color: #8B5CF6 @ 8%, blur: 24, offset: (0, 8))` — cards, tiles, inputs.
- `shadowRaised`: `BoxShadow(color: #8B5CF6 @ 25%, blur: 20, offset: (0, 10))` — primary gradient buttons, selected tiles/icons.
- Dark theme: replace with `#000000 @ 30%` and rely more on `border`.
- Don't use Material `elevation`; use these tokens via `DecoratedBox`/`Container`.

## Components

- **Primary button:** full-width, height 56, pill, primary gradient, `shadowRaised`, white `label` text, optional trailing arrow icon.
- **Secondary button:** full-width, height 56, pill, `surface` fill, `textPrimary` label, trailing `→` icon, `shadowSoft`. (e.g. "Continue", "Create Post").
- **Icon button (app bar):** 44×44 white circle, `shadowSoft`, outlined icon in `textPrimary` (back chevron, `•••` menu).
- **Context badge:** small pill top-right of form screens, `primarySoft` fill, `primary` caption text (e.g. "Community Post").
- **Cards:** `surface`, `radiusLg`, 1px `border`, `shadowSoft`.
- **Text input:** `surface`, `radiusMd`, 1px `primaryLight` border when focused, character counter bottom-end in `caption`/`textTertiary`, inline action icons (camera, mic, emoji) in `textTertiary`.
- **Segmented choice (pills):** row of pill options with radio indicator; selected = primary gradient + white text, unselected = `surface` + `textSecondary`.
- **Selectable grid tiles** (categories, moods, symptoms): 3-column grid, square-ish, `radiusLg`, `surfaceMuted` fill, outlined icon (32px, `primary`) above `label` text. Selected = `primarySoft` fill + 1.5px `primaryLight` border + `shadowRaised`.
- **Round metric/icon selectors:** 64px circles; unselected `surface` with `textTertiary` icon; selected primary gradient with white filled icon.
- **Toggle:** `Switch` with `primary` track when on, `border` track when off.
- **Hashtags/tags:** `primaryLight` text; inside comments use small `primarySoft` pill chips.
- **Action row** (react / comment / share): evenly spaced 40px rounded-square wells in `primarySoft`, outlined icons in `primary`.
- **Comment input bar:** floating pill at bottom, `surface`, `shadowSoft`, avatar at start, circular gradient send button at end.
- **Avatars:** circular; generated/illustrated avatars only (see privacy below).
- **Images:** `radiusLg` clip with 4px white inset border feel; soft pastel illustrations, no harsh stock photography.

## Iconography & imagery

- Outlined/line icons, rounded. Currently Material `*_outlined` / `*_rounded` icons (no extra package). Filled variant only for the selected state.
- Icon color: `primary` for meaningful icons, `textTertiary` for passive ones.
- Illustrations: soft pastel lavender palette, calm themes (meditation, clouds, nature). Mirror directional icons (arrows, chevrons) in RTL.

## Motion

- Durations 150–250ms, `Curves.easeOutCubic`. Gentle scale (0.97) on press for tiles and buttons.
- No flashy, bouncy or attention-grabbing animation — the app should feel calm.
- Respect `MediaQuery.disableAnimations` / reduce-motion.

## Adapting the reference to this product (privacy & SRS overrides)

The reference shots are a style guide only. Where their content conflicts with the SRS, the SRS wins:

- **No real photos or real-looking names** on community profiles — use generated anonymous usernames and generated/illustrated avatars (FR-AUTH-002).
- **No "verified" badges or "% positive" scores** on user profiles — they imply identity or rank people. Allowed public stats are only those in FR-PRO-003.
- **Reactions:** replace the single heart with the supportive reaction set (FR-COM-005) using the same well/icon styling.
- **"Add Metrics" on posts:** never attach mood/health metrics to a public post automatically; any health info shared publicly requires an explicit confirmation step (BR-012).
- **Categories:** tile grid styling applies, but category content comes from the SRS/admin-managed list (FR-COM-003), not the reference labels.
- Post types like Story/Reel are out of scope unless the SRS adds them.
