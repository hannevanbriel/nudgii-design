# CLAUDE-screen-specs.md — nudgii personas, micro-improvements & screen-specific specs

> Referenced from CLAUDE.md. Read this file when working on specific screens, personas, or onboarding UX decisions.

---

## 13. Personas (brief)

**Martijn** — busy homeowner, 38, Belgium. Owns a house, car, garden, several subscriptions. Organized enough to want a system, too busy to build one. Onboarding: Path A (Voice). Upgrades month 2-3. Primary persona.

**Sara** — detail-oriented organizer, 44, city apartment. Wants one central hub with full precision. Already has an overbuilt Notion system. Onboarding: Path C (Search). Upgrades month 1-2 when she hits the custom interval limit. Primary persona.

**Lena** — first-time homeowner, 29. Doesn't know what maintenance a home requires, learning as she goes, usually after something breaks. Needs guided onboarding and the "why this matters" explanations. Onboarding: Path A (Guided conversation). Upgrades month 3-6. Secondary persona. Word-of-mouth engine.

**Arne** — power user, 41, large home, Belgium or Netherlands. Owns a lot: multiple AC units, cars, established garden, dozen subscriptions. Not looking to be guided, looking to configure fast. Has tried other apps and found them too slow or too limited. Onboarding: Path B (Browse fast). Hits the 10-item ceiling on day 3 and upgrades immediately without reading the upgrade copy. **Highest revenue-per-user of all four personas.** Key design constraint: never more than one clarifying question per voice interaction, no loading state over 500ms during browsing, review screen must not force expanding all items.

---

## 17. Onboarding UX decisions — micro-improvements

These 5 tweaks were applied across the onboarding flow (2026-03-23) to reduce drop-off and uncertainty. Do not revert them.

| Screen | Tweak | Rationale |
|---|---|---|
| S-01 | "Set up in 2 minutes" badge between subtitle and task rows (was "Ready in 2 minutes") | Action-oriented framing, sets time expectation before path-choice |
| S-02 | Sub includes "2-3 items is plenty to start." hint (italic, `colorMidAccessible`) | Cold-start users freeze when they think they need to add everything at once |
| S-05 | Sub: "Scan to confirm brand or model. You can adjust anything later." | Reduces review-screen friction; reminds user the AI scan is available; "adjust later" lowers perfectionism |
| S-08 | "Not now" is a visible ghost button (was "Continue without account" as 60%-opacity whisper) | Lower-commitment path must be findable. Renamed after SSO replaced email auth |
| S-06 | Sub: "We'll remind you when it matters." on celebration state | User-centric framing (what they get) vs brand-centric (what we do) |
| S-09 | "swipe right to complete" gesture hint below first overdue task | First-time users don't discover swipe on their own; hint disappears after first completion |

---

## 22. S-02 conversation UI pattern — spec

Resolved 2026-03-23. Applies to any screen that uses a chat-thread conversation between nudgii and the user.

### Layout
- Shell: SafeArea + Expanded(scrollable conversation thread) + fixed input bar at bottom
- No screen title above the conversation, the nudgii opening bubble IS the screen entry point
- Progress bar: full-width, outside SafeArea, at correct % for this step
- Back button: PhosphorIcons.arrowLeft, 44x44px tap target, left of top row

### Conversation thread
- Scrollable, fills the Expanded zone
- nudgii bubbles: left-aligned, white surface bg, 0.5px border rgba(26,22,18,0.08), border-radius 12px 12px 12px 4px (bottom-left flat = sender side), max-width 88%
- Sender label above first bubble in a sequence: 8px DM Sans 500, 0.4px letter-spacing, no text-transform, colorMidAccessible. Text: "nudgii", always lowercase, never "NUDGII", no CSS uppercase transform ever
- User bubbles: right-aligned, colorCta (#9B7FD4) bg, colorCtaFg text, border-radius 12px 12px 4px 12px (bottom-right flat), max-width 84%
- Confirmed items chips: sage-lt (#EAF3DE) bg, sage (#3B6D11) text, checkmark icon, appear inside nudgii's confirmation bubble after a turn
- Suggestion chips: surface bg, 0.5px border rgba(26,22,18,0.13), 100px radius, 8px DM Sans, update contextually after each turn
- Hint sub-text (cold start): 8px italic DM Sans, colorMidAccessible, below nudgii's first bubble

### Context carry-over from S-01
If the user tapped or selected items on S-01 before choosing Path A: those items are pre-loaded into the conversation. nudgii opens with "I see you added [X, Y]. What else do you have?" and shows the pre-loaded items as confirmed chips. Never ask users for information they already gave. If no items were selected on S-01, nudgii opens fresh.

### Input bar (fixed, bottom of screen)
- Background: surface white, border 0.5px solid rgba(26,22,18,0.12), border-radius 100px
- Left: PhosphorIcons.scan, 14px, colorMidAccessible, 44x44px tap target
- Center: text input placeholder, 8px italic, rgba(107,99,88,0.45)
- Right: mic button, 28px circle, colorCta bg, PhosphorIcons.microphone 13px, colorCtaFg stroke
- Active recording state: border-color rgba(196,80,58,0.30), placeholder text changes, mic button turns colorTerra
- Privacy note below bar: "audio sent for transcription only · deleted after · responds in text", 7px italic DM Sans, rgba(107,99,88,0.45), always visible

### Listening state
- Waveform animation appears in the conversation area (not floating over input bar)
- Live transcript builds as a faint user bubble (opacity 0.65) as speech is recognized
- Max 1 minute per turn, countdown appears at 50s remaining

### Copy direction
- nudgii's opening message frames it as discovery, not inventory. "What do you have at home?" not "What do you own?". The user doesn't need to know what maintenance is required, that's nudgii's job.
- Single question per turn, max 1 clarifying question
- Italic CTA-colored emphasis on the key question within a nudgii bubble
- nudgii's tone: warm, direct, gently funny, never clinical, never a form
