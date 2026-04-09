# CLAUDE-components.md — nudgii component specs

> Referenced from CLAUDE.md. Read this file when working on components, building screens, or implementing Flutter widgets.

---

## 10. Design system — components

### Floating pill tab bar
```
Background: white | Border-radius: 22px | Padding: 9px 4px 11px
Shadow: 0 4px 20px rgba(26,22,18,0.11) | Border: 1px solid rgba(26,22,18,0.07)
Bottom: 14px from screen edge
```
Active tab: colorCta (#9B7FD4) on BOTH icon stroke AND label. No pip dot, ever.
Inactive tab: icon + label at rgba(26,22,18,0.20).
Build as custom widget, NOT `BottomNavigationBar`.
Flutter: target `svg *` children (not just `svg`) since Phosphor SVG children carry their own `stroke` attributes that override parent CSS.

### FAB
```
Size: 46x46px | Border-radius: 15px (rounded square, NOT circle)
Background: colorCta | Icon: colorCtaFg (17px) | Shadow: 0 6px 20px rgba(155,127,212,0.45)
Position: bottom-right, adjacent to pill, NOT inside pill
Elevation: margin-bottom 4px, FAB lifts above tab bar bottom edge to signal action-vs-navigation hierarchy
```
Action sheet order (ergonomics, voice nearest thumb): Voice (bottom), Browse (middle), Search (top)

### ii mark — SVG variants

Two in-app variants. Always use the correct one for the surface. Never swap them.

**Dark-on-light (light backgrounds, cream, white):**
- Left pill: `#9B7FD4` (CTA purple) · Right pill: `#231833` (plum) · Dot: `#E8A87C` (apricot)
- Asset: `ii_logo_dark_on_light_bg.svg`, no background rect, pills float on surface
- viewBox: `0 0 625.96 700.13`
- Inline SVG: `<path fill="#9B7FD4" d="M125.18,0h0c69.14,0,125.18,57.7,125.18,128.87v442.39c0,71.17-56.05,128.87-125.18,128.87h0c-69.14,0-125.18-57.7-125.18-128.87V128.87C0,57.7,56.05,0,125.18,0Z"/><path fill="#231833" d="M450.96,0h0c69.14,0,125.18,57.7,125.18,128.87v442.39c0,71.17-56.05,128.87-125.18,128.87h0c-69.14,0-125.18-57.7-125.18-128.87V128.87C325.78,57.7,381.83,0,450.96,0Z"/><circle fill="#E8A87C" cx="535.96" cy="119.29" r="90"/>`

**Light-on-dark (dark backgrounds, plum done overlay, dark mode):**
- Left pill: `#F5F0E8` (cream) · Right pill: `#9B7FD4` (CTA purple) · Dot: `#E8A87C` (apricot)
- Asset: `ii_logo_light_on_dark bg_DEFAULT_OVERLAY.svg`, no background rect
- Use on colorPlum (`#231833`) done overlay and dark mode surfaces

**Never use the app icon asset (`nudgii_logo_dark_DEFAULT.svg`) inline**, it has a background rect baked in. In-app ii marks always use the floating pill versions above.

Flutter: `SvgPicture.asset('assets/ii_logo_dark_on_light_bg.svg', width: 18, height: 20)` on light surfaces.
Display size: 18x20px (hi-fi mockups) · Scale with `(screenWidth/390).clamp(0.9,1.15)`.

### CTA button
```
Background: colorCta (#9B7FD4) | Text: colorCtaFg (#FAF8FF)
Contrast: 4.7:1 on cream (passes WCAG AA) | Box-shadow: 0 2px 12px rgba(155,127,212,0.28)
Radius: pill | All text sentence case
```
Pressed: bg `#7D62B3`, scale 0.97, 100ms ease-out.
Loading: text hidden, centered spinner colorCtaFg, button stays full width.
Disabled: bg `rgba(155,127,212,0.35)`, text `rgba(250,248,255,0.5)`, never `Opacity` widget on buttons.

### Item list spacing — system rule
Items are always individual white cards on cream background. The cream gap between cards IS the visual separator.
Gap between item cards: 6px (onboarding, preview, review) · 8px (dashboard, more breathing room)
Each item: background var(--surface) · border-radius 9-10px · border 0.5px solid rgba(26,22,18,0.08) · box-shadow 0 1px 3px rgba(26,22,18,0.04)
Container: display:flex · flex-direction:column · gap:6px (or 8px) · NO background · NO border · NO overflow:hidden
- Never border-bottom separators between items, items are cards, not table rows
- Never a single container card wrapping all items, each item is its own card

### Category filter strip

Used on S-03 (browse), S-09 (dashboard). S-01 no longer has a filter strip.

```
Layout: single horizontal scrollable row, flex-wrap:nowrap; overflow-x:auto; scrollbar-width:none
Gap: 4-5px between pills | Margin-bottom: 10-14px
```
**"All" pill always first, always the initial active state.**
Active pill: `background: rgba(155,127,212,0.06); color: var(--cta); border-color: var(--cta)`
Inactive pill: `background: var(--surface); border: 0.5px solid rgba(26,22,18,0.12); color: var(--mid-a)`
Pill shape: `border-radius: 100px; padding: 4px 10px; font-size: 10px; font-weight: 500; flex-shrink: 0`
Category pills include a colored dot (`width: 6px; height: 6px; border-radius: 50%`) in category color, then label.
Flutter: `SingleChildScrollView(scrollDirection: Axis.horizontal)` wrapping a `Row` of `FilterChip` widgets. Never a `Wrap`.
- Never wrap to a second line, always a single scrollable row.
- Never omit "All", it is always the first pill.

### Nudge cards
- White on cream background (subtle but essential, creates depth)
- NO left border accent lines, ever. Status lives in date label color only
- Swipe right to complete: threshold 40%, reveals done overlay on release
- Done state: opacity 0.35 + strikethrough, `AnimatedOpacity` 250ms

### Done overlay
- Background: `colorPlum #231833`, the only place this color appears in the app
- Spring animation: 400-450ms `cubic-bezier(0.34,1.56,0.64,1)` for ii mark scale + headline translateY
- This is the only theatrical motion in the app

### S-01 Welcome screen — layout spec
```
[Notch + status bar]
[Progress bar, full-width, edge-to-edge, 3px]
[Content area, flex:1, scrollable]
   ii mark (centered or left)
   Headline DM Serif Display 33px + subtitle italic DM Sans
   "Set up in 2 minutes" badge
   3 nudge bubbles (display only, category-tinted, staggered rotation)
[Sticky bottom zone, margin-top:auto]
   Path A: CTA fill, "Tell me what you have"
   Path B: border, "Show me what I can track"
   24px safe area padding
```

**"Set up in 2 minutes" badge:** Sits between the promise subtitle and the nudge bubbles. Clock icon (`PhosphorIcons.clock`, 9-11px, stroke `#6B6358`) + text "Set up in 2 minutes". Style: `background: rgba(26,22,18,0.05); border: 0.5px solid rgba(26,22,18,0.10); border-radius: 100px; padding: 3px 10px 3px 7px`. Font: 10px DM Sans 500, color `#6B6358`. Action-oriented framing (user takes action) vs passive ("ready").

**Nudge bubbles:** 3 display-only bubbles in nudgii's warm voice, category-tinted backgrounds (7% opacity), staggered rotation angles. See Nudge bubbles component spec above. No interactive items, no category filter strip, no free badge.

**Sticky bottom:** Flutter: Column with Expanded(child: scrollable content) + SizedBox bottom zone.
HTML mockups: flex column on screen, flex:1 on content, margin-top:auto on button zone.

### Progress indicator (onboarding)
Single continuous progress bar, fills left to right.
Height: 3px · Border-radius: 100px · Full-width, edge-to-edge below status bar (own dedicated row)
Background: rgba(26,22,18,0.08) · Fill: colorCta #9B7FD4
Step fills (S-01 to S-06):
- S-01: 20% (app opened, path not yet chosen)
- S-02 / S-03: 40% (path chosen, entering items)
- S-04: 60% (reviewing items)
- S-05: 80% (AHA schedule preview), 85% (celebration state)
- S-06: 100% (push permission)
Flutter: LinearProgressIndicator with custom colors + ClipRRect(borderRadius) + AnimatedContainer (300ms ease-in-out).
- Never segmented bars, any fixed visual count implies a fixed step count.
- Never dots, same problem.

### Example chips (S-02 voice onboarding)
Shown above the mic button to help cold-start users. Flex-wrap row.
Content (nl-BE): cv-ketel · vaatwasser · auto · olijfboom
Background: white/surface · Border: 0.5px solid rgba(26,22,18,0.13) · Border-radius: 100px · Padding: 2px 7px · Font: 8px DM Sans

### Last maintenance chip (S-03 browse)
Every item row shows a last-maintenance chip.
Default = "6 mnd geleden" (amber-lt background, amber text), NEVER "recent", NEVER empty.
User can change this on S-05. If user says they just maintained it, chip becomes "recent" (ink-06 bg, mid text).

### Toast (corrected)
Light semantic backgrounds, NEVER dark ink.
- Success: sage-lt #EAF3DE · text sage #3B6D11 · green dot
- Neutral (undo): cream #F5F0E8 · border bm · text ink · plum-lt dot
- Error: red-lt #FCEBEB · text red #A32D2D · terra dot
Shape: border-radius 100px · padding 9px 16px · max-width 260px
Position: center-bottom · 14px above tab bar
Duration: 2.5s visible · 250ms fade-out

### Error card (corrected)
NO border-left stripe. Full border with semantically-colored background.
Structure: icon-chip (28x28px, red-lt bg, terra icon) + title + body + action link
Background: red-lt #FCEBEB · Border: 1px solid rgba(163,45,45,0.18) · all sides
Action link: colorCta, underline, with right-arrow icon

### Icon container (S-06 Push)
Reusable centered-icon component for permission screens. SSO is now a bottom sheet in S-05, not a standalone screen.
```
Size: 56x56px | Border-radius: 16px
Background: rgba(155,127,212,0.08), CTA purple tint
Border: 0.5px solid rgba(155,127,212,0.15), CTA purple
Icon: 26px Phosphor outline, stroke colorCta (#9B7FD4), stroke-width 1.6
```
S-06 uses bell icon (functional: notifications).
The icon communicates function depending on context.

### Nudge bubbles (S-01 welcome)
Display-only preview bubbles showing nudgii's voice. Not interactive, no onTap, no hover, no selection state.
```
Size: content-width, max-width 85% of screen
Background: category color at 7% opacity (home rgba(200,120,80,0.07), garden rgba(90,144,96,0.07), vehicle rgba(74,130,160,0.07))
Border: none
Border-radius: 12px
Padding: 8px 12px 8px 8px
Rotation: staggered angles (-1.2deg, 0.8deg, -0.5deg)
Left margins: varied (8px, 32px, 18px) for organic feel
Gap: 12px between bubbles
```
Each bubble contains: category icon chip (22x22, same as elsewhere) + title (8px DM Sans 500) + subtitle (6.5px italic colorMid).
Content is in nudgii's warm voice: "Your boiler could use some love" not "Service the boiler."
Content is locale-dependent and seasonally rotated, stored in database.
Flutter: `Column` of non-interactive `Container` widgets with `Transform.rotate`. No `GestureDetector`, no `InkWell`.

### Centered content screen (S-06 Push)
Shared layout pattern for permission screens. S-05 has its own two-state pattern (AHA + celebration + sign-in sheet).
```
Content zone: flex:1, centered vertically + horizontally, padding 0 28px, text-align center
Bottom zone: sticky, fixed Column (CTA + ghost button)
No scroll needed, content is short
Progress bar: outside SafeArea, screen-specific % fill
No back button, forward-only flow, iOS swipe-back gesture handles navigation
```
Flutter: `Column(children: [progressBar, Expanded(Center(child: content)), bottomZone])`
