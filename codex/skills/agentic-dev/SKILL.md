---
name: agentic-dev
description: "Use when setting up or running an end-to-end agentic development process. Handles first-use repo onboarding with GitHub Project/Issue setup, SDD planning and verification, Agentic Dev contract, Discord webhook notification wiring, then drives implementation, test, deployment, monitoring, deterministic proof gates, and repair loops through one integrated workflow."
---

# Agentic Dev

## Objective

Run one development process from first repo setup through implementation and verification:

1. bootstrap repo-local Agentic Dev and SDD surfaces,
2. register the work in GitHub Projects and Issues when requested,
3. wire Discord webhook notifications without committing secrets,
4. canonicalize the spec target,
5. implement against deterministic runtime conditions,
6. run SDD verification and proof gates,
7. repair until pass or explicit blocker,
8. record the current delivery state when deployment or monitoring is in scope.

## First-Use Setup

For a new repository or first use of this skill, prefer the deterministic bootstrap script:

```bash
~/.codex/skills/agentic-dev/scripts/init_agentic_dev.sh "task or product name" /path/to/repo --github --project-title "Agentic Dev" --send-discord-test
```

The script creates or updates:

- `.agentic-dev/contract.json`
- `.codex/agentic-dev.json`
- `.claude/agentic-dev.json`
- `.agentic-dev/onboarding.json`
- `.agentic-dev/discord.env.example`
- `sdd/01_planning`, `sdd/02_plan`, `sdd/03_verify`, `sdd/99_toolchain`
- a task plan under `sdd/02_plan/01_feature`
- a verification record under `sdd/03_verify/01_feature`

Use `--github` only when remote side effects are intended. It creates or reuses a GitHub Project, creates a GitHub Issue, and links the issue to the project. Use `--repo OWNER/REPO` when `origin` is not the target GitHub repository.

For Discord, set the webhook in the shell environment, not in committed files:

```bash
export DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/..."
```

The script writes only `.agentic-dev/discord.env.example`.

## Integrated SDD Workflow

Use SDD as the retained delivery record whenever the target repository has or is being initialized with `sdd/`.

1. Inspect relevant planning artifacts in `sdd/01_planning` before code edits.
2. Create or update a durable plan under `sdd/02_plan/<section>/`.
3. For a new implementation task, create a clean task branch or worktree before the first file edit when the target repository requires it.
4. Implement against the plan and repo contract.
5. Record retained verification, regression scope, evidence, and residual risk in `sdd/03_verify`.

Read `references/section-map.md` when you need the exact destination inside `sdd/`.

Do not create or repopulate a parallel `docs/` tree in repositories that use `sdd/` as the canonical delivery system.

For repositories with DEV and PROD environments, validate DEV first, promote to PROD only after DEV passes, then rerun the retained validation surface in PROD. If PROD validation fails, roll back or follow the approved recovery path and record the result in `sdd/03_verify`.

For persistence-affecting work, verify schema parity against the real environments that matter for the repository instead of assuming code and deployed schema match.

## Development Loop

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

## Repo Contract

Keep repo-specific commands in `.agentic-dev/contract.json`.

- Runtime-friendly aliases may live at `.codex/agentic-dev.json` and `.claude/agentic-dev.json`.
- Do not hardcode service commands into the skill itself.
- Use `auto` for build/proof/deploy phases when the bundled runner should infer common commands from the target repo.
- Override `auto` with explicit shell commands only when the repo has a stricter retained gate.
- This allows the same skill to work across service repos without becoming service-specific.

## Execution Helpers

- Use `scripts/init_agentic_dev.sh "title" [repo_root]` for full onboarding.
- Use `scripts/bootstrap_spec_workspace.sh [repo_root]` to prepare only the docs workspace.
- Use `scripts/init_repo_contract.sh [repo_root]` to create only the repo-local command contract.
- Use `scripts/new_spec_workflow.sh "feature name" [repo_root]` to create a docs workflow file.
- Use `scripts/new_spec_evidence.sh "feature name" [repo_root]` to create a docs evidence file.
- Use `scripts/run_repo_phase.sh build [repo_root]` to run the repo-local build command.
- Use `scripts/run_repo_phase.sh proof [repo_root]` to run the repo-local deterministic proof gate.
- Use `scripts/run_repo_phase.sh deploy_dev [repo_root]` and `verify_dev` for DEV loops where required.
- Use `scripts/analyze_proof_results.py <proof-json>` to summarize proof outputs generically.

The runner resolves the nearest contract by searching `.codex/agentic-dev.json`, `.claude/agentic-dev.json`, then `.agentic-dev/contract.json` upward from the current directory.

## GitHub And Discord Guardrails

- Ask before creating remote GitHub Projects or Issues unless the user explicitly requested setup/onboarding.
- Never commit real Discord webhook URLs.
- If GitHub Project creation fails because `gh` lacks `project` scope, tell the user to run `gh auth refresh -s project`.
- If a Discord webhook is not configured, keep the local setup and report that notification testing was skipped.
- Record created issue/project URLs in `.agentic-dev/onboarding.json`.

## Guardrails

- Deterministic proof remains the release gate.
- AI analysis should explain failures, not waive them.
- Never compare raw planning pages when only a subset is actually implementable.
- Prefer repo-local SDD verification records over ephemeral chat summaries.
- Do not skip SDD planning review just because the code change looks small.
- Do not leave verification evidence only in chat text.
- If DEV deployment is part of the operating contract, do not stop at local build success.

## Expected Outputs

- Agentic Dev contract and aliases
- SDD plan and verification records
- GitHub issue/project links when enabled
- Discord webhook example or test notification result
- canonical target definition
- validation evidence
- blocker list when strict success is not yet possible

## Resources

- Full bootstrap: `scripts/init_agentic_dev.sh`
- Template: `assets/spec-workflow-template.md`
- Evidence template: `assets/spec-evidence-template.md`
- GitHub issue template: `assets/github-issue-template.md`
- Repo contract template: `assets/repo-contract.template.json`
- Scaffolder: `scripts/new_spec_workflow.sh`
- Evidence scaffolder: `scripts/new_spec_evidence.sh`
- Workspace bootstrap: `scripts/bootstrap_spec_workspace.sh`
- Repo contract bootstrap: `scripts/init_repo_contract.sh`
- Repo contract resolver: `scripts/resolve_repo_contract.py`
- Repo phase runner: `scripts/run_repo_phase.sh`
- Proof analyzer: `scripts/analyze_proof_results.py`
- SDD section map: `references/section-map.md`
- Failure taxonomy: `references/failure-taxonomy.md`
