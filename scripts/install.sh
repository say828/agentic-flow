#!/usr/bin/env bash
set -euo pipefail

REPO_SLUG="say828/agentic-flow"
CODEX_SKILLS_DIR="${HOME}/.codex/skills"
MARKET_HOME="${HOME}/.local/share/agentic-flow"
MARKET_REPO_DIR="${MARKET_HOME}/repo"
TMP_ROOT=""
REPO_DIR=""

usage() {
  cat <<'EOF'
Usage:
  install.sh [--repo-dir PATH]

Installs Codex skills:
  - agentic-dev

Options:
  --repo-dir PATH  Use a local repository checkout instead of downloading one
  --codex-only     Accepted for compatibility; Codex skills are the only installer target
  --help           Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo-dir)
      REPO_DIR="${2:-}"
      shift 2
      ;;
    --codex-only)
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

cleanup() {
  if [[ -n "${TMP_ROOT}" && -d "${TMP_ROOT}" ]]; then
    rm -rf "${TMP_ROOT}"
  fi
}
trap cleanup EXIT

ensure_repo_checkout() {
  if [[ -n "${REPO_DIR}" ]]; then
    if [[ ! -d "${REPO_DIR}" ]]; then
      echo "Repository path not found: ${REPO_DIR}" >&2
      exit 1
    fi
    return
  fi

  TMP_ROOT="$(mktemp -d)"
  archive_url="https://github.com/${REPO_SLUG}/archive/refs/heads/main.tar.gz"
  archive_path="${TMP_ROOT}/repo.tar.gz"
  curl -fsSL -o "${archive_path}" "${archive_url}"
  tar -xzf "${archive_path}" -C "${TMP_ROOT}"
  REPO_DIR="$(find "${TMP_ROOT}" -maxdepth 1 -mindepth 1 -type d -name '*agentic-flow*' | head -n 1)"

  if [[ -z "${REPO_DIR}" || ! -d "${REPO_DIR}" ]]; then
    echo "Failed to prepare repository checkout for ${REPO_SLUG}" >&2
    exit 1
  fi
}

stage_market_repo() {
  local source_resolved target_resolved
  source_resolved="$(readlink -f "${REPO_DIR}" 2>/dev/null || printf '%s' "${REPO_DIR}")"
  target_resolved="$(readlink -f "${MARKET_REPO_DIR}" 2>/dev/null || printf '%s' "${MARKET_REPO_DIR}")"
  if [[ "${source_resolved}" == "${target_resolved}" ]]; then
    return
  fi
  mkdir -p "${MARKET_HOME}"
  rm -rf "${MARKET_REPO_DIR}"
  mkdir -p "${MARKET_REPO_DIR}"
  cp -R "${REPO_DIR}/." "${MARKET_REPO_DIR}/"
}

install_codex_skill() {
  local skill_name="$1"
  local source_dir="${REPO_DIR}/codex/skills/${skill_name}"
  local target_dir="${CODEX_SKILLS_DIR}/${skill_name}"

  if [[ ! -d "${source_dir}" ]]; then
    echo "Missing Codex skill directory: ${source_dir}" >&2
    exit 1
  fi

  mkdir -p "${CODEX_SKILLS_DIR}"
  rm -rf "${target_dir}"
  cp -R "${source_dir}" "${target_dir}"
}

main() {
  ensure_repo_checkout
  stage_market_repo

  echo "Installing Codex skills into ${CODEX_SKILLS_DIR}..."
  install_codex_skill "agentic-dev"

  echo
  echo "Installed Codex skills:"
  echo "  - agentic-dev"
  echo
  echo "Agentic Flow repo staged at:"
  echo "  ${MARKET_REPO_DIR}"
}

main "$@"
