# nudgii — Post-onboarding UX/UI design decisions

Session: March 28–29, 2026. Covers S-09 (dashboard) and all post-onboarding screens.
Reference prototypes: `nudgii-v9-master.html` (master), plus individual feature files.

---

## 1. Navigation architecture

### 4-tab structure (replaces the original 3-tab Home/Items/Settings)

| Tab | Icon | Purpose | Primary persona |
|-----|------|---------|-----------------|
| Today | House | Daily rhythm: what needs attention now | Martijn |
| Calendar | Calendar | Planning view: week/month, season bar, filtered tasks | Sara |
| My Stuff | Briefcase | Item inventory: tile grid grouped by category | All |
| Profile | User circle | Account, stats, notification modes, settings | All |

The Calendar tab was added because user testing showed people wanted to tap date elements on the dashboard. My Stuff uses the briefcase icon (not a grid icon). Profile uses a user icon (not Faders/settings gear). The avatar was removed from the dashboard header and lives exclusively in the Profile tab.

### FAB (Floating Action Button)

Position: bottom-right, adjacent to the pill tab bar, NOT inside it. Size: 46×46px, border-radius 15px (rounded square, not circle). Background: CTA purple `#9B7FD4`. Icon: plus, 17px, white. The plus rotates 45° to become an X when the action sheet is open.

Action sheet order (ergonomics, lowest effort nearest thumb):
1. **Scan** (bottom, nearest thumb) — camera icon, "Scan something" → opens camera, Claude Vision / Plant.id identifies item
2. **Tell me** (middle) — mic icon, "Tell me what you have" → opens AI chat (voice OR text), handles existing templates + completely new items
3. **Browse** (top) — grid icon, "Browse and search" → opens category grid with search bar, shows template items from the system

