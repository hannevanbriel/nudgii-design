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
| S-01 | Welcome screen | ✅ Ready for dev |
| S-02 | Voice onboarding — Path A | 🔶 In progress (OD-03 resolved 2026-03-21) |
| S-03 | Browse categories — Path B | 🔲 To do |
| S-04 | Direct search — Path C | 🔲 To do |
| S-05 | Onboarding review | 🔶 In progress |
| S-06 | Auth screen | 🔶 In progress |
| S-07 | Onboarding completion | 🔶 In progress |
| S-08 | Push permission screen | 🔶 In progress (lo-fi done) |
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
**Status: UNRESOLVED**

**OD-02 — Ask tab first load** *(affects S-18, S-19)*
Three options: (a) empty state with prompt suggestions, (b) open voice input immediately, (c) contextual suggestions based on upcoming tasks.
**Status: UNRESOLVED — product decision needed**

**OD-03 — Voice onboarding: does nudgii speak first?** *(affects S-02 and entire onboarding tone)*
UX spec §2.2 says "nudgii speaks first — non-negotiable." MVP scope defers TTS (voice output) to post-launch. These contradict.
**Status: UNRESOLVED**

---

## 7. Design system — color tokens (light mode)

All values locked in design-system v2.3. Never hardcode hex in Flutter — always reference token constants.

