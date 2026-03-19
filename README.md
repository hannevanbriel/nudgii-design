# nudgii — Design Hub

Design handoff site for the nudgii app. All screens, lo-fi nudges, hi-fi nudges, and design system references in one place.

## For developers

Open `index.html` in a browser — or visit the GitHub Pages URL — and you have everything you need to build any screen.

**Status badges tell you what to do:**
- 🟢 **Ready for dev** — build it. Lo-fi and hi-fi both done, decisions resolved.
- 🟣 **In progress** — lo-fi done, hi-fi still being built. Check what's available.
- ⚫ **To do** — not started yet. Don't build this screen yet.
- 🔴 **Decision needed** — a product decision is blocking design. See the "Open decisions" section at the top of the hub.

**Before building any screen**, open the Design System first:
- `system/design-system.html` — colors, typography, spacing, all components
- `system/interaction-states.html` — every component state and Flutter notes
- `system/icon-inventory.html` — all 39 icons with Phosphor names and Flutter constants

## Folder structure

```
nudgii-design/
  index.html              ← design hub — start here
  system/
    design-system.html    ← design system v2.3 (locked)
    interaction-states.html
    icon-inventory.html
    fab-spec.html
    tokens.json           ← Figma Variables JSON (Tokens Studio)
    figma-guide.html
  screens/
    s01-welcome-hifi.html
    s05-onboarding-review-hifi.html
    s12-fab-action-sheet-hifi.html
    s13-task-detail-lofi.html
    s15-snooze-lofi.html
    (more added as design progresses)
```

## GitHub Pages setup

1. Push this repo to GitHub
2. Go to Settings → Pages → Source: Deploy from branch → main → / (root)
3. Save — site goes live at `https://[username].github.io/nudgii-design`
4. Paste that URL into every ClickUp task description under "Design reference"

## Updating

When a screen moves to a new status:
1. Open `index.html`
2. Find the screen card (search for the screen ID, e.g. `S-13`)
3. Update the `badge` class: `b-todo` → `b-wip` → `b-ready`
4. Add the link to the nudge pill (replace the `.np.off` span with a working `<a>` tag)
5. Commit and push — GitHub Pages updates in ~30 seconds

## Tech stack (app)

Flutter + Riverpod + GoRouter · Supabase (PostgreSQL + Auth + RLS) · Claude API · Phosphor Icons · DM Serif Display + DM Sans
