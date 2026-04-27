# Agentic Flow

Codex, Claude, 그리고 앞으로 추가될 agent runtime 플러그인을 한곳에서 관리하는 중앙 마켓 레포입니다.

## 마켓플레이스 추가

```bash
/plugin marketplace add say828/agentic-flow
```

추가 후 Claude Code 플러그인 설치:

```bash
/plugin install ship@agentic-flow
/plugin install spec-orchestrator@agentic-flow
/plugin install autonomous-decision-loop@agentic-flow
/plugin install sdd@agentic-flow
```

## 방향

- Claude Code 플러그인 마켓
- Codex 런타임용 플러그인과 어댑터 허브
- 공통 agent workflow, UI, 패키지, 설치 스크립트를 함께 관리하는 모노레포

현재 이 레포는 Claude/Codex 공용 마켓이며, `autonomous-decision-loop` 같은 런타임 플러그인도 같은 레포에서 직접 설치/운영합니다.

## Codex 설치

Codex용 자산은 skill과 ADL runtime 형태로 제공합니다.

```bash
curl -fsSL https://raw.githubusercontent.com/say828/agentic-flow/main/scripts/install.sh | bash
```

기본 설치 결과:

- Codex skills 설치: `planning-with-files`, `agentic-dev`, `sdd`
- Codex ADL notify/wrapper 설치: `~/.local/bin/codex`, `~/.codex/config.toml`
- Claude용 marketplace 플러그인 설치 대상: `ship`, `spec-orchestrator`, `autonomous-decision-loop`, `sdd`
- 기본값은 tmux-backed Codex 실행이며, ADL runtime은 market 레퍼 내부 자산을 사용함

Codex skill 설치 위치:

- `~/.codex/skills/planning-with-files`
- `~/.codex/skills/agentic-dev`
- `~/.codex/skills/sdd`
- `~/.local/share/agentic-flow/repo`

Codex ADL 런타임 위치:

- `~/.local/share/agentic-flow/repo/autonomous-decision-loop`

## 현재 플러그인

| 플러그인 | 설명 |
|----------|------|
| **ship** | PR 분할 및 자동 생성 워크플로우 도구 |
| **spec-orchestrator** | 스펙 정제, 결정론 검증, AI 진단, 수리 루프를 Claude Code에서 사용하는 플러그인 |
| **planning-with-files** | Codex에서 작업 계획을 `docs/plans/` 파일로 유지하는 skill |
| **agentic-dev** | 스펙 정제, 결정론 검증, AI 진단, 수리 루프를 결합한 범용 개발 방법론 skill |
| **sdd** | SDD planning, implementation, verify를 강제하는 Claude/Codex 공용 개발 workflow |
| **autonomous-decision-loop** | Claude Stop hook + Codex notify/tmux 기반의 응답 조건부 자동 후속 실행 플러그인 |

---

## ship

PR 크기 기준 자동 분할과 순차 PR 생성을 자동화하는 Git 워크플로우 도구입니다.

### 주요 기능

- **대화형 분할 계획**: 변경사항 분석 -> PR 크기 기준(300줄)으로 분할
- **자동 PR 생성**: 태스크 ID 입력 -> 브랜치/커밋/PR 자동 생성
- **의존성 순서 보장**: 테스트/인프라 먼저, 구현체는 나중에

### 설치

```bash
/plugin install ship@agentic-flow
```

---

## spec-orchestrator

Claude Code에서 스펙 기반 정밀 개발을 수행하기 위한 플러그인입니다. 화면설계서, PRD, SDD, 계약 문서를 `canonical target`으로 정제한 뒤, 결정론적 검증과 AI 보조 분석을 하나의 루프로 묶습니다.

### 설치

```bash
/plugin install spec-orchestrator@agentic-flow
```

### 명령어

| 명령어 | 설명 |
|--------|------|
| `spec-orchestrator:plan` | canonical target, fixture, route, viewport, DEV 검증 루프를 포함한 실행 계획 수립 |
| `spec-orchestrator:verify` | strict proof gate 실행 후 실패 원인을 구조적으로 분류 |
| `spec-orchestrator:repair` | verify 결과를 바탕으로 수정 우선순위와 재검증 루프를 진행 |

### Codex 연계

