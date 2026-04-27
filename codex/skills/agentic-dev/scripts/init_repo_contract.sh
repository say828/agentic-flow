#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: init_repo_contract.sh [repo_root]

Create .agentic-dev/contract.json from the default template if it does not exist.
Also create runtime-friendly aliases:
  - .codex/agentic-dev.json
  - .claude/agentic-dev.json
Print the resulting canonical contract path.
EOF
}

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  usage
  exit 0
fi

repo_root="${1:-$(pwd)}"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
template_path="${script_dir}/../assets/repo-contract.template.json"
contract_dir="${repo_root}/.agentic-dev"
contract_path="${contract_dir}/contract.json"
codex_dir="${repo_root}/.codex"
claude_dir="${repo_root}/.claude"
codex_alias_path="${codex_dir}/agentic-dev.json"
claude_alias_path="${claude_dir}/agentic-dev.json"

if [[ ! -f "${template_path}" ]]; then
  echo "Template not found: ${template_path}" >&2
  exit 1
fi

mkdir -p "${contract_dir}"

if [[ ! -f "${contract_path}" ]]; then
  cp "${template_path}" "${contract_path}"
fi

python3 - "${contract_path}" "${repo_root}" <<'PY'
import json
import sys
from pathlib import Path

contract_path = Path(sys.argv[1])
repo_root = Path(sys.argv[2]).resolve()
data = json.loads(contract_path.read_text(encoding="utf-8"))

if data.get("name") in ("example-service", "", None):
    data["name"] = repo_root.name

commands = data.setdefault("commands", {})
placeholder_prefixes = (
    'echo "set build command"',
    'echo "set deterministic proof command"',
    'echo "set DEV deploy command',
    'echo "set DEV runtime verification command',
)
for phase in ("build", "proof", "deploy_dev", "verify_dev"):
    value = commands.get(phase)
    if not isinstance(value, str) or not value.strip() or value.strip().startswith(placeholder_prefixes):
        commands[phase] = "auto"

contract_path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
PY

mkdir -p "${codex_dir}" "${claude_dir}"
cat > "${codex_alias_path}" <<'EOF'
{
  "contract_path": "../.agentic-dev/contract.json"
}
EOF
cat > "${claude_alias_path}" <<'EOF'
{
  "contract_path": "../.agentic-dev/contract.json"
}
EOF

printf '%s\n' "${contract_path}"
