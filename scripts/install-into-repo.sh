#!/usr/bin/env bash
# Install Spillwave UI Guard into a target repository (vendored copy).
# Usage: ./scripts/install-into-repo.sh /path/to/target-repo
#
# This copies skills, wireframe templates, host instruction files, hooks, and CI.
# For native marketplace install (Claude / Codex / Cursor / Grok), see docs/HOSTS.md.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET="${1:-}"

if [ -z "$TARGET" ] || [ ! -d "$TARGET" ]; then
  echo "Usage: $0 /path/to/target-repo"
  exit 1
fi

TARGET="$(cd "$TARGET" && pwd)"
echo "Installing Spillwave UI Guard into: $TARGET"
echo "Plugin root: $PLUGIN_ROOT"

# 1. Skills (canonical copy + Grok discovery copies)
mkdir -p "$TARGET/.spillwave/ui-guard/skills"
cp -R "$PLUGIN_ROOT/skills/"* "$TARGET/.spillwave/ui-guard/skills/"

mkdir -p "$TARGET/.grok/skills"
for skill in "$PLUGIN_ROOT/skills/"*; do
  name=$(basename "$skill")
  rm -rf "$TARGET/.grok/skills/$name"
  cp -R "$TARGET/.spillwave/ui-guard/skills/$name" "$TARGET/.grok/skills/$name"
done

# 2. Wireframe templates
mkdir -p "$TARGET/wireframes"
if [ ! -f "$TARGET/wireframes/README.md" ]; then
  cat > "$TARGET/wireframes/README.md" << 'EOF'
# Wireframes

This directory is required by Spillwave UI Guard.

- One folder per feature or major screen
- Use `_template.md` as the skeleton
- Keep acceptance criteria current — the adversarial reviewer treats them as the contract
- Source plugin: https://github.com/SpillwaveSolutions/spillwave-ui-guard
EOF
fi
cp "$PLUGIN_ROOT/templates/wireframes/screen-skeleton.md" "$TARGET/wireframes/_template.md"
mkdir -p "$TARGET/docs/specs"
if [ ! -f "$TARGET/docs/specs/README.md" ]; then
  cp "$PLUGIN_ROOT/templates/specs/feature-spec.md" "$TARGET/docs/specs/_template.md"
fi

# 3. Claude Code adapter
mkdir -p "$TARGET/.claude"
cp "$PLUGIN_ROOT/adapters/claude-code/CLAUDE.md" "$TARGET/.claude/UI_GUARD.md"
if [ -f "$TARGET/CLAUDE.md" ]; then
  if ! grep -q "UI Guard" "$TARGET/CLAUDE.md" 2>/dev/null; then
    {
      echo ""
      echo "## Spillwave UI Guard"
      echo "See \`.claude/UI_GUARD.md\` and the skills under \`.spillwave/ui-guard/skills/\`."
      echo "Wireframe-first + adversarial review is required for non-trivial UI work."
      echo "Plugin: https://github.com/SpillwaveSolutions/spillwave-ui-guard"
    } >> "$TARGET/CLAUDE.md"
  fi
else
  cp "$PLUGIN_ROOT/adapters/claude-code/CLAUDE.md" "$TARGET/CLAUDE.md"
fi

# 4. Grok Build adapter
mkdir -p "$TARGET/.grok/plugins/spillwave-ui-guard"
cp "$PLUGIN_ROOT/adapters/grok-build/plugin.json" "$TARGET/.grok/plugins/spillwave-ui-guard/"
cp "$PLUGIN_ROOT/adapters/grok-build/GROK.md" "$TARGET/.grok/plugins/spillwave-ui-guard/"

# 5. Cursor adapter (always-on rule)
mkdir -p "$TARGET/.cursor/rules"
if [ -f "$PLUGIN_ROOT/rules/ui-guard.mdc" ]; then
  cp "$PLUGIN_ROOT/rules/ui-guard.mdc" "$TARGET/.cursor/rules/"
else
  cp "$PLUGIN_ROOT/adapters/cursor/rules/ui-guard.mdc" "$TARGET/.cursor/rules/"
fi

# 6. Cursor / Codex AGENTS.md
if [ ! -f "$TARGET/AGENTS.md" ]; then
  cp "$PLUGIN_ROOT/adapters/cursor/AGENTS.md" "$TARGET/AGENTS.md"
else
  if ! grep -q "UI Guard" "$TARGET/AGENTS.md" 2>/dev/null; then
    {
      echo ""
      echo "## Spillwave UI Guard"
      sed '1,3d' "$PLUGIN_ROOT/adapters/cursor/AGENTS.md"
    } >> "$TARGET/AGENTS.md"
  fi
fi

# 7. Codex project hint (AGENTS.md is the portable contract)
mkdir -p "$TARGET/.codex"
if [ ! -f "$TARGET/.codex/UI_GUARD.md" ]; then
  cp "$PLUGIN_ROOT/adapters/cursor/AGENTS.md" "$TARGET/.codex/UI_GUARD.md"
fi

# 8. Hooks + CI checker
mkdir -p "$TARGET/hooks" "$TARGET/scripts"
cp "$PLUGIN_ROOT/hooks/pre-commit-ui-guard.sh" "$TARGET/hooks/"
chmod +x "$TARGET/hooks/pre-commit-ui-guard.sh"
cp "$PLUGIN_ROOT/scripts/check-ui-guard.sh" "$TARGET/scripts/check-ui-guard.sh"
chmod +x "$TARGET/scripts/check-ui-guard.sh"

# 9. GitHub Actions workflow (CI enforcement)
mkdir -p "$TARGET/.github/workflows"
cp "$PLUGIN_ROOT/.github/workflows/ui-guard.yml" "$TARGET/.github/workflows/ui-guard.yml"

echo ""
echo "Installed (vendored)."
echo ""
echo "Native marketplace install is also available:"
echo "  Claude:  /plugin marketplace add SpillwaveSolutions/spillwave-ui-guard"
echo "  Codex:   codex plugin marketplace add SpillwaveSolutions/spillwave-ui-guard"
echo "  Cursor:  import SpillwaveSolutions/spillwave-ui-guard as a team marketplace"
echo "  Grok:    add this repo as a marketplace source"
echo ""
echo "Next steps for this repo:"
echo "  1. Review / create initial wireframes under wireframes/"
echo "  2. Claude Code: .claude/UI_GUARD.md + .spillwave/ui-guard/skills"
echo "  3. Grok Build: .grok/plugins/spillwave-ui-guard + .grok/skills"
echo "  4. Cursor: .cursor/rules/ui-guard.mdc and AGENTS.md"
echo "  5. Codex: AGENTS.md + .codex/UI_GUARD.md"
echo "  6. CI: .github/workflows/ui-guard.yml runs scripts/check-ui-guard.sh"
echo "  7. Soft pre-commit: hooks/pre-commit-ui-guard.sh (UI_GUARD_STRICT=1 to block)"
