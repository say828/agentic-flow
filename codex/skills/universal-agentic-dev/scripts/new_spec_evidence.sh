#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: new_spec_evidence.sh "title" [repo_root]

Create docs/evidence/<YYYY-MM-DD>-<slug>.md from assets/spec-evidence-template.md.
Print the created file path.
EOF
}

if [[ $# -lt 1 ]]; then
  usage >&2
  exit 1
fi

title="$1"
repo_root="${2:-$(pwd)}"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
template_path="${script_dir}/../assets/spec-evidence-template.md"

if [[ ! -f "$template_path" ]]; then
  echo "Template not found: $template_path" >&2
  exit 1
fi

slug="$(printf '%s' "$title" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//; s/-{2,}/-/g')"
if [[ -z "$slug" ]]; then
  slug="spec-evidence"
fi

today="$(date +%F)"
evidence_dir="${repo_root}/docs/evidence"
evidence_path="${evidence_dir}/${today}-${slug}.md"

mkdir -p "$evidence_dir"

if [[ -e "$evidence_path" ]]; then
  echo "Evidence file already exists: $evidence_path" >&2
  exit 1
fi

escaped_title="$(printf '%s' "$title" | sed 's/[\\/&]/\\&/g')"
escaped_date="$(printf '%s' "$today" | sed 's/[\\/&]/\\&/g')"

sed \
  -e "s/{{TITLE}}/${escaped_title}/g" \
  -e "s/{{DATE}}/${escaped_date}/g" \
  "$template_path" > "$evidence_path"

echo "$evidence_path"
