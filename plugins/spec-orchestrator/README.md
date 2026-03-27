# spec-orchestrator

`spec-orchestrator` 는 화면설계서, PRD, SDD, 계약 문서 기반 개발을 Claude Code와 Codex에서 공통으로 수행하기 위한 범용 개발 플러그인 패키지입니다.

## 목표

- 스펙을 그대로 읽고 구현하는 것이 아니라 `구현 대상만 남긴 canonical target`으로 정제
- 결정론적 검증으로 최종 pass/fail 판정
- AI/ML로 구조 차이와 원인을 분류
- 실패를 다시 수리 루프로 연결

## 핵심 방법론

1. `Canonical Spec Compiler`
2. `Deterministic Proof Gate`
3. `Structural AI Analysis`
4. `Semantic Contract Verification`
5. `Repair Loop`

자세한 설계는 [Universal Agentic Development Plugin](/home/sh/Documents/Github/say828-agent-market/docs/universal-agentic-dev-plugin.md) 문서를 따른다.

## Claude Code 명령 표면

- `spec-orchestrator:plan`
- `spec-orchestrator:verify`
- `spec-orchestrator:repair`

## Codex 표면

- `universal-agentic-dev` skill

## 의도된 사용 흐름

1. 스펙 문서와 구현 대상을 지정
2. canonical target을 정의
3. deterministic fixture/runtime을 고정
4. 구현
5. DEV 반영
6. strict proof 실행
7. AI 분석으로 root cause 분류
8. patch 및 반복
