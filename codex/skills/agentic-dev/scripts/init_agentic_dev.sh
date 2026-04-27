#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  init_agentic_dev.sh "title" [repo_root] [options]

Bootstrap one repo into the Agentic Dev flow:
  - .agentic-dev contract and .codex/.claude aliases
  - sdd/01_planning, sdd/02_plan, sdd/03_verify, sdd/99_toolchain
  - optional GitHub Project and Issue
  - optional Discord webhook test notification

Options:
  --github                         Create or reuse a GitHub Project and create an issue
  --repo OWNER/REPO                GitHub repository for issue creation; defaults from origin
  --project-title TITLE            GitHub Project title; implies --github
  --issue-title TITLE              GitHub Issue title; implies --github
  --issue-label LABEL              Add one label to the issue; repeatable
  --discord-env-var NAME           Env var that contains the Discord webhook URL (default: DISCORD_WEBHOOK_URL)
  --send-discord-test              Send a Discord setup message when webhook env var is set
  --dry-run                        Write local files, but skip GitHub and Discord network calls
  --help                           Show this help
EOF
}

if [[ $# -lt 1 || "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  usage
  [[ $# -lt 1 ]] && exit 1 || exit 0
fi

title="$1"
shift
repo_root="${1:-$(pwd)}"
if [[ $# -gt 0 && "${1:-}" != --* ]]; then
  shift
fi

github_enabled=0
github_repo=""
project_title="Agentic Dev"
issue_title=""
discord_env_var="DISCORD_WEBHOOK_URL"
send_discord_test=0
dry_run=0
issue_labels=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --github)
      github_enabled=1
      shift
      ;;
    --repo)
      github_repo="${2:-}"
      github_enabled=1
      shift 2
      ;;
    --project-title)
      project_title="${2:-}"
      github_enabled=1
      shift 2
      ;;
    --issue-title)
      issue_title="${2:-}"
      github_enabled=1
      shift 2
      ;;
    --issue-label)
      issue_labels+=("${2:-}")
      shift 2
      ;;
    --discord-env-var)
      discord_env_var="${2:-}"
      shift 2
      ;;
    --send-discord-test)
      send_discord_test=1
      shift
      ;;
    --dry-run)
      dry_run=1
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

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
skill_dir="$(cd "${script_dir}/.." && pwd)"
repo_root="$(cd "${repo_root}" && pwd)"

slugify() {
  printf '%s' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//; s/-{2,}/-/g'
}

detect_repo_slug() {
  local remote
  remote="$(git -C "${repo_root}" remote get-url origin 2>/dev/null || true)"
  if [[ -z "${remote}" ]]; then
    return 1
  fi
  case "${remote}" in
    git@github.com:*)
      printf '%s\n' "${remote#git@github.com:}" | sed -E 's/\.git$//'
      ;;
    https://github.com/*)
      printf '%s\n' "${remote#https://github.com/}" | sed -E 's/\.git$//'
      ;;
    *)
      return 1
      ;;
  esac
}

render_template() {
  local template="$1"
  local output="$2"
  python3 - "$template" "$output" "$title" "${github_repo:-unknown}" "$sdd_plan_path" "$sdd_verify_path" <<'PY'
from pathlib import Path
import sys

template, output, title, repo, sdd_plan, sdd_verify = sys.argv[1:]
text = Path(template).read_text(encoding="utf-8")
for key, value in {
    "{{TITLE}}": title,
    "{{REPO}}": repo,
    "{{SDD_PLAN}}": sdd_plan,
    "{{SDD_VERIFY}}": sdd_verify,
}.items():
    text = text.replace(key, value)
Path(output).write_text(text, encoding="utf-8")
PY
}

