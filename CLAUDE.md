# CLAUDE.md — nudgii project context

> Read this file at the start of every session. It is the single source of truth for product decisions, design rules, and file locations. If something contradicts this file, this file wins, unless a decision has been explicitly marked as updated with a date.

> **Companion files** (read on demand when working on the relevant area):
> - `CLAUDE-components.md` — all component specs: tab bar, FAB, ii mark, CTA button, cards, toast, error card, icon container, progress indicator (Section 10)
> - `CLAUDE-layout.md` — shell pattern, responsive scaling, SafeArea rules, hi-fi changelog format (Sections 16, 20)
> - `CLAUDE-screen-specs.md` — personas, onboarding micro-improvements, S-02 conversation UI spec (Sections 13, 17, 22)

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

> **Full plan in `docs/monetization-plan.md`.** 3-year forecast, referral system, affiliate model, paid acquisition strategy, cost structure.

**Freemium. No trial. No tricks.** Free tier is genuinely useful. Pro is for power users and families.

**Free tier:** 10 items, unlimited tasks per item, basic time reminders (unlimited), 3 AI scans/month, 3 voice sessions/month, last 3 completions history, weekly digest (basic), single user.

**Pro tier (€4.99/mo or €44.99/yr):** Unlimited items, unlimited AI scans + voice, smart nudges (seasonal, weather, location), AI task suggestions, full history + export, rich weekly digest, household sharing (up to 3 users), custom categories, priority support.

**Item limit behaviour:**
- At item 11 (during onboarding or later), nudgii says: "That's 11 items, nice collection. Free plan covers 10, but don't stop now. Add everything, you'll choose your favourites later. Or keep them all with Pro."
- Items 11+ visible on dashboard, slightly muted, purple "Pro" pill. Paused: no reminders sent, no push notifications.
- User chooses which 10 stay active, or upgrades to keep all.
- Paused items with overdue tasks show in terra red on dashboard (passive, user sees when they open the app). No notification for paused items.
- Never auto-delete, never block, never hide data.

**Affiliate links:** Shown only at task-due moment, always labeled "we may earn a small fee," never more prominent than the task itself, one link per task view, no follow-up.

**Referral system:** +2 extra items per accepted invite (max 20 on free tier). Invitee starts with 12 items instead of 10.

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
| S-01 | Welcome | 🔶 In progress |
| S-02 | Tell me what you have (Path A) | ⛔ Decision needed (removed from S-01) |
| S-03 | Show me what I can track (Path B) | 🔶 In progress |
| S-04 | Review | 🔶 In progress |
| S-05 | AHA + celebration + sign-in | 🔶 In progress |
| S-06 | Push permission | 🔶 In progress |
| S-07 | *(removed, was onboarding completion)* | — |
| S-08 | *(removed, was push permission standalone)* | — |
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

**v10.5 — locked 2026-03-30. Supersedes all previous values.** Never hardcode hex in Flutter — always reference token constants. Reference prototype: `nudgii-v10-5.html`. Full handoff: `nudgii-v10.5-handoff.md`.

