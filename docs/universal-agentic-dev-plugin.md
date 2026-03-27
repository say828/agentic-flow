# Universal Agentic Development Plugin

## Goal

Build a cross-runtime development plugin for Claude Code and Codex that enables high-rigor, repeatable implementation against product specs, screen designs, and runtime behavior.

The plugin must not depend on a single comparison method. It should combine:

1. `Canonical spec compilation`
2. `Deterministic runtime verification`
3. `AI-assisted structural analysis`
4. `Semantic behavior contracts`
5. `Repair feedback loops`

## Why A Hybrid Model

Pure pixel comparison is reproducible but brittle when the source spec contains callouts, annotations, or outdated branding.

Pure AI judgment is flexible but too soft for release gating.

The plugin therefore separates responsibilities:

- Deterministic engines decide pass/fail.
- AI systems classify, align, explain, and prioritize.

## Core Pipeline

### 1. Canonical Spec Compiler

Input:

- screen design files
- PRD / SDD documents
- route catalogs
- fixture/state requirements

Output:

- clean reference image
- structured layout graph
- component inventory
- expected text tokens
- interaction contract

The compiler removes non-implementable layers such as:

- review annotations
- numbered callout markers
- side comments
- presentation-only overlays

### 2. Deterministic Visual Gate

Run the target app in a fully fixed rendering environment:

- viewport fixed
- locale/timezone fixed
- font set fixed
- fixture/state fixed
- route fixed

Then apply strict proof:

- size mismatch = fail
- pixel diff > 0 = fail
- missing route/reference/fixture = fail before capture

### 3. Structural AI Vision Layer

Use multimodal AI to compare meaning and structure rather than deciding release pass/fail directly.

Outputs must be structured:

- matched sections
- missing components
- extra components
- hierarchy drift
- text semantic drift
- probable root-cause classes

### 4. Semantic Contract Layer

Visual similarity is not enough. The plugin must also verify behavior:

- CTA destinations
- form validation rules
- state transitions
- enabled/disabled conditions
- API-backed content shape

### 5. Repair Intelligence

All failures become training data for future triage:

- reference image
- actual image
- diff image
- DOM snapshot
- style snapshot
- route/state/fixture metadata
- final human label

This enables:

- failure clustering
- root cause prioritization
- likely file ownership prediction
- automated repair suggestions

## Runtime Surfaces

### Codex

Ship as installable skills plus helper wrappers:

- planning workflow
- spec-to-implementation workflow
- parity/verification workflow
- repair loop workflow

Recommended first package shape:

- `SKILL.md` for behavioral contract
- `scripts/bootstrap_spec_workspace.sh`
- `scripts/init_repo_contract.sh`
- `scripts/new_spec_workflow.sh`
- `scripts/new_spec_evidence.sh`
- `scripts/run_repo_phase.sh`
- `scripts/analyze_proof_results.py`
- `references/failure-taxonomy.md`
- reusable templates under `assets/`

Generalization rule:

- repo-specific behavior lives in `.agentic-dev/contract.json`
- runtime-friendly aliases may live in `.codex/agentic-dev.json` and `.claude/agentic-dev.json`
- the plugin never hardcodes service names, routes, or proof commands
- service repos like `palcar` only provide commands and artifacts, not forks of the skill

Contract resolution rule:

- resolve the nearest repo contract upward from the current working directory
- precedence: `.codex/agentic-dev.json` -> `.claude/agentic-dev.json` -> `.agentic-dev/contract.json`
- alias files may point back to `.agentic-dev/contract.json` via `contract_path`

### Claude Code

Ship as marketplace plugin assets:

- commands
- hooks
- orchestrator integrations
- review/approval surfaces

## Proposed Product Surface In `say828-agent-market`

### Codex skill

`universal-agentic-dev`

Responsibilities:

- compile spec into an implementation checklist
- enforce deterministic validation expectations
- require evidence logs
- drive a bounded repair loop until proof passes or blockers are explicit

### Future Claude plugin

`spec-orchestrator`

Responsibilities:

- render validation dashboards
- collect hook events
- classify verification failures
- coordinate repair agents

## Execution Contract

For any feature-oriented request:

1. read spec inputs
2. derive canonical implementation target
3. prepare deterministic fixture/runtime
4. implement code
5. deploy to DEV if applicable
6. run strict proof
7. run AI structural analysis
8. patch and repeat
9. record evidence

## Success Criteria

The plugin is successful when installing `say828-agent-market` makes it possible to invoke a named workflow and reliably obtain:

- a plan
- a canonical target
- deterministic proof output
- AI-assisted diagnosis
- a documented repair loop