write_onboarding_json() {
  local output="$1"
  local issue_url="${2:-}"
  local project_url="${3:-}"
  python3 - "$output" "$title" "${github_repo:-}" "$project_title" "$issue_url" "$project_url" "$discord_env_var" "$sdd_plan_path" "$sdd_verify_path" "${workflow_path:-}" "${evidence_path:-}" <<'PY'
from pathlib import Path
import json
import sys

(
    output,
    title,
    repo,
    project_title,
    issue_url,
    project_url,
    discord_env_var,
    sdd_plan,
    sdd_verify,
    workflow,
    evidence,
) = sys.argv[1:]

data = {
    "schema_version": 1,
    "title": title,
    "github": {
        "repo": repo,
        "project_title": project_title,
        "project_url": project_url,
        "issue_url": issue_url,
    },
    "sdd": {
        "plan": sdd_plan,
        "verify": sdd_verify,
    },
    "workflow": workflow,
    "evidence": evidence,
    "discord": {
        "webhook_env_var": discord_env_var,
        "env_example": ".agentic-dev/discord.env.example",
    },
}
Path(output).write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
PY
}

ensure_github_project() {
  local owner="$1"
  local title="$2"
  local existing
  existing="$(gh project list --owner "${owner}" --format json --limit 100 \
    | python3 -c '
import json
import sys

title = sys.argv[1]
data = json.load(sys.stdin)
for project in data.get("projects", []):
    if project.get("title") == title:
        print(f"{project.get('number')} {project.get('url')}")
        break
' "$title")"
  if [[ -n "${existing}" ]]; then
    printf '%s\n' "${existing}"
    return 0
  fi
  gh project create --owner "${owner}" --title "${title}" --format json \
    | python3 -c '
import json
import sys
data = json.load(sys.stdin)
print(f"{data.get('number')} {data.get('url')}")
'
}

create_github_issue() {
  local body_file="$1"
  local args=(issue create --repo "${github_repo}" --title "${issue_title}" --body-file "${body_file}")
  local label
  for label in "${issue_labels[@]}"; do
    [[ -n "${label}" ]] && args+=(--label "${label}")
  done
  if [[ -n "${project_title}" ]]; then
    args+=(--project "${project_title}")
  fi
  gh "${args[@]}"
}

send_discord() {
  local message="$1"
  local webhook="${!discord_env_var:-}"
  if [[ -z "${webhook}" ]]; then
    echo "Discord webhook env var not set: ${discord_env_var}" >&2
    return 0
  fi
  python3 - "$message" <<'PY' | curl -fsSL -H "Content-Type: application/json" -d @- "${webhook}" >/dev/null
import json
import sys
print(json.dumps({"content": sys.argv[1]}))
PY
}

slug="$(slugify "${title}")"
if [[ -z "${slug}" ]]; then
  slug="agentic-dev"
fi
issue_title="${issue_title:-Initialize agentic-dev: ${title}}"
github_repo="${github_repo:-$(detect_repo_slug || true)}"
sdd_plan_path="sdd/02_plan/01_feature/${slug}_todos.md"
sdd_verify_path="sdd/03_verify/01_feature/${slug}.md"
workflow_path="sdd/02_plan/01_feature/${slug}_workflow.md"
evidence_path="sdd/03_verify/01_feature/${slug}_evidence.md"

"${script_dir}/bootstrap_spec_workspace.sh" "${repo_root}" >/dev/null
contract_path="$("${script_dir}/init_repo_contract.sh" "${repo_root}")"
"${script_dir}/new_spec_workflow.sh" "${title}" "${repo_root}" >/dev/null 2>&1 || true
"${script_dir}/new_spec_evidence.sh" "${title}" "${repo_root}" >/dev/null 2>&1 || true

mkdir -p \
  "${repo_root}/sdd/01_planning/01_feature" \
  "${repo_root}/sdd/01_planning/02_screen" \
  "${repo_root}/sdd/01_planning/03_architecture" \
  "${repo_root}/sdd/01_planning/04_data" \
  "${repo_root}/sdd/01_planning/05_api" \
  "${repo_root}/sdd/01_planning/06_iac" \
  "${repo_root}/sdd/01_planning/07_integration" \
  "${repo_root}/sdd/01_planning/08_nonfunctional" \
  "${repo_root}/sdd/01_planning/09_security" \
  "${repo_root}/sdd/01_planning/10_test" \
  "${repo_root}/sdd/02_plan/01_feature" \
  "${repo_root}/sdd/02_plan/02_screen" \
  "${repo_root}/sdd/02_plan/03_architecture" \
  "${repo_root}/sdd/02_plan/06_iac" \
  "${repo_root}/sdd/02_plan/10_test" \
  "${repo_root}/sdd/03_verify/01_feature" \
  "${repo_root}/sdd/03_verify/02_screen" \
  "${repo_root}/sdd/03_verify/03_architecture" \
  "${repo_root}/sdd/03_verify/06_iac" \
  "${repo_root}/sdd/03_verify/10_test" \
  "${repo_root}/sdd/99_toolchain" \
  "${repo_root}/.agentic-dev"

