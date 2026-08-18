# Adapters

Host-native manifests live at the **repository root**:

| Host | Root files |
|------|------------|
| Agent Plugins 1.0.0 | `plugin.json` |
| Claude Code | `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json` |
| Codex | `.codex-plugin/plugin.json`, `.agents/plugins/marketplace.json` |
| Cursor | `.cursor-plugin/plugin.json`, `.cursor-plugin/marketplace.json` |
| Grok Build | `.grok-plugin/plugin.json`, `.grok-plugin/marketplace.json` |

This `adapters/` tree is what `scripts/install-into-repo.sh` vendors into an **app** repository (instruction files + Cursor rule). Skills are never forked per host — they stay in `/skills`.
