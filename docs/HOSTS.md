# Host install matrix

Spillwave UI Guard is one plugin. Skills live in `skills/`. Each host reads its own manifest and marketplace catalog.

| Host | Marketplace file | Plugin manifest | Skills | Rules | Agents | Commands | Hooks |
|------|------------------|-----------------|--------|-------|--------|----------|-------|
| Agent Plugins 1.0.0 | — (filesystem plugin) | `plugin.json` | `skills/` | — | — | — | client extension dirs |
| Claude Code | `.claude-plugin/marketplace.json` | `.claude-plugin/plugin.json` | yes | — | yes | yes | `hooks/hooks.json` |
| Codex | `.agents/plugins/marketplace.json` | `.codex-plugin/plugin.json` | yes | — | — | — | `hooks/hooks.json` |
| Cursor | `.cursor-plugin/marketplace.json` | `.cursor-plugin/plugin.json` | yes | `rules/` | yes | yes | `hooks/hooks.json` |
| Grok Build | `.grok-plugin/marketplace.json` | `.grok-plugin/plugin.json` | yes | — | yes | yes | yes |

## Agent Plugins 1.0.0

Universal packaging standard ([agent-plugins.org](https://agent-plugins.org/specification)). Any compatible client (Cursor Agent Plugins, Codex/ChatGPT, Google Agents CLI, Copilot, VS Code) can load this directory.

```text
plugin.json          required UPS 1.0.0 manifest
skills/<name>/SKILL.md
```

There is no marketplace in the spec. Point the client at this repository root.

## Claude Code

```text
/plugin marketplace add SpillwaveSolutions/spillwave-ui-guard
/plugin install spillwave-ui-guard@spillwave-ui-guard
```

Local development:

```bash
claude --plugin-dir /path/to/spillwave-ui-guard
```

## Codex

```bash
codex plugin marketplace add SpillwaveSolutions/spillwave-ui-guard
codex plugin marketplace add SpillwaveSolutions/spillwave-ui-guard --ref main
```

The catalog is `.agents/plugins/marketplace.json` and points at the repo root (this directory is the plugin). The plugin manifest is `.codex-plugin/plugin.json`.

## Cursor

**Team marketplace (Teams / Enterprise):** Dashboard → Plugins → import GitHub repository `SpillwaveSolutions/spillwave-ui-guard`. Cursor reads `.cursor-plugin/marketplace.json`.

**Local:**

```bash
mkdir -p ~/.cursor/plugins/local
ln -s /path/to/spillwave-ui-guard ~/.cursor/plugins/local/spillwave-ui-guard
```

Then **Developer: Reload Window**.

The always-on rule is `rules/ui-guard.mdc`. Slash commands: `/ui-wireframe`, `/ui-review`.

## Grok Build

Add this repository as a marketplace source (`.grok-plugin/marketplace.json`), then install `spillwave-ui-guard` from the Marketplace tab (`/plugins`).

Vendored fallback (copies skills + adapter into an app repo):

```bash
./scripts/install-into-repo.sh /path/to/your-ui-repo
```

That writes `.grok/plugins/spillwave-ui-guard/` and `.grok/skills/`.

## Vendoring vs marketplace

| Path | When to use |
|------|-------------|
| Marketplace / plugin install | You want the host to discover skills, rules, agents, and commands natively |
| `./scripts/install-into-repo.sh` | You want wireframes, CI, and host instruction files copied into an app repo |

Both can be used together. Marketplace install does not create `wireframes/` or the CI workflow — run the install script (or copy those pieces) in each UI app.