if [[ ! -f "${repo_root}/${sdd_plan_path}" ]]; then
  cat > "${repo_root}/${sdd_plan_path}" <<EOF
# ${title}

## Scope

- Bootstrap this repository into the Agentic Dev flow.

## Acceptance

- [ ] GitHub project and issue are linked when GitHub setup is enabled.
- [ ] Agentic Dev contract exists at \`.agentic-dev/contract.json\`.
- [ ] SDD plan and verification records exist.
- [ ] Discord webhook setup is documented or tested when configured.

## Checklist

- [ ] Review existing repository delivery conventions.
- [ ] Confirm the auto-detected build/proof/deploy commands, or override \`.agentic-dev/contract.json\` when the repo needs explicit commands.
- [ ] Run the retained verification surface.
- [ ] Record evidence in \`${sdd_verify_path}\`.
EOF
fi

if [[ ! -f "${repo_root}/${sdd_verify_path}" ]]; then
  cat > "${repo_root}/${sdd_verify_path}" <<EOF
# ${title}

## Current Verification

- Status: pending
- Contract: \`.agentic-dev/contract.json\`
- SDD plan: \`${sdd_plan_path}\`

## Evidence

- Add command-level evidence here after running the retained gates.

## Residual Risk

- Pending until the repo-local build/proof/deploy commands are resolved and executed.
EOF
fi

cat > "${repo_root}/.agentic-dev/discord.env.example" <<EOF
# Do not commit real webhook secrets.
${discord_env_var}=https://discord.com/api/webhooks/...
EOF

issue_body="$(mktemp)"
render_template "${skill_dir}/assets/github-issue-template.md" "${issue_body}"

project_url=""
issue_url=""

if [[ "${github_enabled}" -eq 1 ]]; then
  if [[ "${dry_run}" -eq 1 ]]; then
    echo "DRY RUN: would ensure GitHub project '${project_title}' and create issue '${issue_title}' in ${github_repo:-<unknown>}"
  elif [[ -z "${github_repo}" ]]; then
    echo "GitHub repo not provided and could not be inferred from origin. Skipping GitHub setup." >&2
  elif ! command -v gh >/dev/null 2>&1; then
    echo "gh CLI not found. Skipping GitHub setup." >&2
  else
    owner="${github_repo%%/*}"
    project_info="$(ensure_github_project "${owner}" "${project_title}")"
    project_url="$(printf '%s' "${project_info}" | awk '{print $2}')"
    issue_url="$(create_github_issue "${issue_body}" | tail -n 1)"
  fi
fi

write_onboarding_json "${repo_root}/.agentic-dev/onboarding.json" "${issue_url}" "${project_url}"

if [[ "${send_discord_test}" -eq 1 ]]; then
  if [[ "${dry_run}" -eq 1 ]]; then
    echo "DRY RUN: would send Discord setup notification via ${discord_env_var}"
  else
    send_discord "Agentic Dev initialized for ${title}${issue_url:+ - ${issue_url}}"
  fi
fi

rm -f "${issue_body}"

cat <<EOF
Agentic Dev initialized.
contract=${contract_path}
sdd_plan=${repo_root}/${sdd_plan_path}
sdd_verify=${repo_root}/${sdd_verify_path}
onboarding=${repo_root}/.agentic-dev/onboarding.json
workflow=${workflow_path:-}
evidence=${evidence_path:-}
github_issue=${issue_url:-}
github_project=${project_url:-}
EOF
