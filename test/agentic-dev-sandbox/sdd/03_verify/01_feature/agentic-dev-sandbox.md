# Agentic Dev Sandbox

## Current Verification

- Status: passing
- Contract: `.agentic-dev/contract.json`
- SDD plan: `sdd/02_plan/01_feature/agentic-dev-sandbox_todos.md`

## Evidence

- `run_repo_phase.sh build test/agentic-dev-sandbox`
  - wrote `tmp/build.txt`
- `run_repo_phase.sh proof test/agentic-dev-sandbox`
  - wrote `tmp/proof-results.json`
- `run_repo_phase.sh deploy_dev test/agentic-dev-sandbox`
  - wrote `tmp/deploy_dev.txt`
- `run_repo_phase.sh verify_dev test/agentic-dev-sandbox`
  - wrote `tmp/verify_dev.txt`
- `analyze_proof_results.py test/agentic-dev-sandbox/tmp/proof-results.json`
  - `cases_found=1`
  - `failing_cases=0`
  - `best_case=sandbox score=0.00000000`

## Residual Risk

- Runtime files under `tmp/` are ignored and must be regenerated when rechecking the sandbox.
