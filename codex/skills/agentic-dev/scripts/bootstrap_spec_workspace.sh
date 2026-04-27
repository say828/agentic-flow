#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: bootstrap_spec_workspace.sh [repo_root]

Prepare minimal directories for agentic-dev:
  - docs/plans
  - docs/evidence
  - docs/canonical-targets

Print the created or confirmed paths.
EOF
}

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  usage
  exit 0
fi

repo_root="${1:-$(pwd)}"

paths=(
  "${repo_root}/docs/plans"
  "${repo_root}/docs/evidence"
  "${repo_root}/docs/canonical-targets"
)

for path in "${paths[@]}"; do
  mkdir -p "${path}"
  printf '%s\n' "${path}"
done
