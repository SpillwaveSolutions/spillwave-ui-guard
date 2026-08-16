# Spillwave UI Guard

**Wireframe-first + adversarial sub-agent enforcement for UI development.**

This plugin forces a disciplined UI development workflow across Claude Code, Grok Build, and Cursor/Codex:

1. **Wireframe / spec first** — every meaningful UI change must start with (or update) a wireframe + specification.
2. **Adversarial review** — a separate critic agent spins up the app, checks the running UI against the wireframe and requirements, and must approve before the change is accepted.
3. **Enforcement in the build process** — hooks and skills make it hard to check in UI work that skips these steps.

## Supported Hosts

| Host            | Adapter location              | Install method                          |
|-----------------|-------------------------------|-----------------------------------------|
| Claude Code     | `adapters/claude-code/`       | Claude plugin or SKILZ                  |
| Grok Build      | `adapters/grok-build/`        | Grok plugin / `.grok/plugins/`          |
| Cursor / Codex  | `adapters/cursor/`            | `AGENTS.md` + `.cursor/rules/`          |

## Quick Install (per target repo)

```bash
# From this repo:
./scripts/install-into-repo.sh /path/to/your/ui-repo

# Or via SKILZ once registered:
npx skilz install SpillwaveSolutions/spillwave-ui-guard
```

See [docs/INSTALL.md](docs/INSTALL.md) for host-specific details.

## Core Skills

| Skill                        | Purpose                                              |
|------------------------------|------------------------------------------------------|
| `ui-require-wireframe`       | Forces wireframe + spec before any UI implementation |
| `ui-adversarial-reviewer`    | Critic agent that runs the app and judges the UI     |
| `ui-visual-regression`       | Playwright screenshot comparison against baselines   |
| `ui-accessibility-check`     | Basic a11y checks (roles, labels, contrast hints)    |
| `ui-standards`               | Shared standards for wireframes, specs, and reviews  |

## Recommended Workflow

```
1. Create / update wireframe in wireframes/
2. Update or create the corresponding .spec.md
3. Implement the UI change
4. Run adversarial review (auto-triggered by skill)
5. Only after PASS may the change be committed / PR'd
```

## Target Repos (Spillwave)

- `motion`
- `okf-forge`
- `forge-notes`
- `wiki_ticket_sdd_ui`
- `agent-brain-ui`
- `skill-db-viewer`

## License

MIT