Each option has a distinct input modality: camera (point at world), conversation (describe it), grid (find it in a list). No overlap. Scan is fastest (no typing), Browse is most deliberate (Sara's control path).

Each option: 42px rounded-square icon container (white card, purple icon stroke) + label pill to its left. A cream blur scrim (backdrop-filter: blur 4px) covers the screen behind. Tapping any option or the scrim closes the FAB.

---

## 2. Today tab — screen anatomy

### Header
- Time-aware greeting: "Good morning, **Martijn.**" (name in apricot italic, DM Serif Display)
- No avatar here (lives in Profile tab)

### Status strip
- **Ring** (44×44px): purple arc showing items-on-track/total (e.g., 11/14). Gives reassurance, not just bad news.
- **Text**: "3 things need attention" + "11 of 14 items on track"
- **Weekly streak pill** (right-aligned): apricot tinted, shows streak count + "week streak"

### Tip card
- Purple-tinted card with icon, title ("Did you know?"), body text, and two actions: "Add gutters · Dismiss"
- Surfaces nudgii's proactive knowledge (e.g., "Most Belgian homes need gutter cleaning twice a year.")
- Dismissible — tapping "Dismiss" hides it

### Featured nudge card
- The single most urgent/overdue task gets hero treatment
- Shows: category icon, urgency label ("overdue · 12 days"), task title (terra red), item name, and a "why it matters" teaser
- The "why it matters" block surfaces nudgii's knowledge differentiator at dashboard level
- Tapping opens the **task detail bottom sheet**

### Also overdue / Due this week sections
- Section label + compact task cards (max 3 per section, "See all" link for overflow)
- Each card: category icon, task name, item name, due badge (terra for overdue, apricot for this week)
- Swipe hint below: "swipe right to complete · tap for options"
- Tapping a compact card opens the **quick action bottom sheet**

### Coming up (timeline)
- Section label "coming up" + "next 30 days" link
- Timeline layout: date (left), vertical line with category dot, task name + item name (right)
- Divider lines between entries
- This section is ALWAYS visible — items with yearly tasks mean something is always on the horizon

### Voice bar
- Full-width pill at bottom of content: "Ask nudgii anything..." + mic button (purple circle)
- Tapping opens the **chat conversation bottom sheet**
- Same entry point as the FAB "Voice" option — both open the same chat

### Victory header (all-on-track state)
- Triggers when: 0 overdue AND 0 due this week
- Ring shows full circle (e.g., 14/14). Text: "All on track this week"
- The pill-house illustration replaces the overdue and due-this-week sections
- Copy: "Nothing overdue. Suspicious." + "Your house is quietly grateful."
- The coming-up timeline still shows below — the screen is never empty

---

## 3. Calendar tab

### Header
- Month/year title in DM Serif Display
- Week/Month toggle (pill buttons, right-aligned)

### Week view
- 7-day strip with day name, date number, category-colored dots below each day
- Selected day: purple background, white text, white dots
- Tapping a day filters the task list below

### Month view
- Standard calendar grid with muted previous/next month days
- Today: purple circle
- Days with tasks: small dot below the number
- Tap to filter tasks for that day

### Season bar
- Green-tinted pill: leaf icon + "Spring tasks active"
- Appears when seasonal tasks are relevant

### Seasonal achievement card (gamification)
- Sage-tinted card with badge icon, achievement name ("Winter survivor"), description, and progress dots
- 5 dots, filled dots = completed autumn prep tasks
- Sits naturally in the seasonal section — not a separate gamification screen

### Task list
- Section header: day name + **Export button** (purple pill: download icon + "Export")
- Task cards: same format as Today tab, tappable for detail/quick sheets

### Export flow
- Tapping Export opens the **export bottom sheet**
- Shows: task preview (with ii mark, date range, category dots), format options (PDF / Calendar / Share), CTA
- Format options update the CTA label ("Export as PDF" / "Export as Calendar" / "Export as Share")
- PDF includes history. Calendar adds to Apple/Google. Share triggers iOS share sheet.
- Export is a **Pro-only feature** (free tier shows upgrade prompt instead)

---

## 4. My Stuff tab

### Header
- "My stuff" in DM Serif Display + item/task count ("5 items · 14 tasks")

### Tile grid
- Grouped by category (category dot + label + item count)
- 2-column tile grid within each category
- Each tile: category-tinted background, icon, item name, task count, status dot (top-right: terra=overdue, sage=on track, apricot=due soon)
- "Add item" dashed tile at the end of the last category (triggers FAB)

### Item detail (bottom sheet or push screen)
- Header: large category icon + item name (DM Serif Display) + meta ("Home · added Oct 2024")
- Edit (pencil) and Delete (trash, terra red) as **icon buttons in the header row** — no separate actions section
- Status chips: "1 overdue" (terra) + "3 on track" (sage) + "4 tasks total" (neutral)
- Task rows: status dot, task name, frequency text + cadence dots + next due date, chevron
- Cadence dots: 1 dot = yearly, 2 = every 6 months, 3 = every 3 months, 4 = every 6-8 weeks
- **Soft-deleted tasks**: dimmed row (opacity 0.45), strikethrough title, "Was every 6 months · removed Mar 10", red "removed" badge, purple "Restore" link. Also appears in history as "Removed · Mar 10"
- **Export pill** below task list: centered, purple-tinted, "Export tasks"
- Recent history section: task name + "Done · date" in sage, or "Removed · date" in terra

---

## 5. Profile tab

### Top section
- Avatar circle (purple tinted), name (DM Serif Display), email, plan badge ("free plan")
- Usage bar: "5 of 10 items" + "Go Pro" link + progress bar

### Stats row
- Three cards: total completed, week streak, active tasks

### Notification modes
- Three selectable cards: Calm (digest only), Regular (digest + push), Proactive (before + after due)
- Active mode has purple border highlight

### Settings
- Dark mode toggle (plum dark mode)
- Digest day and time (Monday 08:00)
- Region and language (Belgium · NL)
- Account

---

## 6. Bottom sheet patterns

### Quick action sheet (tap any compact task card)
- Small sheet (~50% height): task name, item + overdue info, three action rows
- **Done** (sage green icon): "Mark complete, schedule next"
- **Snooze** (apricot icon): "1 day, 3 days, 1 week"
- **Skip** (neutral icon): "Schedule the next occurrence"
- Cancel link at bottom

### Task detail sheet (tap featured card)
- Large sheet (~85% height): category icon + item name, task title, witty opener, meta pills (overdue count, frequency, last done), "why it matters" block, "how to do it" block
- **Done CTA** (full-width purple button): "Mark as done"
- Ghost actions row: Snooze / Skip / Edit / Remove (Remove in terra red)
- Close link at bottom
- On-track tasks: simpler version without Done/Snooze/Skip (no active nudge to act on — just Edit and Remove)

### Task vs. nudge distinction
- **Item detail (My Stuff)**: shows tasks (templates). Each row = a recurring maintenance activity with its interval, cadence dots, and next due date. Tapping opens the task detail sheet where you edit the interval or remove the task.
- **Today / Calendar**: shows nudges (instances). Each card = one specific due occurrence. The quick actions (Done/Snooze/Skip) operate on the nudge.
- When Martijn taps Done on a nudge, the system creates the next nudge at today + interval. When Sara changes the interval on a task, the next nudge recalculates.

---

## 7. Conversational AI layer

### Entry points
- Voice bar on Today tab ("Ask nudgii anything...")
- FAB → "Tell me what you have"

### Chat bottom sheet
- Full-height sheet (~92%)
- Opens with: "Hey Martijn. What's on your mind?" + three suggestion chips
- Input bar: scan icon (left), text placeholder (center), mic button (right, purple circle)
- Privacy note always visible: "audio sent for transcription only · deleted after · responds in text"

### Three conversation modes
1. **Query**: "What's most urgent?" → nudgii reads user data, responds conversationally
2. **Add**: "Add my espresso machine" → nudgii creates item with tasks, shows green confirmed chip
3. **Edit**: "Change boiler service to 6 months" → nudgii confirms interval change, shows confirmed chip

### Bubble styles
- nudgii: left-aligned, white/card background, rounded corners with flat bottom-left, "nudgii" label (8px, lowercase, never uppercased)
- User: right-aligned, purple background, white text, flat bottom-right

---

## 8. Dark mode

### Black dark mode (preferred — confirmed March 29, 2026)
| Token | Light | Dark (black) |
|-------|-------|-----------|
| --bg | #F5F0E8 | #111614 |
| --card | #FFFFFF | #1A1F1D |
| --text | #1A1612 | #EFF0E8 |
| --text-mid | #6B6358 | #96A89C |
| --text-hint | #8A8070 | #6B7A6F |
| --border | rgba(26,22,18,0.08) | rgba(255,255,255,0.08) |

CTA purple `#9B7FD4` stays identical in both modes. The done overlay plum `#2D1F4A` is lighter than the dark mode background `#111614`, so it pops clearly. The scrim adjusts: cream blur (light) → dark blur (dark). User preference stored in user_profiles — not system-follows-device (cream is part of nudgii's personality).

Note: plum dark mode (`#1A1433`) was explored during the design session but black was chosen as the preferred option. Plum felt too distinctive for daily use — black is more universal while the done overlay plum still provides the branded moment.

---

## 9. Illustration system

### Design rule
Only two shapes: pills (rounded rectangles where rx = half width) and circles/dots. No literal objects. Colors exclusively from nudgii token palette. Opacity 0.1–0.7 for depth, no gradients. Under 2KB each. Hanne adds grain texture in Figma as final pass.

### Six illustrations

| # | Name | Background | Placement | Description |
|---|------|-----------|-----------|-------------|
| 1 | All caught up | cream | Today tab victory header | Pill-house + green checkmark + floating category dots + small plant |
| 2 | Celebration | plum | S-05 state 2 | ii mark centered + confetti dots and mini pills in category colors |
| 3 | Spring garden | cream | Calendar (Garden filter) / digest email | Three pill-stems + dot-flowers + faint sun circle |
| 4 | Pro upgrade | cream | Upgrade prompt (10-item ceiling) | Circle of 10 category-colored dots (items) with ii mark center, 11th apricot dot floating outside with dashed path reaching toward the circle |
| 5 | First task done | plum | S-11 done overlay | Single purple pill + checkmark + celebration dots |
| 6 | Your year filling up | cream | Calendar first load (edge case, dropped from priority) | Pill-topped calendar frame + category dot grid + small leaf |

---

## 10. Gamification

### Philosophy
Reward through recognition and warmth, never through loss aversion or guilt. nudgii celebrates what you've done, never shames you for what you haven't.

### What does NOT fit nudgii
- Points system, virtual currency, leaderboards, daily streaks, badge collection screen, progress bars toward "levels," mascots, virtual rooms. These contradict the "witty, competent friend" voice.

### Three mechanics that fit

#### 1. Weekly streak (already built)
- The only frequency that makes sense for home maintenance
- Apricot-tinted pill on Today tab status strip
- If streak breaks: "Welcome back. Picking up where you left off." — never punishment
- Grace period: opening the weekly digest email counts as engagement

#### 2. Milestone moments
- Celebrate total completions: 10th task, 50th, 100th, first full year
- Full-screen plum celebration overlay with ii mark illustration, large count number, witty copy
- Example (50th): "Half a hundred. Your stuff approves." + "That's 50 things you didn't forget, skip, or quietly hope would fix themselves."
- Triggered naturally when a task completion crosses the threshold — one-time surprise, not an expected reward
- No badge collection screen. No "you're 3 tasks away." Just a warm moment when it happens.

#### 3. Seasonal achievements
- "Winter survivor" — all autumn prep tasks completed before December 1st
- "Spring ready" — garden + car seasonal tasks done before season starts
- "Full cycle" — all four seasons completed in one year
- Progress card on Calendar tab: sage-tinted, badge icon, description, progress dots
- Tied to nudgii's seasonal engine — feels earned, not manufactured

### Where gamification lives in the UI
- Weekly streak: Today tab status strip (pill)
- Milestones: celebration overlay (plum bg, same pattern as S-05 done overlay)
- Seasonal achievements: Calendar tab (progress card) + weekly digest email

### Key research data points
- Apps combining streaks + milestones see 40-60% higher DAU
- Users 2.3x more likely to engage daily after 7+ day streak
- But: broken streaks cause churn — users who break often never return
- Tody's "Dusty" challenges: 30% higher consistency with gamification enabled

---

## 11. Category colors

| Category | Color | Hex |
|----------|-------|-----|
| Home & Appliances | Terracotta | #C87850 |
| Vehicle | Steel blue | #4A82A0 |
| Garden & Plants | Sage green | #5A9060 |
| Subscriptions | Purple | #8060A8 |
| Health | Rose | #B86478 |
| Pets | Warm olive | #A08050 |

Minor concern: Subscriptions purple `#8060A8` is close to CTA purple `#9B7FD4`. Could shift to `#9068B0` if needed — decision pending.

---

## 12. Competitive insights applied

| App | Key takeaway | How it influenced nudgii |
|-----|-------------|------------------------|
| Tiimo (2025 App of the Year) | Visual planner for ADHD, personality through visuals creates return habit. But Tiimo is a planner (user builds schedule); nudgii is an assistant (app fills schedule). | Visual warmth matters for retention. Illustrations earn their place. |
| Tody | Condition-based cleaning, "Dusty" mascot with monthly challenges, 1M+ users | Gamification works for cleaning, but mascots don't fit nudgii's maturity. Progress visualization (their dirt meter = our status ring) validated. |
| Sweepy | Points, leaderboards, virtual rooms. Recommended for families + ADHD. | Leaderboards = relationship conflict for couples. Points cheapen real accomplishments. Not for nudgii. |
| Planta | Plant care reminders, 4M+ users, European origin, validates willingness to pay for care/reminder category | Proves the model works in Europe at scale. |
| Wispr Flow | "Tap, speak, done" simplicity. Dead-simple profile screen (name, plan, usage, 3 links). | Profile screen inspiration. Voice-first interaction validated. |

---

## 13. Prototype files produced

| File | What it covers |
|------|---------------|
| `nudgii-v9-master.html` | **MASTER**: All 4 tabs, FAB, task detail + quick action sheets, chat, dark mode, export, gamification |
| `nudgii-v8-master.html` | Previous master (all tabs + chat, before dark mode/export/gamification) |
| `nudgii-v7-tasks-fab.html` | Item detail with task rows, cadence dots, soft-delete, FAB action sheet |
| `nudgii-v6-plum-sheets.html` | Light vs plum dark mode side by side + bottom sheets |
| `nudgii-v5-illustrated.html` | 5-state toggle: tasks due, all on track, calendar, my stuff, profile |
| `nudgii-export-feature.html` | Export from Calendar + item detail, two phones |
| `nudgii-item-detail-clean.html` | Simplified item detail with edit/delete in header, export pill |
| `nudgii-illustrations-v1.html` | 6 standalone illustrations with design notes |
| `nudgii-illustrations-in-context.html` | 6 illustrations in phone frames with real UI context |

---

## 14. Pending items

- [ ] Integrate dark mode toggle into v9 master (currently only on Profile) — done
- [ ] Integrate export into v9 master (Calendar entry point) — done
- [ ] Finalize Subscriptions category color (#8060A8 vs #9068B0)
- [ ] Celebration screen copy needs dynamic logic (currently hardcoded to "boiler" — must reflect actual item)
- [ ] Update CLAUDE.md with all new decisions from this session
- [ ] Update ClickUp with all new tasks from this session
- [ ] Build item detail as a full push screen (currently a bottom sheet in the prototype — may need full screen for production)
- [ ] Add the "all on track" victory state with illustration into the v9 master
- [ ] Add plum dark mode color tokens formally to design system
- [ ] Finalize notification mode UX on Profile (Calm / Regular / Proactive)
- [ ] Design snooze bottom sheet with time picker options
- [ ] Design the FAB → Browse categories flow (S-03 pattern)
- [ ] Design the FAB → Search flow (S-04 pattern)
