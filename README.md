# say828 Agent Market

Codex, Claude, 그리고 앞으로 추가될 agent runtime 플러그인을 한곳에서 관리하는 중앙 마켓 레포입니다.

## 마켓플레이스 추가

```bash
/plugin marketplace add say828/say828-agent-market
```

추가 후 Claude Code 플러그인 설치:

```bash
/plugin install ship@say828-agent-market

# spec-orchestrator 설치
/plugin install spec-orchestrator@say828-agent-market
```

## 방향

- Claude Code 플러그인 마켓
- Codex 런타임용 플러그인과 어댑터 허브
- 공통 agent workflow, UI, 패키지, 설치 스크립트를 함께 관리하는 모노레포

현재 이 레포는 Claude marketplace 인터페이스를 제공하고 있으며, Codex와 기타 agent runtime 플러그인도 같은 레포에서 계속 추가할 수 있도록 운영합니다.

## Codex 설치

Codex용 자산은 현재 skill 형태로 제공합니다.

```bash
curl -fsSL https://raw.githubusercontent.com/say828/say828-agent-market/main/scripts/install.sh | bash
```

기본 설치 결과:

- Codex skills 설치: `planning-with-files`, `codex-hud`, `universal-agentic-dev`
- Codex interactive wrapper 설치: `~/.local/bin/codex`
- 기본값은 일반 Codex 실행이며, HUD pane 자동 부착은 꺼져 있음

선택 설치:

```bash
curl -fsSL https://raw.githubusercontent.com/say828/say828-agent-market/main/scripts/install.sh | bash
```

Codex skill 설치 위치:

- `~/.codex/skills/planning-with-files`
- `~/.codex/skills/codex-hud`
- `~/.local/share/say828-agent-market/repo`

Codex TUI와 HUD 정책:

- `codex-hud`는 스킬 또는 스크립트로 수동 실행한다
- interactive `codex` wrapper는 tmux 세션을 열더라도 추가 HUD pane을 자동 생성하지 않는다
- 사용자가 보는 Codex 채팅 흐름을 가리지 않는 것이 기본 정책이다

## 현재 플러그인

| 플러그인 | 설명 |
|----------|------|
| **ship** | PR 분할 및 자동 생성 워크플로우 도구 |
| **spec-orchestrator** | 스펙 정제, 결정론 검증, AI 진단, 수리 루프를 Claude Code에서 사용하는 플러그인 |
| **planning-with-files** | Codex에서 작업 계획을 `docs/plans/` 파일로 유지하는 skill |
| **codex-hud** | Codex 실행 상태와 최근 로그를 HUD 스냅샷으로 보여주는 skill |
| **universal-agentic-dev** | 스펙 정제, 결정론 검증, AI 진단, 수리 루프를 결합한 범용 개발 방법론 skill |

---

## ship

PR 크기 기준 자동 분할과 순차 PR 생성을 자동화하는 Git 워크플로우 도구입니다.

### 주요 기능

- **대화형 분할 계획**: 변경사항 분석 → PR 크기 기준(300줄)으로 분할
- **자동 PR 생성**: 태스크 ID 입력 → 브랜치/커밋/PR 자동 생성
- **의존성 순서 보장**: 테스트/인프라 먼저, 구현체는 나중에

### 설치

```bash
/plugin install ship@say828-agent-market
```

---

## spec-orchestrator

Claude Code에서 스펙 기반 정밀 개발을 수행하기 위한 플러그인입니다. 화면설계서, PRD, SDD, 계약 문서를 `canonical target`으로 정제한 뒤, 결정론적 검증과 AI 보조 분석을 하나의 루프로 묶습니다.

### 설치

```bash
/plugin install spec-orchestrator@say828-agent-market
```

### 명령어

| 명령어 | 설명 |
|--------|------|
| `spec-orchestrator:plan` | canonical target, fixture, route, viewport, DEV 검증 루프를 포함한 실행 계획 수립 |
| `spec-orchestrator:verify` | strict proof gate 실행 후 실패 원인을 구조적으로 분류 |
| `spec-orchestrator:repair` | verify 결과를 바탕으로 수정 우선순위와 재검증 루프를 진행 |

### Codex 연계

- Codex에서는 `universal-agentic-dev` skill을 사용한다.
- 새 작업을 시작할 때는 아래 스캐폴드를 사용할 수 있다.

