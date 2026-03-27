# spec-orchestrator:verify

구현 후 strict 검증과 AI 보조 분석을 함께 수행할 때 사용하는 명령입니다.

## 지시

1. deterministic proof gate를 실행한다.
2. 실패 시 원인을 아래 분류 중 하나로 정리한다.
   - reference noise
   - layout mismatch
   - text/content mismatch
   - state mismatch
   - semantic mismatch
3. pure visual mismatch와 runtime/state mismatch를 분리한다.
4. DEV 반영 확인까지 끝난 뒤 evidence를 남긴다.

## 기대 결과

- strict proof 결과
- 대표 실패 화면 목록
- 원인 분류
- 다음 수정 우선순위
