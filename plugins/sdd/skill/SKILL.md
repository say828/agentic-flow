---
name: sdd
description: "Use for software development work in repositories that treat `sdd/` as the canonical delivery system. Trigger on requests like develop, implement, code, work on, modify, fix, patch, refactor, test, verify, deploy, monitor, or screen/UI-driven prompts such as 화면명세서, 화면설계서, 화면 설계, 화면, 화면 스펙, UI, 디자인, 디자인 가이드, screen spec, screen design, or design guide. The workflow is SDD-first: inspect and update `sdd/01_planning`, create or update the task plan under `sdd/02_plan`, implement the change, and capture retained validation in `sdd/03_verify`."
---

# SDD Development

## Overview

Use this skill for implementation work in repositories that treat `sdd/` as the canonical delivery record.

This skill enforces one workflow:

1. inspect and fix relevant `sdd/01_planning` artifacts first,
2. create or update the task plan under `sdd/02_plan/<section>/`,
3. if this is a new implementation task, create a dedicated clean task branch or clean worktree before the first file edit when the target repository requires it,
4. perform the code work against the plan,
5. record retained validation, regression scope, evidence, and residual risk in `sdd/03_verify`.

The retained SDD trail stops at planning plus verification. Implementation and rollout facts belong in the durable plan notes and verification summary unless the target repository has its own explicit convention.

For repositories with separate DEV and PROD environments, use a staged release rule when rollout is in scope: validate DEV first, promote to PROD only after DEV passes, then rerun the retained validation surface in PROD. If PROD validation fails, rollback is required unless the user explicitly redirects and that risk is recorded in `sdd/03_verify`.
For persistence-affecting work, this skill also enforces schema-parity verification. Compare migration or model intent against real DEV and PROD schema state for the affected database objects instead of assuming deployed reality matches the code.

Read [references/section-map.md](references/section-map.md) when you need the exact destination inside `sdd/`.
For screen-spec-driven UI work, reusable static assets from the spec must be extracted through the repo's canonical asset builder before being used in code.
For screen-spec-driven layout work, inspect the repo's canonical design guide builder first when one exists.
For verification work, treat regression scope selection as a required retained artifact and carry it through `sdd/02_plan` and `sdd/03_verify`.

## When To Use

Use this skill when:

- the repository has `sdd/01_planning`, `sdd/02_plan`, and `sdd/03_verify`,
- the user gives a development instruction such as `개발해`, `작업해`, `구현해`, `수정해`, `고쳐`, `리팩토링해`, `테스트해`, `검증해`, `배포해`,
- the user asks for screen/UI work with prompts such as `화면명세서`, `화면설계서`, `화면 설계`, `화면`, `화면 스펙`, `UI`, `디자인`, `디자인 가이드`, `screen spec`, `screen design`, or `design guide`,
- the user wants work to be traceable through those folders,
- the task includes implementation plus planning and verification updates.

Do not use this skill for:

- casual questions with no repo changes,
- one-off local debugging where no durable SDD record is needed,
- repositories that do not use `sdd/` as their primary document system.

## Workflow

### 1. Inspect Planning First

- Identify the impacted planning area before editing code.
- Open only the relevant artifacts in `sdd/01_planning`:
  - feature
  - screen
  - architecture
  - data
  - api
  - iac
  - integration
  - nonfunctional
  - security
  - test
- If the implementation has already drifted from planning, update the planning artifact first or record the drift before coding.

### 2. Create Or Update The Plan

- Create or reuse a durable plan file under `sdd/02_plan/<section>/`.
- Prefer the repo's planning scaffold if available.
- The plan must include:
  - scope
  - assumptions
  - acceptance criteria
  - execution checklist
  - current notes
  - validation
- For any task that may end in deployment, acceptance criteria must explicitly include the DEV gate, the matching PROD gate when applicable, the retained validation surface, and the rollback trigger/path.
- For any task that touches persistence, models, repositories, migrations, SQL, ORM mappings, or runtime failures that may involve schema drift, acceptance criteria must explicitly include DEV/PROD schema verification when those environments exist.
- Keep exactly one checklist item in progress.

### 3. Create A Clean Task Branch Before Editing

- Exploration and planning may happen before branch creation.
- For a new implementation task, do not start file edits on the shared current branch/worktree when the target repository requires a task branch.
- Before the first file modification, create a dedicated task branch from the current canonical baseline.
- If the current worktree is already dirty with unrelated changes, create a clean worktree plus task branch instead of mixing the new task into the dirty tree.
- When the repo baseline treats `main` as the deployment baseline, the task branch is temporary working space only. Land the final retained change on `main` before calling rollout complete.

### 4. Implement Against The Plan

