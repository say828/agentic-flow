# spec-orchestrator:plan

스펙 기반 개발 작업을 시작할 때 사용하는 명령입니다.

## 지시

아래 원칙을 따라 계획을 수립하세요.

1. 구현 입력 스펙을 식별한다.
2. 스펙에서 실제 구현 대상과 비구현 주석, 마커, 노이즈를 구분한다.
3. route, fixture, viewport, auth state, locale, timezone을 결정론적으로 고정한다.
4. 구현, strict 검증, DEV 반영, 재검증 순서로 체크리스트를 만든다.
5. strict proof 없이는 완료로 간주하지 않는다.

## 기대 결과

- canonical target 정의
- 실행 체크리스트
- proof gate 정의
- blocker 목록
