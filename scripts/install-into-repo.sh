#!/usr/bin/env bash
# Install Spillwave UI Guard into a target repository.
# Usage: ./scripts/install-into-repo.sh /path/to/target-repo

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

# 1. Skills
mkdir -p "$TARGET/.spillwave/ui-guard/skills"
cp -R "$PLUGIN_ROOT/skills/"* "$TARGET/.spillwave/ui-guard/skills/"

# 2. Wireframe templates
mkdir -p "$TARGET/wireframes"
if [ ! -f "$TARGET/wireframes/README.md" ]; then
  cat > "$TARGET/wireframes/README.md" << 'EOF'
# Wireframes

This directory is required by Spillwave UI Guard.

- One folder per feature or major screen
- Use the skeleton from the ui-guard templates
- Keep acceptance criteria current — the adversarial reviewer treats them as the contract
EOF
fi

# 3. Claude Code adapter
mkdir -p "$TARGET/.claude"
cp "$PLUGIN_ROOT/adapters/claude-code/CLAUDE.md" "$TARGET/.claude/UI_GUARD.md"
if [ -f "$TARGET/CLAUDE.md" ]; then
  if ! grep -q "UI Guard" "$TARGET/CLAUDE.md" 2>/dev/null; then
    echo "" >> "$TARGET/CLAUDE.md"
    echo "## Spillwave UI Guard" >> "$TARGET/CLAUDE.md"
    echo "See \`.claude/UI_GUARD.md\` and the skills under \`.spillwave/ui-guard/skills/\`." >> "$TARGET/CLAUDE.md"
    echo "Wireframe-first + adversarial review is required for non-trivial UI work." >> "$TARGET/CLAUDE.md"
  fi
fi

# 4. Grok Build adapter
mkdir -p "$TARGET/.grok/plugins/spillwave-ui-guard"
cp "$PLUGIN_ROOT/adapters/grok-build/plugin.json" "$TARGET/.grok/plugins/spillwave-ui-guard/"
cp "$PLUGIN_ROOT/adapters/grok-build/GROK.md" "$TARGET/.grok/plugins/spillwave-ui-guard/"
mkdir -p "$TARGET/.grok/skills"
for skill in "$PLUGIN_ROOT/skills/"*; do
  name=$(basename "$skill")
  if [ ! -e "$TARGET/.grok/skills/$name" ]; then
    ln -s "$TARGET/.spillwave/ui-guard/skills/$name" "$TARGET/.grok/skills/$name" 2>/dev/null || \
      cp -R "$TARGET/.spillwave/ui-guard/skills/$name" "$TARGET/.grok/skills/$name"
  fi
done

# 5. Cursor / Codex adapter
mkdir -p "$TARGET/.cursor/rules"
cp "$PLUGIN_ROOT/adapters/cursor/rules/ui-guard.mdc" "$TARGET/.cursor/rules/"
if [ ! -f "$TARGET/AGENTS.md" ]; then
  cp "$PLUGIN_ROOT/adapters/cursor/AGENTS.md" "$TARGET/AGENTS.md"
else
  if ! grep -q "UI Guard" "$TARGET/AGENTS.md" 2>/dev/null; then
    echo "" >> "$TARGET/AGENTS.md"
    echo "## Spillwave UI Guard" >> "$TARGET/AGENTS.md"
    cat "$PLUGIN_ROOT/adapters/cursor/AGENTS.md" | sed '1,3d' >> "$TARGET/AGENTS.md"
  fi
fi

# 6. Pre-commit hook (optional, soft by default)
mkdir -p "$TARGET/hooks"
cp "$PLUGIN_ROOT/hooks/pre-commit-ui-guard.sh" "$TARGET/hooks/"
chmod +x "$TARGET/hooks/pre-commit-ui-guard.sh"

echo ""
echo "Installed."
echo ""
echo "Next steps for this repo:"
echo "  1. Review / create initial wireframes under wireframes/"
echo "  2. For Claude Code: skills are available via .spillwave/ui-guard/skills and .claude/UI_GUARD.md"
echo "  3. For Grok Build: plugin is under .grok/plugins/spillwave-ui-guard"
echo "  4. For Cursor: rule is under .cursor/rules/ui-guard.mdc and AGENTS.md updated"
echo "  5. Optionally wire hooks/pre-commit-ui-guard.sh into your pre-commit setup"
echo "  6. Set UI_GUARD_STRICT=1 if you want the pre-commit check to block instead of warn"
