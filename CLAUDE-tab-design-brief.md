# Tab Design Brief: Today, Plan, My Stuff, Profile

> Use this file as the starting brief for designing each tab as a standalone hi-fi screen.
> Reference prototype: `screens/s09-dashboard-precision-warmth.html`
> Design system: Precision Warmth (Noto Serif + Manrope, plum + apricot, tonal surfaces)

## How to use this file

Work one tab at a time. Each tab becomes its own hi-fi screen file. Start each session with:

> "I want to design the [Today/Plan/My Stuff/Profile] tab as a hi-fi screen. Read CLAUDE-tab-design-brief.md for the brief."

---

## Shared elements (all 4 tabs)

**Nav bar:** solid surface background, no glassmorphism. Active tab = plum icon + plum label, no background shape. Tab order: Today, Plan, My Stuff, Profile. Fixed, never scrolls.

**FAB:** plum gradient, 17px Plus icon, floats above tab bar right-aligned. Rotates 45 degrees to X on open.

**Status bar:** 9:41, standard iOS

**Shell pattern:** SafeArea + Column + Expanded. Nav bar and FAB are outside scroll area.

**Typography:**
- Greeting/headlines: Noto Serif, 24px
- Section labels: Manrope, 10px, uppercase, letter-spacing 1.3px
- Task titles: Manrope, 14px, weight 500
- Subtitles: Manrope, 10-11px
- Body: Manrope, 12px

**Category colors:**
- Home: #C09088 (dusty rose)
- Garden: #8C9B80 (sage green)
- Vehicle: #8E9A94 (warm sage-slate)
- Subscriptions: #A69BBF (lavender)
- Health: #9A9A88 (olive)
- Pets: #B8A080 (warm amber)

**Surfaces:**
- --surface: #FBF9F4 (main bg)
- --surface-low: #F5F4ED (section backgrounds, "Why it matters" blocks)
- --surface-high: #E8E9E0 (stronger separation)
- --surface-lowest: #FFFFFF (cards if needed)

---

## Tab 1: Today

**Prototype:** `screens/s09-dashboard-precision-warmth.html` (Today tab)
**Standalone:** `screens/s09-today-prototype.html`
**User flow:** UF-02 Daily check-in

### Content zones (top to bottom)
1. **Greeting** (Noto Serif 24px): "Good morning, Martijn." Name in apricot italic.
2. **Summary line** (Manrope 13px): "3 things need attention today" + streak circle (apricot, 36-50px, tappable with tooltip)
3. **Overdue section**: section label + task cards with apricot "Xd overdue" text
4. **Due this week**: section label + task cards with date (e.g. "Wed 26")
5. **Coming up**: collapsible section, "next 30 days, X tasks"
6. **For you**: contextual cards row (Did you know, seasonal tips, missing items). Horizontally scrollable.

### Task card pattern
- 40px round circle with category wash bg + category icon
- Title (14px, 500) + subtitle (item name, frequency)
- Right side: date or "Xd overdue" in apricot
- Chevron to expand
- Expanded: "Why it matters" block (surface-low bg, apricot label) + Done/Snooze/Skip buttons
- Done button = category color (not plum)

### Design tasks for this session
- [ ] Define all states: default, empty ("Nothing due. Suspicious."), overdue only, all done
- [ ] Define task card expanded state with full detail
- [ ] Define streak circle tooltip content and dismiss behavior
- [ ] Define "For you" card types and rotation logic
- [ ] Define greeting variants (morning/afternoon/evening, signed-in vs not)
- [ ] Dark mode version
- [ ] Responsive: what happens with very long task titles?
- [ ] Hi-fi changelog entry

---

## Tab 2: Plan

**Prototype:** `screens/s09-dashboard-precision-warmth.html` (Plan tab)
**User flow:** UF-03 Plan review

