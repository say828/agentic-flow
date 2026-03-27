# spec-orchestrator:repair

verify 결과를 바탕으로 수정과 재검증 루프를 진행할 때 사용하는 명령입니다.

## 지시

1. 실패를 가장 영향력이 큰 원인부터 정렬한다.
2. reference 문제, 구현 문제, 데이터/상태 문제를 분리한다.
3. strict gate를 무효화하지 말고 입력면 또는 구현면을 바로잡는다.
4. 수정 후 build, proof, DEV 검증을 다시 실행한다.
5. pass 또는 명시적 blocker가 나올 때까지 반복한다.

## 기대 결과

- 수정 우선순위
- 현재 패치 대상
- 재검증 결과
- 잔여 blocker
