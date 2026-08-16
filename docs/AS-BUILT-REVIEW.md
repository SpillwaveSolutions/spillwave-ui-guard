# Adversarial Review: as-built wireframe contracts

**Wireframe:** all six Spillwave apps, first critic pass after the as-built drop  
**Verdict:** PASS WITH NOTES (okf-forge, motion) / FAIL then fixed (four thinner sets)

This is a **contract** review (wireframe vs source), not a running-app review. A later pass must launch each UI.

## Criteria used

- Required sections: Goal / Screen, Layout, Key Elements, States, Acceptance.
- Acceptance criteria must be observable in the current code (as-built, not a redesign).
- Do not invent roles, shortcuts, or labels the product does not have.

## Findings

### okf-forge / motion — PASS WITH NOTES

Contracts match AppShell / editor / slash / synthesize closely enough to review against. Notes only: some AC could name exact `data-testid`s and empty-copy strings.

### forge-notes — FAIL (contract drift)

- Overlays file used informal `Acceptance:` bullets and omitted **⌘/Ctrl+K** (wired in `CommandPalette`).
- Sign-in label is **Sign in to sync**, not “Sign in”.
- Sync chip and auth controls are `sm+` only.
- Empty workspace copy also offers linking a folder without import.

### wiki_ticket_sdd_ui — FAIL (contract invented UI)

- Picker is a `div` overlay, **not** `role=dialog`. Claiming dialog would make every review FAIL forever.
- TopBar button label is **Repo**, not “Change repo”.
- Tabs exist in **Tauri only**. Browser remembers paths and does not switch live.
- Folder must contain `.work/config.yml`. Switch reloads the window.

### agent-brain-ui — PASS WITH NOTES

- Desktop sidebar is sticky `h-dvh`; active-brain select is **desktop-only** (correctly scoped in AC).
- Mobile drawer has no brain select / status.
- Pages file needed a top-level Acceptance rollup for the checker.

### skill-db-viewer — FAIL (contract + product bugs)

- `NavLink` to `/` has no `end`, so Dashboard stays active on every route.
- Header advertises **Cmd+K for search**; `useKeyboardShortcuts` only maps ⌘/Ctrl+1–7 and there is no Cmd+K handler.
- Sidebar is always `w-64` — no mobile drawer (as-built).
- Compare requires **two** selected skills; one shows “Select 1 more”.

## Required follow-up (this pass)

1. Harden `scripts/check-ui-guard.sh` so missing/empty/sectionless wireframes fail, and CI cannot fall through to the pre-commit hook (which sees no staged files in Actions).
2. Rewrite the four thinner contracts so AC match source.
3. First build-mode change: skill-db Dashboard `end` match + header shortcut copy.

## Hard rules honored

- Critic did not treat “we wrote the wireframe last turn” as a PASS.
- As-built files must describe current UI; intended fixes go in the same PR as the code change.
