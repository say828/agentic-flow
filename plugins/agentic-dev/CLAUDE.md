# Agentic Dev

Use the bundled Agentic Dev skill when setting up or running a full development flow that includes GitHub Projects/Issues, integrated SDD planning and verification, repo-local contract commands, Discord webhook notifications, deterministic proof gates, and repair loops.

The canonical instructions are vendored at:

- `skill/SKILL.md`
- `skill/references/section-map.md`
- `skill/scripts/init_agentic_dev.sh`
- `skill/assets/github-issue-template.md`
- `skill/assets/repo-contract.template.json`

When this plugin applies:

1. Read `skill/SKILL.md`.
2. For first-use setup, prefer `skill/scripts/init_agentic_dev.sh`.
3. Keep SDD planning, task plans, and verification records under the target repository's `sdd/` tree.
4. Do not create a parallel `docs/` tree when the target repository uses `sdd/`.
5. Do not commit real Discord webhook URLs.
6. Ask before creating GitHub Projects or Issues unless the user explicitly requested setup/onboarding.

Command surface:

- `/agentic-dev:init` - initialize the current repository into the Agentic Dev flow.
- `/agentic-dev:sdd-workflow` - print the integrated SDD workflow and expected retained outputs.