```dart
// ── Color tokens · light mode · v10.5 ──────────────────────────────────────
const Color colorCream         = Color(0xFFF5F0E8);  // App background
const Color colorInk           = Color(0xFF2C2824);  // All body text — warmer charcoal (was #1A1612)
const Color colorMid           = Color(0xFF8A8070);  // Decorative italic subtitles ONLY — 2.8:1 fails AA
const Color colorMidAccessible = Color(0xFF6B6358);  // All functional mid text — WCAG AA 4.6:1 on cream
const Color colorHint          = Color(0xFFA09888);  // Placeholders, very secondary text
const Color colorCta           = Color(0xFF9B7FD4);  // THE ONLY BRIGHT COLOR — CTA, FAB, active tab, filter pill, Done button
const Color colorCtaFg         = Color(0xFFFAF8FF);  // Text on CTA background — lavender-white
const Color colorPlum          = Color(0xFF2D1F4A);  // Done overlay background ONLY — sacred, nowhere else
const Color colorPlumPale      = Color(0xFFC4A8E8);  // Done overlay ii mark pill fill
const Color colorOverdueBadge  = Color(0xFF6B4A3A);  // Overdue badge background — warm brown, NOT red
const Color colorSurface       = Color(0xFFFFFFFF);  // Bottom sheets, dialogs

// Semantic feedback tokens
const Color colorSage      = Color(0xFF3B6D11);   // success text
const Color colorSageLt    = Color(0xFFEAF3DE);   // success background
const Color colorRed       = Color(0xFFA32D2D);   // error text
const Color colorRedLt     = Color(0xFFFCEBEB);   // error background
const Color colorAmber     = Color(0xFF854F0B);   // warning text
const Color colorAmberLt   = Color(0xFFFAEEDA);   // warning background

// Category colors · v10.5 — solid pastel fills + darkened icon strokes
// Card backgrounds are SOLID — never rgba(color, opacity) on cream
const Color catHomeBg          = Color(0xFFD2BEB6);  // Home card background — Anthropic blush
const Color catHomeIc          = Color(0xFF7A5A50);  // Home icon stroke
const Color catGardenBg        = Color(0xFFC0CEC9);  // Garden card background — leaf green
const Color catGardenIc        = Color(0xFF607870);  // Garden icon stroke
const Color catVehicleBg       = Color(0xFFC0CDD8);  // Vehicle card background — steel mist
const Color catVehicleIc       = Color(0xFF4A6A82);  // Vehicle icon stroke
const Color catSubsBg          = Color(0xFFD0C6DC);  // Subscriptions card background — lavender
const Color catSubsIc          = Color(0xFF6A5085);  // Subscriptions icon stroke
const Color catHealthBg        = Color(0xFFD2D0C4);  // Health card background — soft olive (v2)
const Color catHealthIc        = Color(0xFF6A6858);  // Health icon stroke
const Color catPetsBg          = Color(0xFFDECDC0);  // Pets card background — warm amber
const Color catPetsIc          = Color(0xFF8A6238);  // Pets icon stroke

// Dark mode tokens · v10.5 — warm dark, no blue or cool-green
const Color darkBg             = Color(0xFF1E1C18);  // Warm dark cream (was cold sage #111614)
const Color darkNav            = Color(0xFF28261F);  // Tab bar and FAB options surface
const Color darkHomeBg         = Color(0xFF3A302E);
const Color darkGardenBg       = Color(0xFF242E2C);
const Color darkVehicleBg      = Color(0xFF262E34);
const Color darkSubsBg         = Color(0xFF302838);
const Color darkHealthBg       = Color(0xFF2E2E26);
const Color darkPetsBg         = Color(0xFF342C22);
const Color darkTextPrimary    = Color(0xFFE0DDD6);  // (was #EFF0E8)
const Color darkTextMid        = Color(0xFF96908A);  // (was #96A89C — was green-tinted)
// colorCta (#9B7FD4) is identical in dark mode — no change needed

// ── LEGACY — pre-v10.5, archived 2026-03-30 ────────────────────────────────
// const Color colorInkLegacy    = Color(0xFF1A1612);  // Too dark — replaced by #2C2824
// const Color colorApricot      = Color(0xFFE8A87C);  // Removed — greeting name now uses colorCta
// const Color colorApricotDk    = Color(0xFFC8784A);  // Removed — due dates now plain ink at 55%
// const Color colorTerra        = Color(0xFFC4503A);  // Removed — overdue now uses warm brown badge
// const Color catHome           = Color(0xFFC87850);  // Replaced by catHomeIc + catHomeBg
// const Color catVehicle        = Color(0xFF4A82A0);  // Replaced
// const Color catGarden         = Color(0xFF5A9060);  // Replaced
// const Color catSubscriptions  = Color(0xFF8060A8);  // Replaced
// const Color catHealth         = Color(0xFFB86478);  // Replaced (was pink, now olive)
// const Color darkBgLegacy      = Color(0xFF111614);  // Replaced by #1E1C18
// const Color darkCardLegacy    = Color(0xFF1A1F1D);  // Replaced by darkNav
```

