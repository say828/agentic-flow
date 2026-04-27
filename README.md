# Agentic Flow

Claude Code와 Codex에서 같은 개발 프로세스를 쓰기 위한 최소 스토어입니다.

현재 유지하는 구성은 실제 agentic development 흐름에 쓰는 것만 남겼습니다.

- `agentic-dev`: GitHub Project/Issue, SDD planning/verification, repo contract, Discord webhook, proof/repair loop를 묶는 통합 개발 workflow

## Claude Code 설치

Marketplace를 추가합니다.

```bash
/plugin marketplace add say828/agentic-flow
```

플러그인을 설치합니다.

```bash
/plugin install agentic-dev@agentic-flow
```

## Codex 설치

Codex 전용 설치 스크립트는 `agentic-dev` skill만 설치합니다. SDD workflow는 `agentic-dev` 안에 통합되어 있습니다.

```bash
curl -fsSL https://raw.githubusercontent.com/say828/agentic-flow/main/scripts/install.sh | bash
```

설치 결과:

- `~/.codex/skills/agentic-dev`
- `~/.local/share/agentic-flow/repo`

## 첫 repo 초기화

처음 사용하는 repo에서는 `agentic-dev` 초기화 스크립트를 실행합니다.

```bash
~/.codex/skills/agentic-dev/scripts/init_agentic_dev.sh "task or product name" /path/to/repo --github --project-title "Agentic Dev"
```

Discord webhook 테스트까지 포함하려면:

```bash
export DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/..."
~/.codex/skills/agentic-dev/scripts/init_agentic_dev.sh "task or product name" /path/to/repo --github --project-title "Agentic Dev" --send-discord-test
```

생성되는 주요 파일:

- `.agentic-dev/onboarding.json`
- `.agentic-dev/contract.json`
- `.codex/agentic-dev.json`
- `.claude/agentic-dev.json`
- `.agentic-dev/discord.env.example`
- `sdd/01_planning/`
- `sdd/02_plan/`
- `sdd/03_verify/`
- `sdd/02_plan/canonical-targets/`

## Repo contract 실행

`agentic-dev`는 repo-local `.agentic-dev/contract.json`에 적힌 명령을 실행합니다.

```bash
~/.codex/skills/agentic-dev/scripts/run_repo_phase.sh build /path/to/repo
~/.codex/skills/agentic-dev/scripts/run_repo_phase.sh proof /path/to/repo
~/.codex/skills/agentic-dev/scripts/run_repo_phase.sh deploy_dev /path/to/repo
~/.codex/skills/agentic-dev/scripts/run_repo_phase.sh verify_dev /path/to/repo
```

## 남긴 경로

```text
.claude-plugin/marketplace.json
codex/skills/agentic-dev/
plugins/agentic-dev/
scripts/install.sh
docs/agentic-dev-plugin.md
LICENSE
README.md
```
