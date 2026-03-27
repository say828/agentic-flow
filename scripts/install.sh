#!/usr/bin/env bash
set -euo pipefail

REPO_SLUG="say828/say828-agent-market"
INSTALL_DIR="${HOME}/.local/bin"
CODEX_SKILLS_DIR="${HOME}/.codex/skills"
MARKET_HOME="${HOME}/.local/share/say828-agent-market"
MARKET_REPO_DIR="${MARKET_HOME}/repo"
TMP_ROOT=""
REPO_DIR=""

usage() {
  cat <<'EOF'
Usage:
  install.sh [--repo-dir PATH]

Installs:
  - Codex skills: planning-with-files, codex-hud, universal-agentic-dev
  - Codex interactive wrapper

Options:
  --repo-dir PATH  Use a local repository checkout instead of downloading one
  --help           Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo-dir)
      REPO_DIR="${2:-}"
      shift 2
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
  REPO_DIR="$(find "${TMP_ROOT}" -maxdepth 1 -mindepth 1 -type d -name '*agent-market*' | head -n 1)"

  if [[ -z "${REPO_DIR}" || ! -d "${REPO_DIR}" ]]; then
    echo "Failed to prepare repository checkout for ${REPO_SLUG}" >&2
    exit 1
  fi
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

install_codex_wrapper() {
  local wrapper_dir="${INSTALL_DIR}"
  local wrapper_target="${wrapper_dir}/codex"
  local wrapper_source="${MARKET_REPO_DIR}/codex/bin/codex"
  local inline_source="${MARKET_REPO_DIR}/codex/bin/codex-inline-tmux.sh"
  local hud_source="${MARKET_REPO_DIR}/codex/bin/codex-hud-pane.sh"
  local real_codex="${CODEX_REAL_BIN:-$(which -a codex | awk 'NR==1 {print; exit}')}"

  mkdir -p "${wrapper_dir}" "${MARKET_HOME}"
  rm -rf "${MARKET_REPO_DIR}"
  mkdir -p "${MARKET_REPO_DIR}"
  cp -R "${REPO_DIR}/." "${MARKET_REPO_DIR}/"
  chmod +x "${wrapper_source}" "${inline_source}" "${hud_source}"

  if [[ -e "${wrapper_target}" && ! -L "${wrapper_target}" ]]; then
    mv "${wrapper_target}" "${wrapper_target}.say828-agent-market-backup"
  elif [[ -L "${wrapper_target}" ]]; then
    rm -f "${wrapper_target}"
  fi

  ln -s "${wrapper_source}" "${wrapper_target}"

  if [[ -n "${real_codex}" ]]; then
    cat > "${MARKET_HOME}/codex.env" <<EOF
CODEX_REAL_BIN=${real_codex}
EOF
  fi
}

install_codex_skills() {
  ensure_repo_checkout
  echo "Installing Codex skills into ${CODEX_SKILLS_DIR}..."
  install_codex_skill "planning-with-files"
  install_codex_skill "codex-hud"
  install_codex_skill "universal-agentic-dev"
  install_codex_wrapper
  echo "Installed Codex skills: planning-with-files, codex-hud, universal-agentic-dev"
  echo "Installed Codex wrapper: ${INSTALL_DIR}/codex"
}

main() {
  install_codex_skills

  echo
  echo "=========================================="
  echo "  INSTALLATION COMPLETE!"
  echo "=========================================="
  echo
  echo "Installed Codex skills:"
  echo "  - planning-with-files"
  echo "  - codex-hud"
  echo "  - universal-agentic-dev"
  echo
  echo "Use them by name in Codex prompts after restart if needed."
  echo
}

main "$@"
