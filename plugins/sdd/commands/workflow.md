# sdd:workflow

Use the SDD workflow from `skill/SKILL.md`.

## Instructions

1. Inspect the target repository's `sdd/01_planning` artifacts before code edits.
2. Create or update the durable task plan under `sdd/02_plan/<section>/`.
3. For a new implementation task, create a clean task branch or worktree before the first file edit when the target repo requires it.
4. Implement against the plan.
5. Record the current implementation in `sdd/03_build`.
6. Record retained verification, regression scope, evidence, and residual risk in `sdd/04_verify`.
7. Update `sdd/05_operate` when rollout or runtime follow-up happens.

## Expected Output

- planning artifact reviewed or corrected
- durable plan file updated
- build summary updated
- verification summary updated
- operate status updated when deployment happens
