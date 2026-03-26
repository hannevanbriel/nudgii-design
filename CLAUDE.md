# CLAUDE.md — Nudgii project context

> Read this file at the start of every session. It is the single source of truth for product decisions, design rules, and file locations. If something contradicts this file, this file wins — unless a decision has been explicitly marked as updated with a date.

---

## 1. What this project is

**nudgii** — a proactive home, garden, car, and subscription maintenance reminder app. Positioned as a "seasonal life companion." Target market: homeowners in Belgium and the Netherlands (Germany planned post-launch).

**Core insight:** nudgii ships with pre-loaded domain knowledge (dishwashers need salt every 6–8 weeks, cars need winter tyres before November, olive trees pruned twice a year). Users don't build schedules from scratch — they add what they own, nudgii fills in the rest.

**Product philosophy:** Helpful first. Commercial second. Always honest. This governs every feature, notification, and monetization decision.

**North star:** A user can add the things they own, receive smart reminders on schedule, and mark tasks as done — without building the schedule from scratch.

**Role context:** Hanne is the solo founder/PM. Developer handles implementation. Claude Code operates as a design and dev execution partner.

---

## 2. Tech stack

| Layer | Decision |
|---|---|
| Mobile | Flutter — iOS first, Android post-launch |
| Backend / DB | Supabase (PostgreSQL + Auth + RLS) |
| Push | FCM (Firebase Cloud Messaging) |
| Email | Resend — weekly digest + transactional |
| AI scan (plants) | Plant.id API |
| AI scan (all other) | Claude API — `claude-sonnet-4-6` — single JSON call returning `item_type`, `brand`, `model`, `tasks[]` |
| Payments | RevenueCat — iOS in-app purchase + subscription management |
| Fonts | `google_fonts: ^6.0.0` — DM Serif Display + DM Sans |
| Icons | `flutter_phosphor_icons: ^2.0.0` — Phosphor regular weight, outline only |

---

## 3. Monetization model

**Freemium.** Free tier limited to 10 items (the conversion trigger). Pro tier at ~€5.50 effective ARPU.

**Free tier:** Up to 10 items, 3 tasks/item, time + season reminders, weekly digest email, pre-loaded templates, last 3 completions history, 3 AI scans/month.

**Pro tier (€4.99–€6.99/month or €35–€45/year):** Unlimited items + tasks, unlimited AI scans, AI task suggestions, seasonal smart nudges by location, full history + export, household sharing (up to 3 users), custom categories, priority support.

**Affiliate links:** Shown only at task-due moment, always labeled "we may earn a small fee," never more prominent than the task itself, one link per task view, no follow-up.

**Single most important leading indicator:** Weekly digest open rate.

---

## 4. Repository structure

```
ELF-Consult/nudgii/
├── CLAUDE.md                        ← this file
├── lib/                             ← Flutter app source
├── nudgii-design/                   ← design system (submodule or folder)
│   ├── index.html                   ← design hub overview (28 screens, status)
│   ├── system/
│   │   ├── design-system.html       ← v2.3 FINAL — all tokens, rules, components
│   │   ├── interaction-states.html  ← all 9 components, all states, Flutter notes
│   │   ├── icon-inventory.html      ← 39 icons, 8 zones, Flutter constants
│   │   ├── fab-spec.html            ← floating pill tab bar + FAB action sheet
│   │   └── tokens.json              ← Figma Variables / Tokens Studio export
│   └── screens/
│       ├── s01-welcome-hifi.html
│       ├── s05-onboarding-review-hifi.html
│       ├── s08-push-permission-lofi.html
│       ├── s09-dashboard-hifi.html  (linked from design-system.html#dashboard)
│       ├── s12-fab-action-sheet-hifi.html
│       ├── s13-task-detail-lofi.html
│       ├── s15-snooze-lofi.html
│       ├── s20-profile-free-hifi.html
│       └── s21-profile-pro-hifi.html
└── docs/                            ← PM documents
    ├── 01-product-vision.md
    ├── 02-personas.md
    ├── 03-item-taxonomy.md
    ├── 04-mvp-scope.md
    ├── 05-ux-flow.md
    ├── 07-voice-tone-color.md
    ├── 09-prd-v02.md
    ├── 13-feature-addendum.md
    └── 15-ux-design-document.md
```

**Design system live URL:** https://hannevanbriel.github.io/nudgii-design/

**GitHub branch convention:** `CU-[taskID]/description` — all branches and commits must be prefixed with the ClickUp task ID.

---

## 5. Screen inventory and status

Status as of March 2026. Always check `nudgii-design/index.html` for current state before working on a screen.

| Screen | Name | Status |
|---|---|---|
| S-01 | Welcome | ✅ Ready for dev |
| S-02 | Tell me what you have (Path A) | 🔶 In progress |
| S-03 | Show me what I can track (Path B) | 🔶 In progress |
| S-04 | *(removed, was Direct search / Path C)* | — |
| S-05 | Review | 🔶 In progress |
| S-06 | AHA + celebration state | 🔶 In progress |
| S-07 | Push permission | 🔶 In progress (lo-fi done) |
| S-08 | Sign-in (SSO) | 🔶 In progress |
| S-09 | Dashboard — default | ✅ Ready for dev |
| S-10 | Dashboard — empty | ✅ Ready for dev |
| S-11 | Done overlay | 🔶 In progress (OD-01 resolved 2026-03-18) |
| S-12 | FAB action sheet | ✅ Ready for dev |
| S-13 | Task detail — default | 🔶 In progress (lo-fi done) |
| S-14 | Task detail — done state | 🔶 In progress |
| S-15 | Snooze bottom sheet | 🔶 In progress (lo-fi done) |
| S-16 | Completion history | 🔲 To do |
| S-17 | Item detail | 🔲 To do |
| S-18 | Ask tab — first load | ⛔ Decision needed |
| S-19 | Ask tab — conversation | 🔲 To do |
| S-20 | Profile — free tier | ✅ Ready for dev |
| S-21 | Profile — Pro tier | ✅ Ready for dev |
| S-22 | Pro upgrade / paywall | 🔲 To do |
| S-23 | Notification preferences | 🔲 To do |
| S-24 | Region / locale correction | 🔲 To do |
| S-25 | No internet state | 🔲 To do |
| S-26 | Voice API error | 🔲 To do |
| S-27 | Claude parse failure | 🔲 To do |
| S-28 | App launch — returning user | 🔲 To do |

---

## 6. Open design decisions

These must be resolved before the affected screens can be designed. Do not make assumptions — raise with Hanne.

**OD-01 — Done overlay trigger** *(affects S-11, S-13, S-14)*
Does the full-screen plum overlay fire from task detail "mark done", or only from dashboard swipe-to-complete?
Recommendation on table: dashboard swipe only. Task detail gets a quieter in-screen completion banner.
**Status: RESOLVED (2026-03-18)** — Dashboard swipe only. Task detail gets a quiet in-screen completion banner.