```bash
~/.codex/skills/universal-agentic-dev/scripts/bootstrap_spec_workspace.sh /path/to/repo
~/.codex/skills/universal-agentic-dev/scripts/init_repo_contract.sh /path/to/repo
~/.codex/skills/universal-agentic-dev/scripts/new_spec_workflow.sh "feature name" /path/to/repo
~/.codex/skills/universal-agentic-dev/scripts/new_spec_evidence.sh "feature name" /path/to/repo
```

자세한 아키텍처는 [docs/universal-agentic-dev-plugin.md](docs/universal-agentic-dev-plugin.md)를 따른다.

## universal-agentic-dev

Codex에서 스펙 기반 정밀 개발을 수행하는 기본 skill입니다. 설치 후 바로 아래 순서로 사용할 수 있습니다.

```bash
~/.codex/skills/universal-agentic-dev/scripts/bootstrap_spec_workspace.sh /path/to/repo
~/.codex/skills/universal-agentic-dev/scripts/init_repo_contract.sh /path/to/repo
~/.codex/skills/universal-agentic-dev/scripts/new_spec_workflow.sh "feature name" /path/to/repo
~/.codex/skills/universal-agentic-dev/scripts/new_spec_evidence.sh "feature name" /path/to/repo
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
~/.codex/skills/universal-agentic-dev/scripts/run_repo_phase.sh build /path/to/repo
~/.codex/skills/universal-agentic-dev/scripts/run_repo_phase.sh proof /path/to/repo
~/.codex/skills/universal-agentic-dev/scripts/run_repo_phase.sh deploy_dev /path/to/repo
~/.codex/skills/universal-agentic-dev/scripts/run_repo_phase.sh verify_dev /path/to/repo
~/.codex/skills/universal-agentic-dev/scripts/analyze_proof_results.py /path/to/proof-results.json
```

`run_repo_phase.sh`는 현재 디렉터리에서 위로 올라가며 `.codex/agentic-dev.json`, `.claude/agentic-dev.json`, `.agentic-dev/contract.json` 순서로 가장 가까운 contract를 찾는다.

이 설계는 `palcar`처럼 repo 안에 strict proof 체인이 이미 있는 서비스에도 그대로 적용할 수 있고, 다른 서비스에서는 repo-local contract만 채우면 된다.

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

## codex-hud

Codex 실행 상태, instruction surface, 최근 ToolCall/update_plan 로그, 현재 `notify` 설정, ADL notify 실행 로그를 HUD 스냅샷으로 보여주는 skill입니다.

주요 파일:

- `codex/skills/codex-hud/SKILL.md`
- `codex/skills/codex-hud/scripts/hud_snapshot.sh`

기본 사용:

```bash
~/.codex/skills/codex-hud/scripts/hud_snapshot.sh --repo /path/to/repo
```

### 명령어

| 명령어 | 설명 |
|--------|------|
| `ship:plan` | 변경사항 분석 및 분할 계획 수립 |
| `ship:apply <task-ids>` | 태스크별 브랜치/커밋/PR 자동 생성 |
| `ship:step` | 계획된 첫 번째 커밋 적용 |
| `ship:reset` | 현재 브랜치를 base로 soft reset |

### 워크플로우

```
1. 작업 완료 (모든 개발 완료)
       ↓
2. ship:plan (대화형 계획 수립)
       ↓
3. 태스크 생성 (예: KT-12633, KT-12634)
       ↓
4. ship:apply KT-12633 KT-12634
       ↓
5. 완료! 모든 PR 생성됨
```

### 환경 변수

| 변수 | 기본값 | 설명 |
|------|--------|------|
| `TASK_ID_PREFIX` | `KT-` | Task ID 접두사 |
| `PR_MAX_LINES` | `300` | PR당 최대 라인 수 |
| `GITHUB_BASE_BRANCH` | `main` | Base 브랜치 |
| `BUILD_CMD` | `./gradlew build -x test` | 빌드 명령어 |

---

## 개발

```bash
# 의존성 설치
bun install

# 테스트
bun test
```

## 프로젝트 구조

```
say828-agent-market/
├── codex/
│   └── skills/         # Codex skill packages
├── plugins/
│   ├── ship/           # Claude 플러그인
│   └── spec-orchestrator/ # 스펙 기반 개발 플러그인
└── .claude-plugin/     # Claude 마켓플레이스 설정
```

## 라이선스

Non-commercial + Copyleft License - see [LICENSE](LICENSE) for details.

상업적 사용 문의: gusdn0828@gmail.com