```dart
// Color tokens — light mode
const Color colorCream     = Color(0xFFF5F0E8);  // App background
const Color colorInk       = Color(0xFF1A1612);  // All body text — warm charcoal
const Color colorCta       = Color(0xFF9B7FD4);  // Primary CTA, active chip, tab pip, Pro badge
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
- `colorCta` = primary CTA button + active filter chip + tab pip + Pro badge. Two sanctioned uses only
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
Active tab: full ink + 3px colorCta pip below label. Inactive: ink at 18% opacity.
Build as custom widget — NOT `BottomNavigationBar`.

### FAB
```
Size: 46×46px | Border-radius: 15px (rounded square — NOT circle)
Background: colorCta | Icon: colorCtaFg | Shadow: 0 4px 16px rgba(155,127,212,0.35)
Position: bottom-right, adjacent to pill, NOT inside pill
```
Action sheet order (ergonomics — voice nearest thumb): Voice (bottom) → Browse (middle) → Search (top)

### CTA button
```
Background: colorCta (#9B7FD4) | Text: colorCtaFg (#FAF8FF)
Contrast: 4.7:1 on cream (passes WCAG AA) | Box-shadow: 0 2px 12px rgba(155,127,212,0.28)
Radius: pill | All text sentence case
```
Pressed: bg `#7D62B3`, scale 0.97, 100ms ease-out.
Loading: text hidden, centered spinner colorCtaFg, button stays full width.
Disabled: bg `rgba(155,127,212,0.35)`, text `rgba(250,248,255,0.5)` — never `Opacity` widget on buttons.

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

**Preview items:** 3 item rows in a white card (same visual language as dashboard item cards).
Each row: category icon chip 28×28px (category-colored bg, Phosphor outline icon) + item name 13px/500 + status label 11px.
Status colors: overdue = terra, upcoming = apricot-dk, neutral = mid.
Never mini-tile columns — items look like items everywhere in the app.

**Sticky bottom:** Flutter — Column with Expanded(child: scrollable content) + SizedBox bottom zone.
HTML mockups — flex column on screen, flex:1 on content, margin-top:auto on button zone.

### Progress indicator (onboarding)
Segmented progress bar — 3 horizontal segments, full-width, edge-to-edge, below the status bar (own dedicated row, NOT on the logo/badge row).
Height: 2.5px · Border-radius: 100px · Gap between segments: 3px
Active segment: colorCta #9B7FD4 · Inactive: rgba(26,22,18,0.08)
Segments = phases, not individual screens:
- Phase 1 (S-01 → S-02/03/04): segment 1 active
- Phase 2 (S-05 → S-06): segments 1–2 active
- Phase 3 (S-07): all 3 segments active
Flutter: Row of 3 Expanded containers, height 2.5, with AnimatedContainer for fill transition (150ms ease-out).
❌ Never use dots — 3 dots implies 3 equal steps and is misleading when screens number 4–7.

### Example chips (S-02 voice onboarding)
Shown above the mic button to help cold-start users. Flex-wrap row.
Content (nl-BE): cv-ketel · vaatwasser · auto · olijfboom
Background: white/surface · Border: 0.5px solid rgba(26,22,18,0.13) · Border-radius: 100px · Padding: 2px 7px · Font: 8px DM Sans

### Last maintenance chip (S-03 browse + S-04 search)
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
- Welcome: *"Your stuff won't maintain itself."* / subline: *"But we can remind you."*
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

## 16. What NOT to do

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
- ❌ Never capitalize nudgii — always lowercase, including in code comments
- ❌ Never write "Nudgii" or "NUDGII" anywhere
- ❌ Never use a dark ink background on toasts — use semantic light backgrounds (sage-lt / red-lt / cream) only
- ❌ Never use border-left accent on error cards — use full-border + red-lt background + icon-chip
- ❌ Never show "recent" as a last-maintenance chip default — always "6 mnd geleden"
- ❌ Never auto-advance from S-07 completion — always require user tap ("Open mijn schema")
- ❌ Never put CTA buttons side by side on onboarding screens — always vertically stacked
- ❌ Never show mini-tile columns for preview items on S-01 — use item row style (same as dashboard)
- ❌ Never show more than 3 preview items on S-01 — never a 4th, never a carousel
- ❌ Never use Dutch copy in design files (lo-fi, hi-fi, prototype) — English only in all design artefacts
- ❌ Never write locale-specific copy as the primary copy in design files — label it explicitly (e.g., "nl-BE example")

---

## 17. Decisions log

Update this section when open decisions are resolved.

| ID | Decision | Resolved | Date |
|---|---|---|---|
| OD-01 | Done overlay trigger — dashboard swipe only. Task detail gets quiet in-screen completion banner, not the full overlay. | ✅ Yes | 2026-03-18 |
| OD-02 | Ask tab first load content | ❌ No | — |
| OD-03 | Voice onboarding: nudgii never speaks. Voice = user input only, max 1 min/turn. nudgii always responds in text. TTS deferred indefinitely. | ✅ Yes | 2026-03-21 |
| Toast design | Light semantic backgrounds (sage-lt/red-lt/cream). Dark ink toast removed. | ✅ Yes | 2026-03-21 |
| Error card | No border-left stripe. Full-border + icon-chip. | ✅ Yes | 2026-03-21 |
| Last maint. chip default | Always "6 mnd geleden" — never "recent" | ✅ Yes | 2026-03-21 |
| S-07 auto-advance | Never auto-advance from completion. CTA "Open mijn schema" required | ✅ Yes | 2026-03-21 |
| Scan placement v1.0 | S-05 camera icon (all paths) + FAB scan accent. S-02b full scan is v1.1 | ✅ Yes | 2026-03-21 |
| Progress indicator | Segmented bar (3 phases, 2.5px, full-width) replaces 3 dots. Dots were misleading for 4–7 screen flows. | ✅ Yes | 2026-03-22 |
| Preview items S-01 | Item row style (same as dashboard) replaces 3-column mini-tiles. Items look like items everywhere. | ✅ Yes | 2026-03-22 |
| Free badge copy | "Free · no credit card" — English. Sage-lt bg, sage text. | ✅ Yes | 2026-03-22 |
| Design file language | All design files (lo-fi, hi-fi, prototype) use English copy. App ships in nl/fr. | ✅ Yes | 2026-03-22 |
| Sticky bottom layout | Button zone anchored to bottom via flex:1 content + margin-top:auto. All screens with CTAs. | ✅ Yes | 2026-03-22 |

---

*Last updated: March 2026 · Maintained by Hanne Van Briel · ELF Consult*
*Design system: https://hannevanbriel.github.io/nudgii-design/*
*Repo: https://github.com/ELF-Consult/nudgii*
