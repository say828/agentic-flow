# agentic-dev-plugin

## Scope

- Design a agentic development skill methodology usable across Claude Code and Codex.
- Package the methodology into `agentic-flow` as installable Codex skill assets first.
- Define the future Claude-side plugin surface without breaking the existing marketplace layout.
- Expand the Codex package from documentation-only assets into an executable workflow scaffold.
- Keep the Codex package general so `aspace` service repos such as `palcar` can adopt it through repo-local contracts rather than service-specific forks.

## Acceptance Criteria

- Add a durable architecture document explaining the hybrid `canonical spec -> deterministic gate -> AI analysis -> repair loop` model.
- Add an installable Codex skill package that exposes the methodology as a named workflow.
- Update install and README surfaces so the skill is installed and discoverable from `agentic-flow`.
- Add a first Claude marketplace plugin surface for the same methodology.

## Checklist

- [x] Inspect current `agentic-flow` layout and installer behavior
- [x] Add architecture/design document
- [x] Add Codex skill package
- [x] Wire installer + README
- [x] Add first Claude plugin surface
- [x] Expand Codex workflow assets
- [x] Add repo-local contract execution model
- [x] Validate install surface locally

## Work Log

- 2026-03-08 14:52 - Plan created after confirming local repo path `/home/sh/Documents/Github/agentic-flow`.
- 2026-03-08 14:53 - Current marketplace structure verified: Claude plugins via `.claude-plugin`, Codex assets via `codex/skills`, installer currently ships `planning-with-files` and `codex-hud`.
- 2026-03-08 15:01 - Added `docs/agentic-dev-plugin.md` and `codex/skills/agentic-dev/` to package the methodology as installable Codex assets.
- 2026-03-08 15:08 - Added `plugins/spec-orchestrator` and registered it in `.claude-plugin/marketplace.json` as the first Claude plugin surface for the same workflow.
- 2026-03-08 15:16 - Updated README, Codex scaffolding assets, and Claude command naming so both runtimes expose the methodology consistently.
- 2026-03-08 15:19 - Validated `scripts/install.sh` and `codex/skills/agentic-dev/scripts/new_spec_workflow.sh` with `bash -n`.
- 2026-03-08 15:20 - Executed `new_spec_workflow.sh "demo feature"` against a temporary repo root and confirmed `docs/plans/<date>-demo-feature.md` was generated from the template.
- 2026-03-08 15:27 - Expanded the Codex package with `bootstrap_spec_workspace.sh`, `new_spec_evidence.sh`, `assets/spec-evidence-template.md`, and `references/failure-taxonomy.md`.
- 2026-03-08 15:29 - Executed the Codex bootstrap + workflow + evidence scripts against a temporary repo root and confirmed `docs/plans`, `docs/evidence`, and `docs/canonical-targets` were prepared as expected.
- 2026-03-08 15:37 - Added repo-local contract assets: `assets/repo-contract.template.json`, `scripts/init_repo_contract.sh`, `scripts/run_repo_phase.sh`, and `scripts/analyze_proof_results.py`.
- 2026-03-08 15:39 - Executed a temporary contract with `build`, `proof`, `deploy_dev`, and `verify_dev` phases and confirmed the generic proof analyzer summarized the resulting JSON without any service-specific hardcoding.
- 2026-03-08 15:46 - Added `scripts/resolve_repo_contract.py`, runtime-friendly `.codex/.claude` alias generation, and nearest-contract upward resolution so nested repos can use the same skill naturally.
- 2026-03-08 17:16 - Applied the new contract model to `/home/sh/Documents/Github/aspace/palcar` with `.agentic-dev/contract.json` plus `.codex/.claude` aliases and verified nested-path resolution from `palcar/frontend/src/pages`.
- 2026-03-08 17:18 - Executed PALCAR phases through the generic runner: `build` passed, `proof` completed with `87` seller/dealer cases and no blocking preflight issues, and `verify_dev` passed against `https://pc.dev.do4ai.com/`.

## Validation

- [x] Local install flow verified
