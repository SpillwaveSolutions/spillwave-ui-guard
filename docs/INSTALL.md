# Installing Spillwave UI Guard

## One-command install into a target repo

From this repository:

```bash
./scripts/install-into-repo.sh /path/to/motion
./scripts/install-into-repo.sh /path/to/okf-forge
# ... etc.
```

Or via SKILZ (once published):

```bash
npx skilz install SpillwaveSolutions/spillwave-ui-guard
```

## What gets installed

| Path | Purpose |
|------|---------|
| `.spillwave/ui-guard/skills/` | Canonical copies of all skills |
| `wireframes/` | Directory + README for wireframes |
| `.claude/UI_GUARD.md` | Claude Code instructions |
| `.grok/plugins/spillwave-ui-guard/` | Grok Build plugin |
| `.grok/skills/` | Symlinks/copies of the skills for Grok discovery |
| `.cursor/rules/ui-guard.mdc` | Cursor rule |
| `AGENTS.md` (created or appended) | Cursor / Codex agent instructions |
| `hooks/pre-commit-ui-guard.sh` | Soft pre-commit reminder |

## Making the pre-commit check hard

```bash
export UI_GUARD_STRICT=1
# or set it in CI
```

To skip intentionally:

```bash
SKIP_UI_GUARD=1 git commit ...
```

## Host-specific notes

### Claude Code
- Skills under `.spillwave/ui-guard/skills/` can be referenced or copied into Claude's skill paths.
- `CLAUDE.md` (or `.claude/UI_GUARD.md`) tells the agent to use the wireframe-first flow.

### Grok Build
- Plugin lives at `.grok/plugins/spillwave-ui-guard/`.
- Skills are also linked under `.grok/skills/` so they are discoverable.

### Cursor / Codex
- Rule is always-on via `.cursor/rules/ui-guard.mdc`.
- `AGENTS.md` provides portable instructions.

## After install

1. Create initial wireframes for the main screens of the app.
2. Add a short note in the app's README or CLAUDE.md pointing developers at the UI Guard workflow.
3. Optionally add a CI job that runs the adversarial review on UI-related PRs.
