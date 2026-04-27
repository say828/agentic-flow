---
description: Show the integrated SDD workflow for Agentic Dev
---

# agentic-dev:sdd-workflow

Use the integrated SDD workflow from `skill/SKILL.md`.

## Instructions

1. Inspect the target repository's `sdd/01_planning` artifacts before code edits.
2. Create or update the durable task plan under `sdd/02_plan/<section>/`.
3. For a new implementation task, create a clean task branch or worktree before the first file edit when the target repo requires it.
4. Implement against the Agentic Dev repo contract at `.agentic-dev/contract.json`.
5. Record retained verification, regression scope, evidence, and residual risk in `sdd/03_verify`.

## Expected Output

- planning artifact reviewed or corrected
- durable plan file updated
- verification summary updated in `sdd/03_verify`