- Codex에서는 `agentic-dev` skill을 사용한다.
- 새 작업을 시작할 때는 아래 스캐폴드를 사용할 수 있다.

```bash
~/.codex/skills/agentic-dev/scripts/bootstrap_spec_workspace.sh /path/to/repo
~/.codex/skills/agentic-dev/scripts/init_repo_contract.sh /path/to/repo
~/.codex/skills/agentic-dev/scripts/new_spec_workflow.sh "feature name" /path/to/repo
~/.codex/skills/agentic-dev/scripts/new_spec_evidence.sh "feature name" /path/to/repo
```

자세한 아키텍처는 [docs/agentic-dev-plugin.md](docs/agentic-dev-plugin.md)를 따른다.

## agentic-dev

Codex에서 스펙 기반 정밀 개발을 수행하는 기본 skill입니다. 설치 후 바로 아래 순서로 사용할 수 있습니다.

```bash
~/.codex/skills/agentic-dev/scripts/bootstrap_spec_workspace.sh /path/to/repo
~/.codex/skills/agentic-dev/scripts/init_repo_contract.sh /path/to/repo
~/.codex/skills/agentic-dev/scripts/new_spec_workflow.sh "feature name" /path/to/repo
~/.codex/skills/agentic-dev/scripts/new_spec_evidence.sh "feature name" /path/to/repo
```

생성 결과:

- `.agentic-dev/contract.json`
- `.codex/agentic-dev.json`
- `.claude/agentic-dev.json`
- `docs/plans/<date>-<slug>.md`
- `docs/evidence/<date>-<slug>.md`
- `docs/canonical-targets/`

Codex는 이 구조를 기준으로 `canonical target 정의 -> 구현 -> deterministic proof -> DEV 검증 -> repair loop`를 반복한다.

repo-local command 실행:

```bash
~/.codex/skills/agentic-dev/scripts/run_repo_phase.sh build /path/to/repo
~/.codex/skills/agentic-dev/scripts/run_repo_phase.sh proof /path/to/repo
~/.codex/skills/agentic-dev/scripts/run_repo_phase.sh deploy_dev /path/to/repo
~/.codex/skills/agentic-dev/scripts/run_repo_phase.sh verify_dev /path/to/repo
~/.codex/skills/agentic-dev/scripts/analyze_proof_results.py /path/to/proof-results.json
```

`run_repo_phase.sh`는 현재 디렉터리에서 위로 올라가며 `.codex/agentic-dev.json`, `.claude/agentic-dev.json`, `.agentic-dev/contract.json` 순서로 가장 가까운 contract를 찾는다.

이 설계는 `palcar`처럼 repo 안에 strict proof 체인이 이미 있는 서비스에도 그대로 적용할 수 있고, 다른 서비스에서는 repo-local contract만 채우면 된다.

---

## sdd

SDD를 개발 전체 프로세스의 canonical delivery record로 사용하는 workflow입니다.

Claude Code:

```bash
/plugin install sdd@agentic-flow
```

Codex:

```bash
~/.codex/skills/sdd
```

패키지 구조는 기존 SDD skill과 동일합니다.

- `codex/skills/sdd/SKILL.md`
- `codex/skills/sdd/references/section-map.md`
- `codex/skills/sdd/agents/openai.yaml`
- `plugins/sdd/skill/SKILL.md`

---

## planning-with-files

Codex가 다단계 작업을 `docs/plans/*.md` 파일에 기록하며 진행하도록 하는 skill입니다.

주요 파일:

- `codex/skills/planning-with-files/SKILL.md`
- `codex/skills/planning-with-files/scripts/new_plan.sh`

기본 사용:

```bash
~/.codex/skills/planning-with-files/scripts/new_plan.sh "feature name" /path/to/repo
```

---

## autonomous-decision-loop

Codex는 `notify + tmux` 경로로, Claude는 `Stop` hook 경로로 같은 ADL 엔진을 사용합니다.

주요 파일:

- `autonomous-decision-loop/src/adl/*`
- `autonomous-decision-loop/runtime/codex_notify.py`
- `plugins/autonomous-decision-loop/`
- `scripts/install_adl.py`

기본 설치:

```bash
curl -fsSL https://raw.githubusercontent.com/say828/agentic-flow/main/scripts/install.sh | bash
```