**OD-02 — Ask tab first load** *(affects S-18, S-19)*
Three options: (a) empty state with prompt suggestions, (b) open voice input immediately, (c) contextual suggestions based on upcoming tasks.
**Status: UNRESOLVED — product decision needed**

**OD-03 — Voice onboarding: does nudgii speak first?** *(affects S-02 and entire onboarding tone)*
UX spec §2.2 says "nudgii speaks first — non-negotiable." MVP scope defers TTS (voice output) to post-launch. These contradict.
**Status: RESOLVED (2026-03-21)** — nudgii never speaks. Voice = user input only, max 1 min/turn. nudgii responds in text. TTS deferred indefinitely.

---

## 7. Design system — color tokens (light mode)

All values locked in design-system v2.3. Never hardcode hex in Flutter — always reference token constants.

```dart
// Color tokens — light mode
const Color colorCream     = Color(0xFFF5F0E8);  // App background
const Color colorInk       = Color(0xFF1A1612);  // All body text — warm charcoal
const Color colorCta       = Color(0xFF9B7FD4);  // Primary CTA, active filter chip, active tab icon+label, Pro badge
const Color colorCtaFg     = Color(0xFFFAF8FF);  // Text on CTA button — lavender-white
const Color colorApricot   = Color(0xFFE8A87C);  // ii dot, greeting name em, streak number
const Color colorApricotDk = Color(0xFFC8784A);  // Due-soon date labels ONLY — no buttons
const Color colorTerra     = Color(0xFFC4503A);  // Overdue status — date label + task name ONLY
const Color colorPlum      = Color(0xFF2D1F4A);  // Done overlay background ONLY — nowhere else
const Color colorMid       = Color(0xFF8A8070);  // Italic subtitles, hint text, section labels
const Color colorMidAccessible = Color(0xFF6B6358);  // All functional mid text — WCAG AA 4.6:1 on cream

// Semantic feedback tokens
const Color colorSage      = Color(0xFF3B6D11);   // success text
const Color colorSageLt    = Color(0xFFEAF3DE);   // success background
const Color colorRed       = Color(0xFFA32D2D);   // error text
const Color colorRedLt     = Color(0xFFFCEBEB);   // error background
const Color colorAmber     = Color(0xFF854F0B);   // warning text
const Color colorAmberLt   = Color(0xFFFAEEDA);   // warning background

// Category colors
const Color catHome         = Color(0xFFC87850);
const Color catVehicle      = Color(0xFF4A82A0);
const Color catGarden       = Color(0xFF5A9060);
const Color catSubscriptions = Color(0xFF8060A8);
const Color catHealth       = Color(0xFFB86478);  // v2 — include in Figma, hide in MVP build

// Dark mode tokens
const Color darkBg         = Color(0xFF111614);  // Deep sage — no blue
const Color darkCard       = Color(0xFF1A1F1D);
const Color darkCardHover  = Color(0xFF252E28);
const Color darkTextPrimary = Color(0xFFEFF0E8);
const Color darkTextMid    = Color(0xFF96A89C);
// colorCta (#9B7FD4) is identical in dark mode — no change needed
```

