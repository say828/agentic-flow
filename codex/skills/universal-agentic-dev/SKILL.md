---
name: universal-agentic-dev
description: Run a universal spec-to-implementation workflow using canonical spec compilation, deterministic proof gates, AI-assisted structural diagnosis, and repair loops. Use when the user asks for exact implementation against specs, screen designs, contracts, or wants a rigorous agentic development workflow across repos.
---

# Universal Agentic Development

## Objective

Drive development with a layered method:

1. Canonicalize the spec target
2. Fix the runtime deterministically
3. Implement against the target
4. Verify visually and semantically
5. Use AI analysis for diagnosis, not final verdict
6. Repeat until the hard gate passes or blockers are explicit

## Workflow

1. Identify the spec inputs and runtime target.
2. Remove non-implementable noise from the spec mentally or by tooling.
3. Define deterministic conditions:
   - route
   - fixture data
   - viewport
   - locale/timezone
   - auth state
4. Implement the missing or divergent behavior.
5. Run the deterministic proof gate.
6. If it fails, classify the failure:
   - reference noise
   - layout mismatch
   - text/content mismatch
   - state mismatch
   - semantic behavior mismatch
7. Patch the most leveraged cause first.
8. Record evidence and continue until pass or explicit blocker.

## Bootstrap

- Use `scripts/bootstrap_spec_workspace.sh [repo_root]` to prepare the minimal working directories.
- Use `scripts/init_repo_contract.sh [repo_root]` to create the repo-local command contract under `.agentic-dev/contract.json` plus `.codex` and `.claude` aliases.
- Use `scripts/new_spec_workflow.sh "feature name" [repo_root]` to create a durable workflow file in `docs/plans/`.
- Use `scripts/new_spec_evidence.sh "feature name" [repo_root]` to create a matching evidence log in `docs/evidence/`.
- Fill the canonical target section before major edits.
- Keep proof evidence and DEV verification in the same file.

## Repo Contract

- Keep repo-specific proof, deploy, and DEV verification commands in `.agentic-dev/contract.json`.
- Runtime-friendly aliases may live at `.codex/agentic-dev.json` and `.claude/agentic-dev.json`.
- Do not hardcode service commands into the skill itself.
- This allows the same skill to work in `aspace` service repos such as `palcar` without becoming service-specific.

## Execution Helpers

- Use `scripts/run_repo_phase.sh build [repo_root]` to run the repo-local build command.
- Use `scripts/run_repo_phase.sh proof [repo_root]` to run the repo-local deterministic proof gate.
- Use `scripts/run_repo_phase.sh deploy_dev [repo_root]` and `verify_dev` for DEV loops where required.
- The runner resolves the nearest contract by searching `.codex/agentic-dev.json`, `.claude/agentic-dev.json`, then `.agentic-dev/contract.json` upward from the current directory.
- Use `scripts/analyze_proof_results.py <proof-json>` to summarize proof outputs generically.

## Guardrails

- Deterministic proof remains the release gate.
- AI analysis should explain failures, not waive them.
- Never compare raw planning pages when only a subset is actually implementable.
- Prefer repo-local evidence logs over ephemeral chat summaries.
- If DEV deployment is part of the operating contract, do not stop at local build success.

## Expected Outputs

- implementation plan
- canonical target definition
- validation evidence
- blocker list when strict success is not yet possible

## Resources

- Template: `assets/spec-workflow-template.md`
- Evidence template: `assets/spec-evidence-template.md`
- Repo contract template: `assets/repo-contract.template.json`
- Scaffolder: `scripts/new_spec_workflow.sh`
- Evidence scaffolder: `scripts/new_spec_evidence.sh`
- Workspace bootstrap: `scripts/bootstrap_spec_workspace.sh`
- Repo contract bootstrap: `scripts/init_repo_contract.sh`
- Repo contract resolver: `scripts/resolve_repo_contract.py`
- Repo phase runner: `scripts/run_repo_phase.sh`
- Proof analyzer: `scripts/analyze_proof_results.py`
- Failure taxonomy: `references/failure-taxonomy.md`
