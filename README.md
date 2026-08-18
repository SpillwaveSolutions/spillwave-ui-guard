# Spillwave UI Guard

**Wireframe-first + adversarial sub-agent enforcement for UI development.**

This plugin forces a disciplined UI development workflow across Claude Code, Grok Build, Codex, Cursor, and any Agent Plugins 1.0.0 client:

1. **Wireframe / spec first** — every meaningful UI change must start with (or update) a wireframe + specification.
2. **Adversarial review** — a separate critic agent spins up the app, checks the running UI against the wireframe and requirements, and must approve before the change is accepted.
3. **Enforcement in the build process** — hooks and skills make it hard to check in UI work that skips these steps.

## Supported hosts

This repo is a **single plugin** with native manifests for every major agent host. Skills live once under [`skills/`](skills/).

| Host | Native install | Manifest |
|------|----------------|----------|
| **Agent Plugins 1.0.0** (Google / Cursor / OpenAI / Microsoft / Amazon / Vercel) | drop the repo in as a plugin directory | [`plugin.json`](plugin.json) |
| **Claude Code** | `/plugin marketplace add SpillwaveSolutions/spillwave-ui-guard` then `/plugin install spillwave-ui-guard@spillwave-ui-guard` | [`.claude-plugin/`](.claude-plugin/) |
| **Codex** | `codex plugin marketplace add SpillwaveSolutions/spillwave-ui-guard` | [`.codex-plugin/plugin.json`](.codex-plugin/plugin.json) + [`.agents/plugins/marketplace.json`](.agents/plugins/marketplace.json) |
| **Cursor** | Team marketplace → import this GitHub repo, or symlink to `~/.cursor/plugins/local/spillwave-ui-guard` | [`.cursor-plugin/`](.cursor-plugin/) |
| **Grok Build** | add this repo as a marketplace source, or vendor via the install script | [`.grok-plugin/`](.grok-plugin/) |

See [docs/HOSTS.md](docs/HOSTS.md) for exact commands and [docs/INSTALL.md](docs/INSTALL.md) for vendoring into an app repo.

## Quick install

**As a marketplace plugin (preferred):**

```bash
# Claude Code
/plugin marketplace add SpillwaveSolutions/spillwave-ui-guard
/plugin install spillwave-ui-guard@spillwave-ui-guard

# Codex
codex plugin marketplace add SpillwaveSolutions/spillwave-ui-guard

# Cursor — Dashboard → Plugins → import GitHub repo
#   SpillwaveSolutions/spillwave-ui-guard
# or locally:
ln -s "$(pwd)" ~/.cursor/plugins/local/spillwave-ui-guard

# Grok Build — add this repo as a marketplace source, then install spillwave-ui-guard
```

**Vendored into a target UI repo:**

```bash
./scripts/install-into-repo.sh /path/to/your-ui-repo

# Or via SKILZ once registered:
npx skilz install SpillwaveSolutions/spillwave-ui-guard
```

## Core skills

| Skill                        | Purpose                                              |
|------------------------------|------------------------------------------------------|
| `ui-require-wireframe`       | Forces wireframe + spec before any UI implementation |
| `ui-adversarial-reviewer`    | Critic agent that runs the app and judges the UI     |
| `ui-visual-regression`       | Playwright screenshot comparison against baselines   |
| `ui-accessibility-check`     | Basic a11y checks (roles, labels, contrast hints)    |
| `ui-standards`               | Shared standards for wireframes, specs, and reviews  |

Host extras (same contract, host-native surfaces):

- Cursor always-on rule: [`rules/ui-guard.mdc`](rules/ui-guard.mdc)
- Critic agent: [`agents/ui-adversarial-reviewer.md`](agents/ui-adversarial-reviewer.md)
- Slash commands: `/ui-wireframe`, `/ui-review`

## CI / hooks

`scripts/check-ui-guard.sh` (run by `.github/workflows/ui-guard.yml`) **fails** when:

- The repo has UI source but `wireframes/` is missing or only has the template
- A contract file has no Goal/Screen heading or no Acceptance criteria
- UI source changes land without a `wireframes/` update

Escape hatch: `[skip-ui-guard]` in the commit or PR title.

The pre-commit hook is a reminder (set `UI_GUARD_STRICT=1` to block). CI never falls back to that hook — it always runs the checker script.

Manifests are validated by `scripts/validate-plugin-manifests.sh` (CI: `.github/workflows/plugin-manifests.yml`).

First contract review: [docs/AS-BUILT-REVIEW.md](docs/AS-BUILT-REVIEW.md).

## Recommended workflow

```
1. Create / update wireframe in wireframes/     (/ui-wireframe)
2. Update or create the corresponding .spec.md
3. Implement the UI change
4. Run adversarial review                       (/ui-review)
5. Only after PASS may the change be committed / PR'd
```

## Target repos (Spillwave)

- `motion`
- `okf-forge`
- `forge-notes`
- `wiki_ticket_sdd_ui`
- `agent-brain-ui`
- `skill-db-viewer`

## License

MIT
