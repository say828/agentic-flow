# Agentic Dev Sandbox Evidence

- Date: 2026-04-28
- Owner: Codex
- Status: passing

## Runtime Contract

- Repo root:
- Target environment:
- Route / screen / flow:
- Fixture / seed:
- Viewport:
- Locale / timezone:
- Auth state:

## Commands

```text
# build / test
codex/skills/agentic-dev/scripts/run_repo_phase.sh build test/agentic-dev-sandbox

# deterministic proof
codex/skills/agentic-dev/scripts/run_repo_phase.sh proof test/agentic-dev-sandbox
codex/skills/agentic-dev/scripts/analyze_proof_results.py test/agentic-dev-sandbox/tmp/proof-results.json

# DEV verification
codex/skills/agentic-dev/scripts/run_repo_phase.sh deploy_dev test/agentic-dev-sandbox
codex/skills/agentic-dev/scripts/run_repo_phase.sh verify_dev test/agentic-dev-sandbox
```

## Results

- Build / test: passed, wrote `tmp/build.txt`
- Proof gate: passed, `failing_cases=0`
- DEV verification: passed, wrote `tmp/deploy_dev.txt` and `tmp/verify_dev.txt`

## Failure Summary

- Reference noise:
- Layout mismatch:
- Text / content mismatch:
- State mismatch:
- Semantic mismatch:

## Evidence Files

- Reference:
- Actual:
- Diff:
- Logs:

## Notes

- 
