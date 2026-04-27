#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: run_repo_phase.sh <phase> [repo_root]

Run a repo-local command from the nearest repo contract.

Supported phases:
  build
  proof
  deploy_dev
  verify_dev
EOF
}

if [[ $# -lt 1 ]]; then
  usage >&2
  exit 1
fi

phase="$1"
repo_root="${2:-$(pwd)}"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
resolver_path="${script_dir}/resolve_repo_contract.py"
detector_path="${script_dir}/detect_phase_command.py"

case "${phase}" in
  build|proof|deploy_dev|verify_dev)
    ;;
  *)
    echo "Unsupported phase: ${phase}" >&2
    usage >&2
    exit 1
    ;;
esac

if [[ ! -f "${resolver_path}" ]]; then
  echo "Missing contract resolver: ${resolver_path}" >&2
  exit 1
fi

contract_path="$("${resolver_path}" "${repo_root}")" || exit 1
repo_root="$(cd "$(dirname "${contract_path}")/.." && pwd)"

command="$(
  python3 - "${contract_path}" "${phase}" <<'PY'
import json
import sys

contract_path, phase = sys.argv[1], sys.argv[2]
with open(contract_path, "r", encoding="utf-8") as handle:
    data = json.load(handle)

value = data.get("commands", {}).get(phase, "")
if not isinstance(value, str) or not value.strip():
    raise SystemExit(1)

print(value.strip())
PY
)" || {
  echo "Phase command not found in ${contract_path}: ${phase}" >&2
  exit 1
}

if [[ "${command}" == "auto" ]]; then
  if [[ ! -f "${detector_path}" ]]; then
    echo "Missing phase command detector: ${detector_path}" >&2
    exit 1
  fi
  command="$(python3 "${detector_path}" "${repo_root}" "${phase}")"
fi

printf 'Running phase `%s` from %s\n' "${phase}" "${contract_path}"
printf 'Resolved command: %s\n' "${command}"
(
  cd "${repo_root}"
  eval "${command}"
)
