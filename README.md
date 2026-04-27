# Agentic Flow

Agentic Flow is a shared development workflow for Claude Code and Codex.

It packages one installable workflow, `agentic-dev`, that turns a repository into an agent-ready development workspace: planning, implementation, verification, GitHub tracking, Discord notifications, and repeatable proof commands all live in predictable repo-local files.

## What It Provides

- One workflow that works in both Claude Code and Codex
- SDD-first planning and verification under `sdd/`
- Repo-local command contracts in `.agentic-dev/contract.json`
- Runtime aliases for Claude and Codex in `.claude/` and `.codex/`
- Optional GitHub Project and Issue setup through `gh`
- Optional Discord webhook test notification without committing secrets
- Deterministic build/proof/deploy/verify phase runners

## Install In Claude Code

Add the marketplace:

```bash
/plugin marketplace add say828/agentic-flow
```

Install the workflow:

```bash
/plugin install agentic-dev@agentic-flow
```

If installation fails with an error like `Invalid schema: plugins.N.source`, update Claude Code first:

```bash
claude update
claude plugin marketplace update
```

Then retry:

```bash
claude plugin install agentic-dev@agentic-flow
```

That schema error can come from another configured marketplace, especially `claude-plugins-official`, when the local Claude Code version is older than the marketplace manifest format.

Available Claude commands:

```text
/agentic-dev:init
```

## Install In Codex

Run the installer:

```bash
curl -fsSL https://raw.githubusercontent.com/say828/agentic-flow/main/scripts/install.sh | bash
```

Installed paths:

```text
~/.codex/skills/agentic-dev
~/.local/share/agentic-flow/repo
```

## Initialize A Repository

From any repository you want to manage with Agentic Flow:

```bash
~/.codex/skills/agentic-dev/scripts/init_agentic_dev.sh "task or product name" /path/to/repo
```

To also create or reuse a GitHub Project and create a GitHub Issue:

```bash
~/.codex/skills/agentic-dev/scripts/init_agentic_dev.sh "task or product name" /path/to/repo --github --project-title "Agentic Dev"
```

To send a Discord setup test:

```bash
export DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/..."
~/.codex/skills/agentic-dev/scripts/init_agentic_dev.sh "task or product name" /path/to/repo --github --project-title "Agentic Dev" --send-discord-test
```

The script creates:

```text
.agentic-dev/contract.json
.agentic-dev/onboarding.json
.agentic-dev/discord.env.example
.codex/agentic-dev.json
.claude/agentic-dev.json
sdd/01_planning/
sdd/02_plan/
sdd/03_verify/
sdd/99_toolchain/
```

## Repository Contract

Agentic Flow does not hardcode project-specific commands. Each repository owns its command contract:

```text
.agentic-dev/contract.json
```

The contract defines phases such as:

```json
{
  "commands": {
    "build": "npm run build",
    "proof": "npm run proof",
    "deploy_dev": "npm run deploy:dev",
    "verify_dev": "npm run verify:dev"
  }
}
```

Run phases through the bundled runner:

```bash
~/.codex/skills/agentic-dev/scripts/run_repo_phase.sh build /path/to/repo
~/.codex/skills/agentic-dev/scripts/run_repo_phase.sh proof /path/to/repo
~/.codex/skills/agentic-dev/scripts/run_repo_phase.sh deploy_dev /path/to/repo
~/.codex/skills/agentic-dev/scripts/run_repo_phase.sh verify_dev /path/to/repo
```

The runner resolves the nearest contract in this order:

```text
.codex/agentic-dev.json
.claude/agentic-dev.json
.agentic-dev/contract.json
```

## SDD Workflow

Agentic Flow keeps durable delivery records in `sdd/`:

- `sdd/01_planning`: current planning and specs
- `sdd/02_plan`: executable task plans and canonical targets
- `sdd/03_verify`: retained verification evidence and residual risk
- `sdd/99_toolchain`: repo-local SDD automation

The default loop is:

1. Inspect or update planning.
2. Create or update the task plan.
3. Implement against the repo contract.
4. Run build, proof, deploy, and verification phases as applicable.
5. Record evidence and residual risk in `sdd/03_verify`.

## Local Sandbox

This repository includes a runnable sandbox at:

```text
test/agentic-dev-sandbox
```

Run its phases from the repository root:

```bash
codex/skills/agentic-dev/scripts/run_repo_phase.sh build test/agentic-dev-sandbox
codex/skills/agentic-dev/scripts/run_repo_phase.sh proof test/agentic-dev-sandbox
codex/skills/agentic-dev/scripts/run_repo_phase.sh deploy_dev test/agentic-dev-sandbox
codex/skills/agentic-dev/scripts/run_repo_phase.sh verify_dev test/agentic-dev-sandbox
codex/skills/agentic-dev/scripts/analyze_proof_results.py test/agentic-dev-sandbox/tmp/proof-results.json
```

For a fresh manual setup test, use:

```text
test/agentic-dev-dev
```
