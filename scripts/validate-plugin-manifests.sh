#!/usr/bin/env bash
# Validate host manifests so this repo stays installable as:
#   Agent Plugins 1.0.0, Claude Code, Codex, Cursor, Grok Build
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() { echo "FAIL: $*"; exit 1; }
ok() { echo "OK    $*"; }

need_file() {
  [ -f "$1" ] || fail "missing file: $1"
  ok "$1"
}

need_dir() {
  [ -d "$1" ] || fail "missing dir: $1"
}

parse_json() {
  python3 - "$1" <<'PY'
import json, sys
path = sys.argv[1]
with open(path, encoding="utf-8") as f:
    json.load(f)
PY
}

need_json_fields() {
  local file="$1"
  shift
  python3 - "$file" "$@" <<'PY'
import json, sys
path, *fields = sys.argv[1:]
with open(path, encoding="utf-8") as f:
    data = json.load(f)
missing = [k for k in fields if k not in data or data[k] in (None, "")]
if missing:
    raise SystemExit(f"{path} missing fields: {', '.join(missing)}")
PY
}

echo "Validating Spillwave UI Guard plugin manifests"
echo "root: $ROOT"
echo ""

# --- required files ---------------------------------------------------------
need_file "plugin.json"
need_file ".claude-plugin/plugin.json"
need_file ".claude-plugin/marketplace.json"
need_file ".codex-plugin/plugin.json"
need_file ".agents/plugins/marketplace.json"
need_file ".cursor-plugin/plugin.json"
need_file ".cursor-plugin/marketplace.json"
need_file ".grok-plugin/plugin.json"
need_file ".grok-plugin/marketplace.json"
need_file "hooks/hooks.json"
need_file "rules/ui-guard.mdc"
need_file "agents/ui-adversarial-reviewer.md"
need_file "commands/ui-wireframe.md"
need_file "commands/ui-review.md"

# --- skills -----------------------------------------------------------------
SKILLS=(
  ui-standards
  ui-require-wireframe
  ui-adversarial-reviewer
  ui-visual-regression
  ui-accessibility-check
)
for s in "${SKILLS[@]}"; do
  need_file "skills/$s/SKILL.md"
done

# --- JSON parse + required fields -------------------------------------------
for f in \
  plugin.json \
  .claude-plugin/plugin.json \
  .claude-plugin/marketplace.json \
  .codex-plugin/plugin.json \
  .agents/plugins/marketplace.json \
  .cursor-plugin/plugin.json \
  .cursor-plugin/marketplace.json \
  .grok-plugin/plugin.json \
  .grok-plugin/marketplace.json \
  hooks/hooks.json
do
  parse_json "$f" || fail "invalid JSON: $f"
  ok "json $f"
done

need_json_fields plugin.json '$schema' name version description
need_json_fields .claude-plugin/plugin.json name version description
need_json_fields .claude-plugin/marketplace.json name owner plugins
need_json_fields .codex-plugin/plugin.json name version description skills
need_json_fields .agents/plugins/marketplace.json name plugins
need_json_fields .cursor-plugin/plugin.json name version description skills rules
need_json_fields .cursor-plugin/marketplace.json name owner plugins
need_json_fields .grok-plugin/plugin.json name version description
need_json_fields .grok-plugin/marketplace.json name owner plugins

python3 - <<'PY'
import json, sys
from pathlib import Path

root = Path(".")

ups = json.loads(Path("plugin.json").read_text())
if ups["$schema"] != "https://agent-plugins.org/schemas/1.0.0/plugin.schema.json":
    raise SystemExit("plugin.json $schema must be Agent Plugins 1.0.0")
if ups["name"] != "spillwave-ui-guard":
    raise SystemExit(f"plugin.json name mismatch: {ups['name']}")

# Closed UPS schema — reject unknown top-level keys
allowed = {
    "$schema", "name", "version", "description", "author",
    "homepage", "repository", "license", "keywords", "extensions",
}
unknown = set(ups) - allowed
if unknown:
    raise SystemExit(f"plugin.json has non-UPS fields: {sorted(unknown)}")

def first_plugin(path):
    data = json.loads(Path(path).read_text())
    plugins = data["plugins"]
    if not plugins:
        raise SystemExit(f"{path} has empty plugins[]")
    return data, plugins[0]

_, claude = first_plugin(".claude-plugin/marketplace.json")
_, cursor = first_plugin(".cursor-plugin/marketplace.json")
_, grok = first_plugin(".grok-plugin/marketplace.json")
_, codex = first_plugin(".agents/plugins/marketplace.json")

for label, entry, source in [
    ("claude", claude, claude.get("source")),
    ("cursor", cursor, cursor.get("source")),
]:
    if source not in ("./", ".", "./."):
        raise SystemExit(f"{label} marketplace source should be ./ (got {source!r})")

codex_src = codex.get("source") or {}
if not (isinstance(codex_src, dict) and codex_src.get("path") in ("./", ".")):
    raise SystemExit(f"codex marketplace source.path should be ./ (got {codex_src!r})")

grok_src = grok.get("source") or {}
if not (isinstance(grok_src, dict) and grok_src.get("path") in ("./", ".")):
    raise SystemExit(f"grok marketplace source.path should be ./ (got {grok_src!r})")

# Cursor / Codex skill paths must exist
cursor_plugin = json.loads(Path(".cursor-plugin/plugin.json").read_text())
codex_plugin = json.loads(Path(".codex-plugin/plugin.json").read_text())
for label, plugin in (("cursor", cursor_plugin), ("codex", codex_plugin)):
    skills = plugin.get("skills")
    if isinstance(skills, str):
        p = Path(skills)
        if not p.exists():
            raise SystemExit(f"{label} skills path missing: {skills}")

print("OK    schema + marketplace sources")
PY

echo ""
echo "All plugin manifests valid."
