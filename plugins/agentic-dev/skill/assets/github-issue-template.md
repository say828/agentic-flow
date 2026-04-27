# {{TITLE}}

## Agentic Dev Setup

- Repository: `{{REPO}}`
- SDD plan: `{{SDD_PLAN}}`
- SDD verification: `{{SDD_VERIFY}}`
- Agentic contract: `.agentic-dev/contract.json`

## Workflow

1. Keep the task plan current under `sdd/02_plan`.
2. Implement against the repo-local `.agentic-dev/contract.json`.
3. Run the retained proof and verification commands.
4. Record verification evidence under `sdd/03_verify`.
5. Notify Discord when a material state transition happens, if `DISCORD_WEBHOOK_URL` is configured.

## Acceptance

- [ ] GitHub project and issue are linked.
- [ ] SDD plan and verification records exist.
- [ ] Agentic Dev contract exists and points at real repo commands.
- [ ] Discord webhook configuration is documented or tested.