**Color rules that never bend:**
- `colorCta` (#9B7FD4) = THE ONLY BRIGHT COLOR. CTA button, FAB, Export, Done, active tab, active filter pill
- `colorPlum` = done overlay ONLY. Never chips, headers, badges, any other surface
- `colorOverdueBadge` (#6B4A3A) = overdue badge background ONLY. Warm brown, not red. Cream text on top.
- Category card backgrounds are SOLID pastel fills — never `rgba(color, opacity)` on cream
- Icons sit directly on cards — no container. Stroke = category icon token, never ink black
- `colorMid` (#8A8070) = decorative italic subtitles ONLY — 2.8:1 fails WCAG AA. Never functional text
- `colorMidAccessible` (#6B6358) = all functional mid text — 4.6:1 AA pass
- No gradients anywhere in the app — zero exceptions
- No borders on category cards — the fill defines the element

---

## 8. Design system — typography

```dart
import 'package:google_fonts/google_fonts.dart';

// DM Serif Display — ONE moment per screen. Never two visible simultaneously.
// Welcome headline: 33px, lh 0.97, ls -0.55px
// Dashboard greeting: 28px, lh 1.12 — "Good morning," in colorInk, "Martijn." in colorCta italic
// Done overlay: 28–30px, lh 1.1, on plum background
// Plan/MyStuff/Profile headers: 24px
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

> **Full specs in `CLAUDE-components.md`.** Tab bar, FAB, ii mark SVG, CTA button, item list spacing, category filter, nudge cards, done overlay, S-01 layout, progress indicator, chips, toast, error card, icon container, centered content screen.

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

> **Full personas in `CLAUDE-screen-specs.md`.** Four personas: Martijn (busy homeowner, Path A), Sara (detail organizer, Path C), Lena (first-timer, Path A), Arne (power user, Path B, highest ARPU).

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

> **Full specs in `CLAUDE-layout.md`.** Mockup standard (390x844), shell pattern (SafeArea + Column + Expanded), sticky bottom zones, progress bar steps, responsive scaling formula, scroll behaviour, iPad notes.

---

## 17. Onboarding UX decisions — micro-improvements

> **Full table in `CLAUDE-screen-specs.md`.** 5 tweaks applied 2026-03-23 across S-01, S-02, S-05, S-06, S-08, S-09. Do not revert them.

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
- ❌ Never auto-advance from S-05 celebration — always require user tap ("Open my schedule")
- ❌ Never put CTA buttons side by side on onboarding screens — always vertically stacked
- ❌ Never show mini-tile columns for preview items — use item row style (same as dashboard) on any screen that shows items
- ❌ Never use border-bottom to separate items in a list — each item is its own card with gap between
- ❌ Never wrap multiple items in a single container card — gap + individual cards only
- ❌ Never hardcode bottom padding for safe area — always use SafeArea widget in Flutter
- ❌ Never put the progress bar inside SafeArea — it must bleed full-width, top: false
- ❌ Never use Spacer to push a CTA to the bottom — use a fixed Column outside Expanded
- ❌ Never wrap the entire screen in SingleChildScrollView — only the content zone scrolls
- ❌ Never use a fixed-count dot or step indicator for onboarding — continuous bar only
- ❌ Never flatten the shell pattern into a single scrollable column — fixed top + Expanded + fixed bottom, always
- ❌ Never show interactive items on S-01 — photo cards are display/swipeable only, no item selection, no check circles
- ❌ Never show a category filter strip on S-01 — category filter exists on S-03 and S-09 only
- ❌ Never show Path A ("Tell me what you have") on S-01 — user testing showed open-ended input is too complex as cold start. Single CTA only.
- ❌ Never use Dutch copy in design files (lo-fi, hi-fi, prototype) — English only in all design artefacts
- ❌ Never write locale-specific copy as the primary copy in design files — label it explicitly (e.g., "nl-BE example")
- ❌ Never add "Step X of Y" text labels anywhere on screen — the progress bar is the only progress indicator, ever
- ❌ Never write "NUDGII" as a sender label in conversation UI — always lowercase "nudgii", same rule as everywhere else
- ❌ Never design S-02 (or any onboarding step) as if prior steps didn't happen — carry context forward. S-01 no longer has interactive selection, so S-02 always opens fresh.
- ❌ Never modify a hi-fi screen without adding a changelog entry — every change gets a version + date, BREAKING/ADDITIVE tag, description, and Flutter notes. The developer reads these to know what to build. No exceptions.
- ❌ Never consider a design change complete without updating ALL of: CLAUDE.md, ClickUp tasks, index.html, flow files, lo-fi files, hi-fi changelogs, and design system files (design-system.html, icon-inventory.html, interaction-states.html). Partial updates cause confusion downstream.

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
| V2 flow promoted | v2 onboarding flow promoted to main. v1 archived. Celebration before auth, two-state AHA+celebration screen, sign-in as bottom sheet, photo card carousel on S-01. | ✅ Yes | 2026-03-26 |
| Screen renumbering | S-05 Review → S-04. S-06 AHA → S-05 (combined with celebration + sign-in). S-07 Push → S-06. Old S-07 completion + S-08 SSO merged into S-05 two-state. S-09 Dashboard unchanged. | ✅ Yes | 2026-03-26 |
| S-01 photo carousel | S-01 welcome shows 3 swipeable polaroid-style photo cards (tyres, tomato, lawn). Caveat handwritten captions, season chip, dots navigation, pivot text. Auto-advance 3.8s. Replaces nudge bubbles. Assets: assets/s01-tyres.jpg, s01-tomato.jpg, s01-lawn.jpg. | ✅ Yes | 2026-03-30 |
| S-02 no carry-over | S-02 opens fresh ("What do you have at home?"). No selection carry-over from S-01 since S-01 has no interactive items (photo cards only). | ✅ Yes | 2026-03-26 |
| Gamification micro-moments | Celebration prototype pattern (confetti + spring animation) to be reused for: first task completed, streak milestones, weekly all-done. Design as reusable component. | ✅ Yes | 2026-03-26 |
| Photo card localization | S-01 photo card content (captions, badges, pivot text) needs locale variants (nl-BE, nl-NL, fr) and seasonal rotation (4 asset sets per season). Store in database, not hardcoded. Season chip adapts to current month. | ✅ Yes | 2026-03-30 |
| S-01 single CTA | Path A ("Tell me what you have") removed from S-01. User testing showed open-ended text/voice input too complex as cold start. Single CTA: "Show me what I can track" leads to S-03 browse. S-02 status changed to decision needed. | ✅ Yes | 2026-03-30 |
| Free tier: no onboarding limits | Never block during onboarding. Let users add unlimited items. 10-item limit enforced on dashboard only. Items 11+ show "Pro" badge and don't send reminders. User chooses which 10 stay active, or upgrades. Conversion trigger: when a paused item's task comes due. | ✅ Yes | 2026-03-26 |
| S-02 edge cases | 7 conversation scenarios documented in hi-fi: nonsense input, duplicate, ambiguous, unknown item, silence, brand mentioned, many items at once. Bubble tints: red for errors, amber for duplicates, standard for clarifications. | ✅ Yes | 2026-03-26 |
| Continue chip copy | "Show my schedule" renamed to "Continue" in S-02. Next screen is S-04 Review, not the schedule. "Ready to review what I found?" replaces "Ready to see your schedule?" | ✅ Yes | 2026-03-26 |

---

## 20. Hi-fi screen changelog format

> **Full format and examples in `CLAUDE-layout.md`.** Every hi-fi must have: version + date, BREAKING/ADDITIVE, visual description, Flutter notes, and standard implementation block.

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
- Claude never needs to be reminded of a rule that is written here. If it is written here, it applies automatically to every screen, lo-fi, hi-fi, prototype, and code file, without being asked.
- If Claude builds something that contradicts a rule in this file, the rule wins and the work is corrected.
- If Hanne notices a rule being applied inconsistently, the fix is to add or clarify it in this file, not to repeat it in chat.

### Post-change checklist — mandatory after every design change

Every design or screen change is incomplete until ALL of these are verified. Do not wait to be asked. Do not skip any step.

| # | What to update | When |
|---|---|---|
| 1 | **CLAUDE.md** — component specs, screen inventory (Section 5), decisions log (Section 19), copy rules (Section 12), progress bar steps, any section referencing the changed element | Every change |
| 2 | **Hi-fi changelogs** — version + date, BREAKING/ADDITIVE, what changed visually, Flutter implementation notes. The developer reads these to know what to build. | Every hi-fi modification |
| 3 | **ClickUp tasks** — update task names, descriptions, statuses. Create dev tasks for implementation changes. | Every change |
| 4 | **index.html** — screen cards, links, status badges, flow preview descriptions | Screen changes |
| 5 | **Flow files** — `onboarding-full-preview.html`, `first-week-engagement.html` | Onboarding/flow changes |
| 6 | **Design system files** — `system/design-system.html` (component library, screen refs), `system/icon-inventory.html` (icon assignments), `system/interaction-states.html` (component states) | Component/icon/state changes |
| 7 | **Lo-fi files** — numbering, references, copy in affected lo-fi screens | Screen renumbering or copy changes |

**Grep check:** After updating, grep across all `system/` and `screens/` files for old values (screen numbers, component names, copy strings) to catch stale references.

---

## 22. S-02 conversation UI pattern

> **Full spec in `CLAUDE-screen-specs.md`.** Chat thread layout, bubble styles, input bar, mic/scan, listening state, context carry-over from S-01.

---

*Last updated: March 2026 · Maintained by Hanne Van Briel · ELF Consult*
*Design system: https://hannevanbriel.github.io/nudgii-design/*
*Repo: https://github.com/ELF-Consult/nudgii*