- Make code changes only after the impacted planning artifact and plan are aligned enough to proceed.
- Update the plan current notes after meaningful edits or decisions.
- When document generators or capture pipelines are involved, keep those tools under `sdd/99_toolchain`.
- When the task depends on icons, logos, illustrations, or other static assets visible in a screen spec, use the repo's canonical Asset Spec Builder first.
  - In repos created from this template, this is typically `sdd/99_toolchain/01_automation/spec_asset_builder.py` or a wrapper/manifest around it.
  - Reusable asset planning records belong under `sdd/01_planning/02_screen/assets/`.
  - Create the runtime asset from the approved PDF/image source instead of hand-tracing or screenshot-cropping it.
  - Use exact verification such as `--verify-exact` when the asset is expected to match the source crop exactly.
  - Record the source, manifest, generated asset path, and any exception in `sdd/02_plan` and `sdd/03_verify`.
  - Only fall back to manual recreation when the builder cannot express the asset, and explicitly document that exception in the plan and verification trail.
- When the task depends on spacing, layout density, typography, color rhythm, or component hierarchy derived from a screen spec, inspect the repo's canonical design guide builder first.
  - In repos created from this template, this is typically `sdd/99_toolchain/01_automation/screen_design_guide_builder.py` or a wrapper/manifest when that automation exists.
  - Use the generated guide as the working baseline before manual spacing or palette tweaks.
  - If the repo does not provide a design guide builder yet, document the manual interpretation source in plan and verification.
- Define the regression surface before calling implementation complete.
  - Start from `sdd/02_plan/10_test/regression_verification.md` when present.
  - Identify the direct target plus any upstream, downstream, and shared surfaces affected by the change.
  - If the change touches shared routing, shell/auth, shared state, common components, contracts, generated assets, or builder output, widen the regression scope instead of validating only the edited module.
  - Record the selected regression scope and any justified exclusions in plan and verification.

### 5. Record Verification

- Record retained verification status in `sdd/03_verify`.
- Use:
  - `03_verify/01_feature` for feature verification summaries
  - `03_verify/02_screen` for screen verification summaries
  - `03_verify/03_architecture`, `06_iac`, `10_test` for current retained checks and residual risk
- Never claim completion without command-level validation evidence.
- For staged DEV -> PROD rollout, verification must use the same retained validation surface in both environments.
  - Run validation in DEV after deployment and treat it as a hard gate before PROD promotion.
  - After PROD deployment, rerun the same retained validation surface in PROD.
  - If PROD validation fails, execute rollback or the approved recovery procedure immediately and record the failure and recovery outcome.
- For persistence-affecting work, verification must include real schema evidence from both DEV and PROD when those environments exist.
  - Check migration state and actual runtime schema separately.
  - Validate the tables, columns, indexes, constraints, triggers, defaults, and any legacy compatibility objects touched by the change.
  - Record the commands or queries used, the environments checked, and the drift or parity result.
- Regression verification is mandatory.
  - Verification must cover the direct surface and the retained upstream/downstream/shared surfaces selected from the regression baseline.
  - If no automation exists for a needed regression slice yet, run the best available manual or command checks and record that gap as current residual risk.

## Guardrails

- Do not create or repopulate a parallel `docs/` tree when `sdd/` exists.
- Do not skip planning review just because the code change looks small.
- Do not begin file edits for a new implementation task on a shared dirty worktree when a clean task branch/worktree should be created first.
- Do not leave verification evidence only in chat text when it should live in `sdd/03_verify`.
- Do not promote to PROD before the retained DEV validation surface has passed.
- Do not use a weaker PROD validation surface than the one that gated DEV unless the user explicitly approves and that risk is recorded.
- Do not stop at "PROD deployment succeeded"; post-deploy PROD validation is mandatory when rollout is in scope.
- Do not leave a failed PROD deployment unreconciled; rollback or the approved recovery procedure must be executed and recorded.
- Do not assume local tests, migration heads, or current model code prove deployed schema parity.
- Do not skip DEV/PROD schema inspection for persistence-affecting work when schema drift could influence behavior.
- Do not manually redraw screen-spec static assets when a canonical Asset Spec Builder exists in the target repository; extract them first and use the generated asset.
- Do not skip a relevant screen automation builder just because the requested UI change looks like a small manual tweak.
- Do not stop verification at the edited file, route, or screen when the change can affect shared or adjacent behavior.
- Do not omit regression scope selection from the retained SDD trail.
- Do not call a DEV rollout complete from a temporary branch when the repo or team baseline expects the deployed change to be on `origin/main`.

## Output Standard

By the end of an implementation task, the expected trail is:

- planning artifact reviewed or corrected,
- plan file updated,
- verification summary written in `sdd/03_verify`, including selected regression scope and residual risk.

When PROD rollout is in scope, the retained completion state also requires:

- DEV deployment happened first and the retained DEV validation surface passed,
- the same retained validation surface was executed again in PROD,
- DEV/PROD schema state was checked and recorded when schema could influence behavior,
- any PROD validation failure produced rollback or recovery evidence in `sdd/03_verify`.
