#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: bootstrap_spec_workspace.sh [repo_root]

Prepare minimal directories for agentic-dev:
  - sdd/01_planning
  - sdd/02_plan
  - sdd/02_plan/canonical-targets
  - sdd/03_verify
  - sdd/99_toolchain

Print the created or confirmed paths.
EOF
}

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  usage
  exit 0
fi

repo_root="${1:-$(pwd)}"

paths=(
  "${repo_root}/sdd/01_planning/01_feature"
  "${repo_root}/sdd/01_planning/02_screen"
  "${repo_root}/sdd/01_planning/03_architecture"
  "${repo_root}/sdd/01_planning/04_data"
  "${repo_root}/sdd/01_planning/05_api"
  "${repo_root}/sdd/01_planning/06_iac"
  "${repo_root}/sdd/01_planning/07_integration"
  "${repo_root}/sdd/01_planning/08_nonfunctional"
  "${repo_root}/sdd/01_planning/09_security"
  "${repo_root}/sdd/01_planning/10_test"
  "${repo_root}/sdd/02_plan/01_feature"
  "${repo_root}/sdd/02_plan/02_screen"
  "${repo_root}/sdd/02_plan/03_architecture"
  "${repo_root}/sdd/02_plan/06_iac"
  "${repo_root}/sdd/02_plan/10_test"
  "${repo_root}/sdd/02_plan/canonical-targets"
  "${repo_root}/sdd/03_verify/01_feature"
  "${repo_root}/sdd/03_verify/02_screen"
  "${repo_root}/sdd/03_verify/03_architecture"
  "${repo_root}/sdd/03_verify/06_iac"
  "${repo_root}/sdd/03_verify/10_test"
  "${repo_root}/sdd/99_toolchain"
)

for path in "${paths[@]}"; do
  mkdir -p "${path}"
  printf '%s\n' "${path}"
done