**Color rules that never bend:**
- `colorPlum` = done overlay ONLY. Never chips, headers, badges
- `colorCta` = primary CTA button + active filter chip + active tab (icon + label) + Pro badge
- `colorApricotDk` = due-soon date labels ONLY. Not buttons, not any interactive element
- `colorTerra` = overdue status ONLY — date label color + task name. Nothing else
- Category colors appear ONLY inside category icon chips. Never on status, never on UI icons
- No gradients anywhere in the app — zero exceptions
- `colorMid` (#8A8070) = decorative italic subtitles ONLY — 2.8:1 contrast fails WCAG AA. Never on functional text
- `colorMidAccessible` (#6B6358) = all functional mid-coloured text (hints, labels, descriptions) — 4.6:1 AA pass

---

## 8. Design system — typography

```dart
import 'package:google_fonts/google_fonts.dart';

// DM Serif Display — ONE moment per screen. Never two visible simultaneously.
// Welcome headline: 33px, lh 0.97, ls -0.55px
// Dashboard greeting: 25–27px, lh 0.95, ls -0.4px, name em in colorApricot
// Done overlay: 28–30px, lh 1.1, on plum background
// Empty state: 22px, lh 1.2

// DM Sans — everything daily
// Task name: 500 weight, 13–14px, ls -0.2px
// Witty subtitle: 400 italic, 10–11px, colorMid
// Section label: 500, 9px, ls 1.8px, uppercase — the ONLY uppercase in the app
// Body text: 400, 15px, lh 1.55
// Buttons: 500, pill radius, sentence case
```

**Typography rules that never bend:**
- Sentence case everywhere — buttons, chips, labels, headers. NEVER title case, NEVER all caps (section labels are the only uppercase element)
- One serif moment per screen — DM Serif Display appears once. Never two visible simultaneously
- Italic serif = personality only — witty openers, done headlines, greeting name. Never functional UI labels
- `nudgii` is always lowercase — in all copy, code comments, documentation

---

## 9. Design system — icons

**Library:** Phosphor Icons — regular weight, outline only. No other library, no filled icons, ever.
**Flutter package:** `flutter_phosphor_icons: ^2.0.0`

**Icon sizes by zone:**
- `12–13px` — inside category chip (stroke-width 1.8)
- `14px` — action buttons (stroke-width 1.5)
- `16px` — mic icon in CTA button (stroke-width 1.8)
- `17px` — FAB Plus/X icon
- `19–20px` — tab bar icons

**Minimum tap target: 44×44px always.** Wrap icon buttons in `SizedBox(width: 44, height: 44)` or use `IconButton`.

**Key icon assignments (v2.3 — these replace earlier versions):**
- Settings: `PhosphorIcons.faders` — NOT GearSix
- Camera/AI scan: `PhosphorIcons.scan` — NOT CameraPlus
- Edit/rename: `PhosphorIcons.pencilLine` — NOT PencilSimple
- Back button: `PhosphorIcons.arrowLeft` — horizontal line + arrowhead. SVG: `<path d="M10 6H2"/><path d="M5 3L2 6L5 9"/>` in viewBox `0 0 12 12`. NOT a bare chevron, NOT CaretLeft.

**Tab bar:** CalendarBlank / ChatCircleQuestion / User
**FAB:** Plus → rotates 45° to × on open (do not swap icon, use `AnimatedRotation`)

---

## 10. Design system — components

### Floating pill tab bar
```
Background: white | Border-radius: 22px | Padding: 9px 4px 11px
Shadow: 0 4px 20px rgba(26,22,18,0.11) | Border: 1px solid rgba(26,22,18,0.07)
Bottom: 14px from screen edge
```
Active tab: colorCta (#9B7FD4) on BOTH icon stroke AND label. No pip dot — ever.
Inactive tab: icon + label at rgba(26,22,18,0.20).
Build as custom widget — NOT `BottomNavigationBar`.
Flutter: target `svg *` children (not just `svg`) since Phosphor SVG children carry their own `stroke` attributes that override parent CSS.

### FAB
```
Size: 46×46px | Border-radius: 15px (rounded square — NOT circle)
Background: colorCta | Icon: colorCtaFg (17px) | Shadow: 0 6px 20px rgba(155,127,212,0.45)
Position: bottom-right, adjacent to pill, NOT inside pill
Elevation: margin-bottom 4px — FAB lifts above tab bar bottom edge to signal action-vs-navigation hierarchy
```
Action sheet order (ergonomics — voice nearest thumb): Voice (bottom) → Browse (middle) → Search (top)

### ii mark — SVG variants

Two in-app variants. Always use the correct one for the surface. Never swap them.

**Dark-on-light (light backgrounds — cream, white):**
- Left pill: `#9B7FD4` (CTA purple) · Right pill: `#2D1F4A` (plum) · Dot: `#E8A87C` (apricot)
- Asset: `ii_logo_dark_on_light_bg.svg` — no background rect, pills float on surface
- viewBox: `0 0 625.96 700.13`
- Inline SVG: `<path fill="#9B7FD4" d="M125.18,0h0c69.14,0,125.18,57.7,125.18,128.87v442.39c0,71.17-56.05,128.87-125.18,128.87h0c-69.14,0-125.18-57.7-125.18-128.87V128.87C0,57.7,56.05,0,125.18,0Z"/><path fill="#2D1F4A" d="M450.96,0h0c69.14,0,125.18,57.7,125.18,128.87v442.39c0,71.17-56.05,128.87-125.18,128.87h0c-69.14,0-125.18-57.7-125.18-128.87V128.87C325.78,57.7,381.83,0,450.96,0Z"/><circle fill="#E8A87C" cx="535.96" cy="119.29" r="90"/>`

**Light-on-dark (dark backgrounds — plum done overlay, dark mode):**
- Left pill: `#F5F0E8` (cream) · Right pill: `#9B7FD4` (CTA purple) · Dot: `#E8A87C` (apricot)
- Asset: `ii_logo_light_on_dark bg_DEFAULT_OVERLAY.svg` — no background rect
- Use on colorPlum (`#2D1F4A`) done overlay and dark mode surfaces

**Never use the app icon asset (`nudgii_logo_dark_DEFAULT.svg`) inline** — it has a background rect baked in. In-app ii marks always use the floating pill versions above.

Flutter: `SvgPicture.asset('assets/ii_logo_dark_on_light_bg.svg', width: 18, height: 20)` on light surfaces.
Display size: 18×20px (hi-fi mockups) · Scale with `(screenWidth/390).clamp(0.9,1.15)`.

### CTA button
```
Background: colorCta (#9B7FD4) | Text: colorCtaFg (#FAF8FF)
Contrast: 4.7:1 on cream (passes WCAG AA) | Box-shadow: 0 2px 12px rgba(155,127,212,0.28)
Radius: pill | All text sentence case
```
Pressed: bg `#7D62B3`, scale 0.97, 100ms ease-out.
Loading: text hidden, centered spinner colorCtaFg, button stays full width.
Disabled: bg `rgba(155,127,212,0.35)`, text `rgba(250,248,255,0.5)` — never `Opacity` widget on buttons.

### Item list spacing — system rule
Items are always individual white cards on cream background. The cream gap between cards IS the visual separator.
Gap between item cards: 6px (onboarding, preview, review) · 8px (dashboard — more breathing room)
Each item: background var(--surface) · border-radius 9–10px · border 0.5px solid rgba(26,22,18,0.08) · box-shadow 0 1px 3px rgba(26,22,18,0.04)
Container: display:flex · flex-direction:column · gap:6px (or 8px) · NO background · NO border · NO overflow:hidden
❌ Never border-bottom separators between items — items are cards, not table rows
❌ Never a single container card wrapping all items — each item is its own card

### Category filter strip

Used on S-01 (preview), S-03 (browse), S-09 (dashboard). Same pattern everywhere.

```
Layout: single horizontal scrollable row — flex-wrap:nowrap; overflow-x:auto; scrollbar-width:none
Gap: 4–5px between pills | Margin-bottom: 10–14px
```
**"All" pill always first, always the initial active state.**
Active pill: `background: var(--ink); color: #F5F0E8; border-color: var(--ink)`
Inactive pill: `background: var(--surface); border: 0.5px solid rgba(26,22,18,0.12); color: var(--mid-a)`
Pill shape: `border-radius: 100px; padding: 4px 10px; font-size: 10px; font-weight: 500; flex-shrink: 0`
Category pills include a colored dot (`width: 6px; height: 6px; border-radius: 50%`) in category color, then label.
Flutter: `SingleChildScrollView(scrollDirection: Axis.horizontal)` wrapping a `Row` of `FilterChip` widgets. Never a `Wrap`.
❌ Never wrap to a second line — always a single scrollable row.
❌ Never omit "All" — it is always the first pill.

### Nudge cards
- White on cream background (subtle but essential — creates depth)
- NO left border accent lines — ever. Status lives in date label color only
- Swipe right to complete: threshold 40%, reveals done overlay on release
- Done state: opacity 0.35 + strikethrough, `AnimatedOpacity` 250ms

### Done overlay
- Background: `colorPlum #2D1F4A` — the only place this color appears in the app
- Spring animation: 400–450ms `cubic-bezier(0.34,1.56,0.64,1)` for ii mark scale + headline translateY
- This is the only theatrical motion in the app

### S-01 Welcome screen — layout spec
```
[Notch + status bar]
[Segmented progress bar — full-width, edge-to-edge, 2.5px]
[Content area — flex:1, scrollable]
   ii mark (left) + free badge "Free · no credit card" (right)
   Headline DM Serif Display 33px + subtitle italic DM Sans
   3 preview item rows (dashboard visual language)
[Sticky bottom zone — margin-top:auto]
   Divider "How do you want to start?" (center)
   Path A: plum-lt fill 50px — "Tell me what you have"
   Path B: border 46px — "Show me what I can track"
   Path C: ghost 36px — "I know what I need"
   24px safe area padding
```

**Free badge:** sage-lt background `#EAF3DE` · sage text `#3B6D11` · sage dot · copy: "Free · no credit card"

**"Set up in 2 minutes" badge:** Sits between the promise subtitle and the task preview rows. Clock icon (`PhosphorIcons.clock`, 9–11px, stroke `#6B6358`) + text "Set up in 2 minutes". Style: `background: rgba(26,22,18,0.05); border: 0.5px solid rgba(26,22,18,0.10); border-radius: 100px; padding: 3px 10px 3px 7px`. Font: 10px DM Sans 500, color `#6B6358`. Action-oriented framing (user takes action) vs passive ("ready").

**Preview items:** 3 item rows in a white card (same visual language as dashboard item cards).
Each row: category icon chip 28×28px (category-colored bg, Phosphor outline icon) + item name 13px/500 + status label 11px.
Status colors: overdue = terra, upcoming = apricot-dk, neutral = mid.
Never mini-tile columns — items look like items everywhere in the app.

**Sticky bottom:** Flutter — Column with Expanded(child: scrollable content) + SizedBox bottom zone.
HTML mockups — flex column on screen, flex:1 on content, margin-top:auto on button zone.

### Progress indicator (onboarding)
Single continuous progress bar — fills left to right, 5 equal steps.
Height: 3px · Border-radius: 100px · Full-width, edge-to-edge below status bar (own dedicated row)
Background: rgba(26,22,18,0.08) · Fill: colorCta #9B7FD4
Step fills (S-01 to S-08):
- S-01: 20% (app opened, path not yet chosen)
- S-02 / S-03: 40% (path chosen, entering items)
- S-05: 60% (reviewing items)
- S-06: 80% (AHA schedule preview), 85% (celebration state)
- S-07: 90% (push permission)
- S-08: 95% (sign-in / SSO)
Flutter: LinearProgressIndicator with custom colors + ClipRRect(borderRadius) + AnimatedContainer (300ms ease-in-out).
❌ Never segmented bars — any fixed visual count implies a fixed step count.
❌ Never dots — same problem.

### Example chips (S-02 voice onboarding)
Shown above the mic button to help cold-start users. Flex-wrap row.
Content (nl-BE): cv-ketel · vaatwasser · auto · olijfboom
Background: white/surface · Border: 0.5px solid rgba(26,22,18,0.13) · Border-radius: 100px · Padding: 2px 7px · Font: 8px DM Sans

### Last maintenance chip (S-03 browse)
Every item row shows a last-maintenance chip.
Default = "6 mnd geleden" (amber-lt background, amber text) — NEVER "recent", NEVER empty.
User can change this on S-05. If user says they just maintained it, chip becomes "recent" (ink-06 bg, mid text).

### Toast (corrected)
Light semantic backgrounds — NEVER dark ink.
- Success: sage-lt #EAF3DE · text sage #3B6D11 · green dot
- Neutral (undo): cream #F5F0E8 · border bm · text ink · plum-lt dot
- Error: red-lt #FCEBEB · text red #A32D2D · terra dot
Shape: border-radius 100px · padding 9px 16px · max-width 260px
Position: center-bottom · 14px above tab bar
Duration: 2.5s visible · 250ms fade-out

### Error card (corrected)
NO border-left stripe. Full border with semantically-colored background.
Structure: icon-chip (28×28px, red-lt bg, terra icon) + title + body + action link
Background: red-lt #FCEBEB · Border: 1px solid rgba(163,45,45,0.18) · all sides
Action link: colorCta, underline, with right-arrow icon

### Icon container (S-07 Push, S-08 SSO)
Reusable centered-icon component for permission and trust screens.
```
Size: 56×56px | Border-radius: 16px
Background: rgba(155,127,212,0.08) — CTA purple tint
Border: 0.5px solid rgba(155,127,212,0.15) — CTA purple
Icon: 26px Phosphor outline, stroke colorCta (#9B7FD4), stroke-width 1.6
```
S-07 uses bell icon (functional: notifications). S-08 uses ii mark SVG (brand: trust).
Both containers are visually identical. The icon communicates function or identity depending on context.

### Centered content screen (S-07 Push, S-08 SSO)
Shared layout pattern for the final onboarding screens.
```
Content zone: flex:1, centered vertically + horizontally, padding 0 28px, text-align center
Bottom zone: sticky, fixed Column (CTA + ghost button)
No scroll needed — content is short
Progress bar: outside SafeArea, screen-specific % fill
No back button — forward-only flow, iOS swipe-back gesture handles navigation
```
Flutter: `Column(children: [progressBar, Expanded(Center(child: content)), bottomZone])`

---

## 11. Motion tokens

```
Fast:    150ms ease-out     — button press, chip tap, checkbox fill
Default: 250ms ease-in-out  — card appear, expand/collapse, filter switch
Spring:  400–450ms cubic-bezier(0.34,1.56,0.64,1) — done overlay ii mark (ONLY)
Page:    300ms ease-in-out  — screen transitions, slide from right
```

---

## 12. Voice and copy rules

nudgii speaks like a witty, competent friend — warm, direct, gently funny. Never clinical, never naggy.

**Rules:**
- Never nag — one nudge, clearly stated
- Earn the joke — humor only where it fits. Never on error states, payment screens, or anything stressful
- Short sentences — two words can be funnier than ten
- Sentence case everywhere

**Key copy examples:**
- Welcome: *"Your stuff won't maintain itself."* / subline: *"We remind you before things break, expire, or get too late."*
- Empty dashboard: *"Nothing overdue. Suspicious."*
- Done confirmation: *"Done. Your dishwasher approves."*
- After 2nd snooze: *"Fine. But your dishwasher is taking notes."*
- At 10-item limit: *"You've hit 10 items. Your house has more opinions."*
- Error states: clear and calm ONLY — no humor on errors

---

## 13. Personas (brief)

**Martijn** — busy homeowner, 38, Belgium. Owns a house, car, garden, several subscriptions. Organized enough to want a system, too busy to build one. Onboarding: Path A (Voice). Upgrades month 2–3. Primary persona.

**Sara** — detail-oriented organizer, 44, city apartment. Wants one central hub with full precision. Already has an overbuilt Notion system. Onboarding: Path C (Search). Upgrades month 1–2 when she hits the custom interval limit. Primary persona.

**Lena** — first-time homeowner, 29. Doesn't know what maintenance a home requires — learning as she goes, usually after something breaks. Needs guided onboarding and the "why this matters" explanations. Onboarding: Path A (Guided conversation). Upgrades month 3–6. Secondary persona. Word-of-mouth engine.

**Arne** — power user, 41, large home, Belgium or Netherlands. Owns a lot: multiple AC units, cars, established garden, dozen subscriptions. Not looking to be guided — looking to configure fast. Has tried other apps and found them too slow or too limited. Onboarding: Path B (Browse fast). Hits the 10-item ceiling on day 3 and upgrades immediately without reading the upgrade copy. **Highest revenue-per-user of all four personas.** Key design constraint: never more than one clarifying question per voice interaction, no loading state over 500ms during browsing, review screen must not force expanding all items.

---

## 14. Localization

MVP launches in Dutch (nl-BE and nl-NL) and French (fr). German (de) planned post-launch. All copy in the design files is currently Dutch.

---

## 15. ClickUp structure

Space → Folder (MVP) → List (Epic) → Task (Use Case) → Subtask (User Story) → Checklist item (Dev task)

GitHub branch prefix: `CU-[taskID]/description`

Design deliverables live in a separate `Design` List in ClickUp (Figma links, no GitHub links).

---

## 16. Layout, shell pattern & responsive behaviour

> These rules apply to EVERY screen — lo-fi, hi-fi, mockup, prototype, and Flutter code. Apply them without being asked.

nudgii builds mobile-first for iOS (primary) and Android (secondary). iPad is planned post-launch.

---

### Mockup standard

All HTML mockups: **390×844px** (iPhone 15 logical pixels). Phone frame: `border-radius: 50px`. Notch pill: `width: 102px; height: 8px`. This is the exact size Flutter builds at.

| Device | Width | Scale vs 390 |
|---|---|---|
| iPhone SE | 375px | 0.96 |
| iPhone 15 | 390px | 1.00 ← basis |
| iPhone 15 Pro | 393px | 1.01 |
| iPhone 15 Plus / Pro Max | 430px | 1.10 |

---

### Shell pattern — every screen uses this structure

```
SafeArea (handles notch, home indicator, status bar automatically)
└── Column
    ├── Fixed: progress bar (onboarding S-01→S-08) OR status/greeting row (app S-09+)
    ├── Expanded: SingleChildScrollView — scrollable content zone
    └── Fixed: bottom zone (sticky CTAs onboarding OR floating tab bar app) — never both
```

**Applied to every new screen — no exceptions. Never flatten this into a single scrollable view.**

---

### SafeArea rules

- **Always wrap screens in SafeArea.** It absorbs the difference between Face ID (34px), Home button (0px), and Android home bar (varies).
- **Never hardcode bottom padding** for safe area — SafeArea handles it.
- **Progress bar is outside SafeArea** — it sits above the safe area, bleeding full-width under the status bar. `top: false` on SafeArea, progress bar in its own full-bleed row before the SafeArea kicks in.
- Flutter: `SafeArea(top: false, child: Column([progressBar, Expanded(content), bottomZone]))`

---

### Sticky bottom zone

- **Onboarding (S-01→S-08):** Fixed Column at the bottom of the screen. CTAs stack vertically. 24px padding-bottom + SafeArea inset.
- **App (S-09+):** Floating pill tab bar, 52px height, 14px from screen edge + SafeArea.
- **Never use `Spacer` to push the bottom zone** — use a fixed Column that sits outside the Expanded content zone.
- **Never put both a sticky CTA zone and a tab bar on the same screen.**
- HTML mockups: `flex: 1` on content zone + `margin-top: auto` on button zone.

---

### Progress bar (onboarding)

- Full-width, edge-to-edge, **outside SafeArea** — no side padding, no indent.
- Height: 3px · border-radius: 100px · track: `rgba(26,22,18,0.08)` · fill: `colorCta #9B7FD4`
- Steps: S-01 = 20% · S-02/S-03 = 40% · S-05 = 60% · S-06 = 80%/85% · S-07 = 90% · S-08 = 95%
- Flutter: `LinearProgressIndicator` inside `ClipRRect(borderRadius: 100px)` + `AnimatedContainer` 300ms ease-in-out.
- **Never use dots, steps, or any fixed-count indicator** — a fixed count implies a fixed number of screens.

---

### Responsive scaling

**Scaling formula (Flutter):** `All visual elements × (screenWidth / 390).clamp(0.9, 1.15)`

This keeps the design proportional on SE (375px) through Pro Max (430px) without distorting at extremes.

**Headline breakpoints:**
- Default (≥ 380px): welcome 33px · greeting 25–27px
- Small (< 380px, SE): welcome 28px · greeting 22px
- Flutter: `MediaQuery.of(context).size.width < 380 ? 28.0 : 33.0`

**Side padding breakpoints:**
- Default (< 420px): 16px horizontal
- Large (≥ 420px, Pro Max): 20–24px horizontal

**Text scale cap (accessibility) — apply at app root:**
`MediaQuery.of(context).copyWith(textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.85, 1.3))`

---

### Scroll behaviour

- **Content zone only** uses `SingleChildScrollView` — not the entire screen.
- The fixed top row (progress bar / greeting) and the fixed bottom zone (CTAs / tab bar) never scroll.
- If content is short, it simply doesn't scroll — the bottom zone stays anchored regardless.

---

**iPad (post-launch):** Two-column layout, sidebar nav replacing tab bar. Not in current scope — avoid hardcoding anything that breaks at 768px+ width.

---

## 17. Onboarding UX decisions — micro-improvements

These 5 tweaks were applied across the onboarding flow (2026-03-23) to reduce drop-off and uncertainty. Do not revert them.

| Screen | Tweak | Rationale |
|---|---|---|
| S-01 | "Set up in 2 minutes" badge between subtitle and task rows (was "Ready in 2 minutes") | Action-oriented framing, sets time expectation before path-choice |
| S-02 | Sub includes "2–3 items is plenty to start." hint (italic, `colorMidAccessible`) | Cold-start users freeze when they think they need to add everything at once |
| S-05 | Sub: "Scan to confirm brand or model. You can adjust anything later." | Reduces review-screen friction; reminds user the AI scan is available; "adjust later" lowers perfectionism |
| S-08 | "Not now" is a visible ghost button (was "Continue without account" as 60%-opacity whisper) | Lower-commitment path must be findable. Renamed after SSO replaced email auth |
| S-06 | Sub: "We'll remind you when it matters." on celebration state | User-centric framing (what they get) vs brand-centric (what we do) |
| S-09 | "swipe right to complete" gesture hint below first overdue task | First-time users don't discover swipe on their own; hint disappears after first completion |

---

## 18. What NOT to do

These are locked decisions. Do not question them in design or code reviews.

- ❌ No gradients anywhere — no exceptions
- ❌ No left-border accent lines on cards — status lives in date label color only
- ❌ No blue-tinted backgrounds in dark mode — deep sage only (`#111614`)
- ❌ Never use GearSix, CameraPlus, or PencilSimple — replaced in v2.3
- ❌ Never mix Phosphor with any other icon library (SF Symbols, Material, Lucide)
- ❌ Never use filled icons — outline only, always
- ❌ Never use `Opacity` widget on buttons — change colors instead
- ❌ Never use `BottomNavigationBar` for the tab bar — custom widget only
- ❌ Never use category colors on tab bar or action button icons
- ❌ Never use em dashes (—) anywhere — in copy, labels, microcopy, code comments, or documentation. Use commas, colons, or line breaks instead
- ❌ Never capitalize nudgii — always lowercase, including in code comments
- ❌ Never write "Nudgii" or "NUDGII" anywhere
- ❌ Never use a dark ink background on toasts — use semantic light backgrounds (sage-lt / red-lt / cream) only
- ❌ Never use border-left accent on error cards — use full-border + red-lt background + icon-chip
- ❌ Never show "recent" as a last-maintenance chip default — always "6 mnd geleden"
- ❌ Never auto-advance from S-06 celebration — always require user tap ("Open my schedule")
- ❌ Never put CTA buttons side by side on onboarding screens — always vertically stacked
- ❌ Never show mini-tile columns for preview items on S-01 — use item row style (same as dashboard)
- ❌ Never use border-bottom to separate items in a list — each item is its own card with gap between
- ❌ Never wrap multiple items in a single container card — gap + individual cards only
- ❌ Never hardcode bottom padding for safe area — always use SafeArea widget in Flutter
- ❌ Never put the progress bar inside SafeArea — it must bleed full-width, top: false
- ❌ Never use Spacer to push a CTA to the bottom — use a fixed Column outside Expanded
- ❌ Never wrap the entire screen in SingleChildScrollView — only the content zone scrolls
- ❌ Never use a fixed-count dot or step indicator for onboarding — continuous bar only
- ❌ Never flatten the shell pattern into a single scrollable column — fixed top + Expanded + fixed bottom, always
- ❌ Never show more than 3 preview items on S-01 — never a 4th, never a carousel
- ❌ Never use Dutch copy in design files (lo-fi, hi-fi, prototype) — English only in all design artefacts
- ❌ Never write locale-specific copy as the primary copy in design files — label it explicitly (e.g., "nl-BE example")
- ❌ Never add "Step X of Y" text labels anywhere on screen — the progress bar is the only progress indicator, ever
- ❌ Never write "NUDGII" as a sender label in conversation UI — always lowercase "nudgii", same rule as everywhere else
- ❌ Never design S-02 (or any onboarding step) as if prior steps didn't happen — carry context forward. If items were selected on S-01, they appear as pre-confirmed in S-02. Never ask the user for information they've already given.

---

## 19. Decisions log

Update this section when open decisions are resolved.

| ID | Decision | Resolved | Date |
|---|---|---|---|
| OD-01 | Done overlay trigger — dashboard swipe only. Task detail gets quiet in-screen completion banner, not the full overlay. | ✅ Yes | 2026-03-18 |
| OD-02 | Ask tab first load content | ❌ No | — |
| S-02 conversation pattern | Option A: chat thread + persistent input bar. nudgii bubbles left (white), user bubbles right (CTA purple). No screen title — nudgii bubble is the opening. Persistent input bar: scan icon left, text center, mic right. S-01 context pre-loaded as confirmed chips when items were selected. Privacy note always visible. Discovery-first copy: "What do you have at home? I'll figure out what needs maintenance." | ✅ Yes | 2026-03-23 |
| OD-03 | Voice onboarding: nudgii never speaks. Voice = user input only, max 1 min/turn. nudgii always responds in text. TTS deferred indefinitely. | ✅ Yes | 2026-03-21 |
| Toast design | Light semantic backgrounds (sage-lt/red-lt/cream). Dark ink toast removed. | ✅ Yes | 2026-03-21 |
| Error card | No border-left stripe. Full-border + icon-chip. | ✅ Yes | 2026-03-21 |
| Last maint. chip default | Always "6 mnd geleden" — never "recent" | ✅ Yes | 2026-03-21 |
| S-06 auto-advance | Never auto-advance from AHA/celebration. CTA "Open my schedule" required (was S-07 pre-renumber) | ✅ Yes | 2026-03-21 |
| Scan placement v1.0 | S-05 camera icon (all paths) + FAB scan accent. S-02b full scan is v1.1 | ✅ Yes | 2026-03-21 |
| Progress indicator | Segmented bar (3 phases, 2.5px, full-width) replaces 3 dots. Dots were misleading for 4–7 screen flows. | ✅ Yes | 2026-03-22 |
| Preview items S-01 | Item row style (same as dashboard) replaces 3-column mini-tiles. Items look like items everywhere. | ✅ Yes | 2026-03-22 |
| Free badge copy | "Free · no credit card" — English. Sage-lt bg, sage text. | ✅ Yes | 2026-03-22 |
| Design file language | All design files (lo-fi, hi-fi, prototype) use English copy. App ships in nl/fr. | ✅ Yes | 2026-03-22 |
| Sticky bottom layout | Button zone anchored to bottom via flex:1 content + margin-top:auto. All screens with CTAs. | ✅ Yes | 2026-03-22 |
| Progress bar | Single continuous bar (3px, 5 steps, 20%→100%) replaces segmented bar. Any fixed visual count implies fixed step count. | ✅ Yes | 2026-03-22 |
| Item spacing | Gap-based individual cards (6–8px gap) replaces border-bottom separators. Cream between cards = separator. | ✅ Yes | 2026-03-22 |
| Responsive layout | SafeArea + Expanded shell pattern. Two headline breakpoints (380px). Text scale capped at 1.3×. | ✅ Yes | 2026-03-22 |
| Auth reassurance | "Free · no credit card" shown on S-08 sign-in screen (was S-06 pre-renumber). | ✅ Yes | 2026-03-22 |
| S-08 button layout | Sticky bottom zone: Apple first, Google second. "Not now" ghost button. (was S-06 pre-renumber, SSO replaced email auth) | ✅ Yes | 2026-03-22 |
| S-08 progress indicator | Continuous bar at 95% fill (was S-06 at 80% pre-renumber). | ✅ Yes | 2026-03-22 |
| Design system versioning | No version numbers in design system title, nav, or component cards. Components are standalone definitions — they just ARE what they are. Sections 07 + 13 merged into single "Component library". Copy library is Section 13. | ✅ Yes | 2026-03-22 |
| CTA button mic spec | Mic button inside Path A CTA: 22×22px circle, rgba(250,248,255,0.15) bg, Phosphor Microphone 11px, stroke #FAF8FF stroke-width 1.8. Now documented in design system Section 07 component card. | ✅ Yes | 2026-03-22 |
| Hi-fi Flutter changelog | Every hi-fi screen must include a changelog section with: version+date, BREAKING/ADDITIVE, visual description, Flutter implementation notes, and standard Flutter block (mockup base, SafeArea, scroll, bottom zone, progress bar, scaling, special). See Section 20. | ✅ Yes | 2026-03-22 |
| Tab bar active state | No pip dot. Active tab = colorCta on BOTH icon stroke AND label. Inactive = rgba(26,22,18,0.20). CSS: must target svg * children. Flutter: both icon color and label TextStyle set to colorCta. | ✅ Yes | 2026-03-23 |
| FAB spec v1.1 | Shadow updated to 0 6px 20px rgba(155,127,212,0.45). Icon 17px. margin-bottom 4px for elevation above tab bar. | ✅ Yes | 2026-03-23 |
| ii mark SVG | CSS text-based ii mark replaced with inline SVG everywhere. Two variants: dark-on-light (CTA purple + plum + apricot) for light surfaces; light-on-dark (cream + CTA purple + apricot) for plum/dark surfaces. See Section 10 component card. | ✅ Yes | 2026-03-23 |
| Back button | Phosphor ArrowLeft: horizontal line + arrowhead. SVG paths d="M10 6H2" + d="M5 3L2 6L5 9" in viewBox 0 0 12 12. Replaces bare chevron. | ✅ Yes | 2026-03-23 |
| Category filter strip | "All" pill always first (active), followed by category pills. Single scrollable row (nowrap + overflow-x:auto). No second line ever. Consistent across S-01, S-03, S-09. | ✅ Yes | 2026-03-23 |
| "Set up in 2 minutes" badge | Renamed from "Ready in 2 minutes". Action-oriented framing. Sits between subtitle and task rows (category strip removed). | ✅ Yes | 2026-03-26 |
| Onboarding UX micro-improvements | 5 targeted tweaks applied (S-02 hint, S-05 sub, S-08 skip visibility, S-06 celebration sub, S-09 gesture hint). Documented in Section 17. | ✅ Yes | 2026-03-23 |
| Em dash | Never use — anywhere in copy, labels, microcopy, code, or documentation. Use commas, colons, or line breaks instead. | ✅ Yes | 2026-03-23 |
| S-01 "All" pill removed | "All" pill removed from S-01 category strip (decorative, takes focus). Kept on S-03 and S-09 where it's a functional filter. | ✅ Yes | 2026-03-24 |
| S-01 scan ghost link removed | "or start by scanning an item" removed from S-01 bottom zone. Redundant: scanning is available in S-02 input bar. Three clear paths is better than three + a footnote. | ✅ Yes | 2026-03-24 |
| Category name on item rows | Every item row shows category name (Home, Vehicle, Garden) in the subtitle line. Consistent across all screens. Matches S-06 AHA format. | ✅ Yes | 2026-03-24 |
| Pressed state bg color | Pressed states use rgba(26,22,18,0.03) (subtle dark tint) instead of rgba(245,240,232,0.6) (cream). Cream on cream was invisible. Applies to nudge cards and action sheet options. | ✅ Yes | 2026-03-24 |
| Interaction states on cream | State tiles in interaction-states.html now use cream background instead of white, showing pressed states in realistic context. | ✅ Yes | 2026-03-24 |
| S-01 CTA mic icon removed | Path A covers voice, text, and scan. Mic icon was misleading (implied voice-only). Button is text-only now. | ✅ Yes | 2026-03-24 |
| S-01 interactive item rows | Items are tappable with check circles. Task names ("Clean dishwasher filter") not item names ("Dishwasher"). Pre-selection carries to S-02 as confirmed chips. | ✅ Yes | 2026-03-24 |
| S-01 Path C removed | Two paths only (A + B). "Something else" row covers discovery. Three paths + footnote was too many choices. | ✅ Yes | 2026-03-24 |
| S-01 subtitle | "We remind you before things break, expire, or get too late." Explains what the app does (prevent problems) vs what the user does (add items). | ✅ Yes | 2026-03-26 |
| S-01 hi-fi layout | Single English phone + annotation sidebar. Matches S-02 pattern. Locale variants removed from hi-fi (English only per design system rules). | ✅ Yes | 2026-03-24 |
| Shared components.css | All 5 hi-fi screens (S-01, S-02, S-03, S-05, S-06) now link to system/components.css. ~985 lines of duplicated inline CSS removed. Screen files keep only screen-specific styles. (S-06 was S-07 pre-renumber) | ✅ Yes | 2026-03-25 |
| Category filter active state | Active pill uses purple outline (colorCta border + text, subtle lavender bg) instead of dark ink fill. Applies across S-01, S-03, S-09. | ✅ Yes | 2026-03-25 |
| S-03 "All" pill added | "All" pill first, active by default. JS updated from .on to .active class. S-01 still has no "All" pill (decorative). | ✅ Yes | 2026-03-25 |
| S-03 headline added | "What do you have?" + "Tick what applies. We'll figure out the rest." above search bar. Screen lacked context without it. | ✅ Yes | 2026-03-25 |
| Alt flow reorder | AHA > Celebration > Push > Apple/Google SSO > Dashboard. Celebration protects emotional peak. Push after value demo = 3x opt-in. SSO replaces email capture. One fewer onboarding screen. | ✅ Yes | 2026-03-25 |
| SSO screen copy | "One tap to keep it all." + ii mark icon. Replaces "Save your schedule" + shield (fear-based). Layout aligned with push screen (centered content + sticky bottom). "Not now" replaces "Continue without account". | ✅ Yes | 2026-03-25 |
| Dashboard personalization | Signed-in users see "Good morning, Martijn." (name from SSO). Skipped users see "Good morning, there." Digest nudge: signed-in = one-tap toggle, skipped = SSO bottom sheet. | ✅ Yes | 2026-03-25 |
| btn-a legacy fix | .btn-a now uses var(--cta) + scale(0.97) pressed state instead of hardcoded hex + opacity. Matches .btn-cta canonical pattern. | ✅ Yes | 2026-03-25 |
| Nav status classes | .nav-status.ready/.progress/.todo color variants in components.css. Screens use class instead of inline color overrides. | ✅ Yes | 2026-03-25 |
| Screen renumbering | S-04 removed (Path C). Old S-06 Auth renamed S-08 Sign-in (SSO). Old S-07 Completion merged into S-06 AHA (+ celebration state). Old S-08 Push renumbered to S-07. S-09 Dashboard unchanged. All references updated in CLAUDE.md, index.html, and onboarding flow. | ✅ Yes | 2026-03-26 |
| Icon container pattern | S-07 and S-08 share identical icon container (56x56, 16px radius, CTA purple tint bg + border). S-07 uses bell (functional), S-08 uses ii mark (brand). Documented as reusable component in Section 10. | ✅ Yes | 2026-03-26 |
| S-01 category strip removed | Category filter chips (Home, Vehicle, Garden, Subscriptions) removed from S-01. Screen was too busy. Category strip stays on S-03 and S-09 where it's a functional filter. | ✅ Yes | 2026-03-26 |
| S-01 subtitle v2 | "We remind you before things break, expire, or get too late." replaces "Add what you own. We'll remind you when it matters." Explains the why (prevent problems) not the how (add items). | ✅ Yes | 2026-03-26 |
| S-01 badge copy | "Set up in 2 minutes" replaces "Ready in 2 minutes". Action-oriented (user takes action) vs passive. | ✅ Yes | 2026-03-26 |

---

## 20. Hi-fi screen changelog format — required on every hi-fi file

Every hi-fi screen file must include a changelog section below the phone mockup(s). This saves the developer from asking clarifying questions and prevents an hour of debugging per screen.

**Hanne fills this in.** It takes ~10 minutes per screen. Without it, every layout tweak becomes a back-and-forth.

### Changelog entry format

Each entry in the changelog table:

| Field | What to write |
|---|---|
| Version + date | e.g. `v1.1 · 2026-03-22` |
| Type | `BREAKING` (existing Flutter code must change) or `ADDITIVE` (new element, no existing code breaks) |
| What changed | Plain language description of the visual change — what the developer will see on screen |
| Flutter notes | Implementation detail: position, scroll behaviour, sticky zones, scaling, widget type |

### Standard Flutter implementation block — bottom of every hi-fi

Add this block verbatim at the end of every hi-fi changelog section, updating the `Special` row per screen:

```
Mockup base:    390px width (iPhone 15)
SafeArea:       top=false for content, progress bar outside SafeArea
Scroll:         SingleChildScrollView for content zone
Bottom zone:    Sticky — fixed Column at bottom, not Spacer
Progress bar:   Full width, height 3px, outside SafeArea
Scaling:        All visual elements × (screenWidth/390).clamp(0.9, 1.15)
Special:        [screen-specific exceptions, or "none"]
```

### Example changelog entry

```
v1.1 · 2026-03-22 · BREAKING
- Progress bar: replaced 3-dot indicator with continuous bar (3px, full-width, colorCta fill)
  Flutter: LinearProgressIndicator inside ClipRRect(borderRadius:100px), AnimatedContainer 300ms ease-in-out
- Button zone: moved from inline flow to sticky bottom Column
  Flutter: Column with Expanded(child: ScrollView) + fixed bottom zone, not Spacer
- Free badge: added below magic link CTA
  Flutter: Text widget, sage-lt bg, pill Container, 8px DM Sans
```

---

## 21. How design rules stay current — source of truth protocol

This file (CLAUDE.md) is the single source of truth for all design and product decisions. It is automatically read at the start of every Claude Code session. Any designer, developer, or AI assistant working on this project gets these rules without being told explicitly.

**What lives here vs elsewhere:**

| Source | Purpose | Who reads it |
|---|---|---|
| `CLAUDE.md` (this file) | All design rules, tokens, component specs, decisions, copy rules | Claude Code (auto), developers (reference) |
| `system/design-system.html` | Visual component library with live demos | Designers, developers, stakeholders |
| `index.html` (design hub) | Screen inventory, status, open decisions | Everyone — overview |
| `docs/` | PRD, personas, UX flow, vision | PM reference |

**Rules for keeping this file current:**
- Every resolved design decision must be added to Section 19 (Decisions log) the same session it is resolved
- Every new "never do X" rule must be added to Section 18 (What NOT to do) immediately
- Every new component spec or token change must update Section 10 (Components) and Section 7 (Color tokens)
- This file is the handoff document — if a rule is not here, it does not exist for the next person

**What this means in practice:**
- Claude never needs to be reminded of a rule that is written here. If it is written here, it applies automatically to every screen, lo-fi, hi-fi, prototype, and code file — without being asked.
- If Claude builds something that contradicts a rule in this file, the rule wins and the work is corrected.
- If Hanne notices a rule being applied inconsistently, the fix is to add or clarify it in this file — not to repeat it in chat.

---

## 22. S-02 conversation UI pattern — spec

Resolved 2026-03-23. Applies to any screen that uses a chat-thread conversation between nudgii and the user.

### Layout
- Shell: SafeArea + Expanded(scrollable conversation thread) + fixed input bar at bottom
- No screen title above the conversation — the nudgii opening bubble IS the screen entry point
- Progress bar: full-width, outside SafeArea, at correct % for this step
- Back button: PhosphorIcons.arrowLeft, 44x44px tap target, left of top row

### Conversation thread
- Scrollable, fills the Expanded zone
- nudgii bubbles: left-aligned, white surface bg, 0.5px border rgba(26,22,18,0.08), border-radius 12px 12px 12px 4px (bottom-left flat = sender side), max-width 88%
- Sender label above first bubble in a sequence: 8px DM Sans 500, 0.4px letter-spacing, no text-transform, colorMidAccessible. Text: "nudgii" — always lowercase, never "NUDGII", no CSS uppercase transform ever
- User bubbles: right-aligned, colorCta (#9B7FD4) bg, colorCtaFg text, border-radius 12px 12px 4px 12px (bottom-right flat), max-width 84%
- Confirmed items chips: sage-lt (#EAF3DE) bg, sage (#3B6D11) text, checkmark icon — appear inside nudgii's confirmation bubble after a turn
- Suggestion chips: surface bg, 0.5px border rgba(26,22,18,0.13), 100px radius, 8px DM Sans — update contextually after each turn
- Hint sub-text (cold start): 8px italic DM Sans, colorMidAccessible, below nudgii's first bubble

### Context carry-over from S-01
If the user tapped or selected items on S-01 before choosing Path A: those items are pre-loaded into the conversation. nudgii opens with "I see you added [X, Y]. What else do you have?" and shows the pre-loaded items as confirmed chips. Never ask users for information they already gave. If no items were selected on S-01, nudgii opens fresh.

### Input bar (fixed, bottom of screen)
- Background: surface white, border 0.5px solid rgba(26,22,18,0.12), border-radius 100px
- Left: PhosphorIcons.scan, 14px, colorMidAccessible, 44x44px tap target
- Center: text input placeholder, 8px italic, rgba(107,99,88,0.45)
- Right: mic button — 28px circle, colorCta bg, PhosphorIcons.microphone 13px, colorCtaFg stroke
- Active recording state: border-color rgba(196,80,58,0.30), placeholder text changes, mic button turns colorTerra
- Privacy note below bar: "audio sent for transcription only · deleted after · responds in text" — 7px italic DM Sans, rgba(107,99,88,0.45), always visible

### Listening state
- Waveform animation appears in the conversation area (not floating over input bar)
- Live transcript builds as a faint user bubble (opacity 0.65) as speech is recognized
- Max 1 minute per turn — countdown appears at 50s remaining

### Copy direction
- nudgii's opening message frames it as discovery, not inventory. "What do you have at home?" not "What do you own?". The user doesn't need to know what maintenance is required — that's nudgii's job.
- Single question per turn, max 1 clarifying question
- Italic CTA-colored emphasis on the key question within a nudgii bubble
- nudgii's tone: warm, direct, gently funny — never clinical, never a form

---

*Last updated: March 2026 · Maintained by Hanne Van Briel · ELF Consult*
*Design system: https://hannevanbriel.github.io/nudgii-design/*
*Repo: https://github.com/ELF-Consult/nudgii*
