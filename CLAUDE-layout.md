# CLAUDE-layout.md — nudgii layout, shell pattern & responsive behaviour

> Referenced from CLAUDE.md. Read this file when building new screens, implementing Flutter layouts, or creating hi-fi changelogs.

---

## 16. Layout, shell pattern & responsive behaviour

> These rules apply to EVERY screen: lo-fi, hi-fi, mockup, prototype, and Flutter code. Apply them without being asked.

nudgii builds mobile-first for iOS (primary) and Android (secondary). iPad is planned post-launch.

---

### Mockup standard

All HTML mockups: **390x844px** (iPhone 15 logical pixels). Phone frame: `border-radius: 50px`. Notch pill: `width: 102px; height: 8px`. This is the exact size Flutter builds at.

| Device | Width | Scale vs 390 |
|---|---|---|
| iPhone SE | 375px | 0.96 |
| iPhone 15 | 390px | 1.00 (basis) |
| iPhone 15 Pro | 393px | 1.01 |
| iPhone 15 Plus / Pro Max | 430px | 1.10 |

---

### Shell pattern — every screen uses this structure

```
SafeArea (handles notch, home indicator, status bar automatically)
+-- Column
    +-- Fixed: progress bar (onboarding S-01 to S-08) OR status/greeting row (app S-09+)
    +-- Expanded: SingleChildScrollView, scrollable content zone
    +-- Fixed: bottom zone (sticky CTAs onboarding OR floating tab bar app), never both
```

**Applied to every new screen, no exceptions. Never flatten this into a single scrollable view.**

---

### SafeArea rules

- **Always wrap screens in SafeArea.** It absorbs the difference between Face ID (34px), Home button (0px), and Android home bar (varies).
- **Never hardcode bottom padding** for safe area, SafeArea handles it.
- **Progress bar is outside SafeArea**, it sits above the safe area, bleeding full-width under the status bar. `top: false` on SafeArea, progress bar in its own full-bleed row before the SafeArea kicks in.
- Flutter: `SafeArea(top: false, child: Column([progressBar, Expanded(content), bottomZone]))`

---

### Sticky bottom zone

- **Onboarding (S-01 to S-08):** Fixed Column at the bottom of the screen. CTAs stack vertically. 24px padding-bottom + SafeArea inset.
- **App (S-09+):** Floating pill tab bar, 52px height, 14px from screen edge + SafeArea.
- **Never use `Spacer` to push the bottom zone**, use a fixed Column that sits outside the Expanded content zone.
- **Never put both a sticky CTA zone and a tab bar on the same screen.**
- HTML mockups: `flex: 1` on content zone + `margin-top: auto` on button zone.

---

### Progress bar (onboarding)

- Full-width, edge-to-edge, **outside SafeArea**, no side padding, no indent.
- Height: 3px · border-radius: 100px · track: `rgba(26,22,18,0.08)` · fill: `colorCta #9B7FD4`
- Steps: S-01 = 20% · S-02/S-03 = 40% · S-05 = 60% · S-06 = 80%/85% · S-07 = 90% · S-08 = 95%
- Flutter: `LinearProgressIndicator` inside `ClipRRect(borderRadius: 100px)` + `AnimatedContainer` 300ms ease-in-out.
- **Never use dots, steps, or any fixed-count indicator**, a fixed count implies a fixed number of screens.

---

### Responsive scaling

**Scaling formula (Flutter):** `All visual elements x (screenWidth / 390).clamp(0.9, 1.15)`

This keeps the design proportional on SE (375px) through Pro Max (430px) without distorting at extremes.

**Headline breakpoints:**
- Default (>= 380px): welcome 33px · greeting 25-27px
- Small (< 380px, SE): welcome 28px · greeting 22px
- Flutter: `MediaQuery.of(context).size.width < 380 ? 28.0 : 33.0`

**Side padding breakpoints:**
- Default (< 420px): 16px horizontal
- Large (>= 420px, Pro Max): 20-24px horizontal

**Text scale cap (accessibility), apply at app root:**
`MediaQuery.of(context).copyWith(textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.85, 1.3))`

---

### Scroll behaviour

- **Content zone only** uses `SingleChildScrollView`, not the entire screen.
- The fixed top row (progress bar / greeting) and the fixed bottom zone (CTAs / tab bar) never scroll.
- If content is short, it simply doesn't scroll, the bottom zone stays anchored regardless.

---

**iPad (post-launch):** Two-column layout, sidebar nav replacing tab bar. Not in current scope, avoid hardcoding anything that breaks at 768px+ width.

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
| What changed | Plain language description of the visual change, what the developer will see on screen |
| Flutter notes | Implementation detail: position, scroll behaviour, sticky zones, scaling, widget type |

### Standard Flutter implementation block — bottom of every hi-fi

Add this block verbatim at the end of every hi-fi changelog section, updating the `Special` row per screen:

```
Mockup base:    390px width (iPhone 15)
SafeArea:       top=false for content, progress bar outside SafeArea
Scroll:         SingleChildScrollView for content zone
Bottom zone:    Sticky, fixed Column at bottom, not Spacer
Progress bar:   Full width, height 3px, outside SafeArea
Scaling:        All visual elements x (screenWidth/390).clamp(0.9, 1.15)
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
