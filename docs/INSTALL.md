# Installing Spillwave UI Guard

Prefer native marketplace install when the host supports it. See [HOSTS.md](HOSTS.md).

## Marketplace (plugin hosts)

```bash
# Claude Code
/plugin marketplace add SpillwaveSolutions/spillwave-ui-guard
/plugin install spillwave-ui-guard@spillwave-ui-guard

# Codex
codex plugin marketplace add SpillwaveSolutions/spillwave-ui-guard

# Cursor
# Dashboard → Plugins → import SpillwaveSolutions/spillwave-ui-guard
# or: ln -s /path/to/spillwave-ui-guard ~/.cursor/plugins/local/spillwave-ui-guard

# Grok Build
# Add this repo as a marketplace source, then install spillwave-ui-guard
```

Marketplace install loads skills / rules / agents / commands. It does **not** create `wireframes/` or the CI checker in an app repo. Use the vendored install below for that.

## One-command vendored install into a target repo

From this repository:

```bash
./scripts/install-into-repo.sh /path/to/motion
./scripts/install-into-repo.sh /path/to/okf-forge
```

Or via SKILZ (once published):

```bash
npx skilz install SpillwaveSolutions/spillwave-ui-guard
```

## What the vendored install writes

| Path | Purpose |
|------|---------|
| `.spillwave/ui-guard/skills/` | Canonical copies of all skills |
| `wireframes/` | Directory + README for wireframes |
| `.claude/UI_GUARD.md` | Claude Code instructions |
| `.grok/plugins/spillwave-ui-guard/` | Grok Build plugin |
| `.grok/skills/` | Copies of the skills for Grok discovery |
| `.cursor/rules/ui-guard.mdc` | Cursor always-on rule |
| `AGENTS.md` (created or appended) | Cursor / Codex agent instructions |
| `hooks/pre-commit-ui-guard.sh` | Soft pre-commit reminder |
| `scripts/check-ui-guard.sh` | CI / local contract checker |
| `.github/workflows/ui-guard.yml` | GitHub Actions enforcement |

## Making the pre-commit check hard

```bash
export UI_GUARD_STRICT=1
```

To skip intentionally:

```bash
SKIP_UI_GUARD=1 git commit ...
```

## Host-specific notes

### Claude Code
- Native: marketplace add + plugin install (loads `skills/`, `agents/`, `commands/`).
- Vendored: skills under `.spillwave/ui-guard/skills/` plus `CLAUDE.md` / `.claude/UI_GUARD.md`.

### Grok Build
- Native: `.grok-plugin/marketplace.json` in this repo.
- Vendored: plugin at `.grok/plugins/spillwave-ui-guard/` and skills under `.grok/skills/`.

### Codex
- Native: `codex plugin marketplace add SpillwaveSolutions/spillwave-ui-guard`.
- Vendored: `AGENTS.md` carries the same contract.

### Cursor
- Native: team marketplace import or `~/.cursor/plugins/local/` symlink. Rule, skills, critic agent, and `/ui-wireframe` + `/ui-review` come from the plugin.
- Vendored: `.cursor/rules/ui-guard.mdc` + `AGENTS.md`.

### Agent Plugins 1.0.0
- Point any compatible client at this repository root (`plugin.json` + `skills/`).

## After install

1. Create initial wireframes for the main screens of the app.
2. Add a short note in the app's README pointing developers at the UI Guard workflow.
3. Keep CI on — `.github/workflows/ui-guard.yml` runs `scripts/check-ui-guard.sh`.