### Content zones (top to bottom)
1. **Screen title** (Noto Serif 24px): "Plan"
2. **Filter chips**: All, Home, Garden, Vehicle, Subscriptions (horizontal scroll)
3. **Expandable filter panel**: date range, category, priority (behind filter icon)
4. **Monthly sections**: Month header with serif month name + % completion circle
5. **Task rows**: date column (day name + number) + icon circle + title + item name
6. **Seasonal quote cards**: between months, italic serif quote about the season
7. **Editorial quote**: bottom, personality moment

### Task row pattern (different from Today)
- Date column (50px): abbreviated day + date number, stacked
- Category icon circle (32px)
- Title + item name (same as Today but more compact)
- No expand on Plan, tap goes to task detail

### Design tasks for this session
- [ ] Define month header with completion circle
- [ ] Define seasonal quote card style
- [ ] Define filter chip active/inactive states
- [ ] Define expanded filter panel
- [ ] Define empty state ("No tasks planned. Add some items first.")
- [ ] Define how past months look (collapsed? hidden?)
- [ ] Dark mode version
- [ ] Hi-fi changelog entry

---

## Tab 3: My Stuff

**Prototype:** `screens/s09-dashboard-precision-warmth.html` (My Stuff tab)
**User flow:** UF-04 Item management

### Content zones (top to bottom)
1. **Screen title** (Noto Serif 24px): "My stuff"
2. **Category filter chips**: All, Home, Garden, Vehicle, Subscriptions
3. **Item cards**: full-width cards with item details
4. **Add item card**: dashed border, plum accent, "Add item" with + icon
5. **Go Pro meter** (free users): "7 of 10 free" + "Go Pro" link, above nav bar

### Item card pattern
- Category icon circle (40px, category wash bg)
- Item name (14px, 500) + task count + status badge
- Mini progress bar (% of tasks completed)
- Italic personality line ("Loyal since 2019", "Needs some love")
- Tap goes to S-17 item detail

### Status badges
- "On track" (sage text)
- "1 overdue" (apricot text)
- "Seasonal" (category color text)

### Design tasks for this session
- [ ] Define item card with all states (on track, overdue, seasonal, paused/Pro)
- [ ] Define "Add item" card style
- [ ] Define Go Pro meter for free users
- [ ] Define empty state ("No items yet. Add your first one.")
- [ ] Define paused item appearance (Pro badge, muted)
- [ ] Define sort/filter behavior
- [ ] Dark mode version
- [ ] Hi-fi changelog entry

---

## Tab 4: Profile

**Prototype:** `screens/s09-dashboard-precision-warmth.html` (Profile tab)
**User flow:** Related to UF-06 Pro upgrade

### Content zones (top to bottom)
1. **User greeting** (Noto Serif 24px): "Martijn" or avatar + name
2. **Stats row**: 3 circles (items owned/years, tasks completed, streak)
3. **Notification preferences card**: digest day/time, push on/off
4. **Account section**: email, plan (Free/Pro), manage subscription
5. **Settings rows**: dark mode toggle, language, region, export data
6. **Support/legal**: help, privacy, terms, version
7. **Sign out**

### Design tasks for this session
- [ ] Define stats circles style and content
- [ ] Define notification preferences card (toggle + day/time picker)
- [ ] Define Free vs Pro appearance difference
- [ ] Define settings row style (icon + label + value/toggle)
- [ ] Define "Upgrade to Pro" prominent placement for free users
- [ ] Dark mode version
- [ ] Hi-fi changelog entry

---

## Output per tab

Each completed tab should produce:
1. **Hi-fi HTML file**: `screens/s09-[tab]-hifi.html` with Design hub nav bar
2. **Changelog entry** in the HTML file (version + date + BREAKING/ADDITIVE + Flutter notes)
3. **index.html update**: link added to S-09 card
4. **CLAUDE.md update**: any new design decisions logged in Section 19

## File naming
- `screens/s09-today-hifi.html`
- `screens/s09-plan-hifi.html`
- `screens/s09-mystuff-hifi.html`
- `screens/s09-profile-hifi.html`
