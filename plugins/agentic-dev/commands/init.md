---
description: Initialize the current repository into the Agentic Dev flow
---

# agentic-dev:init

Initialize the current repository into the Agentic Dev flow.

## Instructions

1. Read `skill/SKILL.md`.
2. Run the setup script from the repository root:

   ```bash
   skill/scripts/init_agentic_dev.sh "task or product name" "$PWD" --github --project-title "Agentic Dev"
   ```

3. Use `--send-discord-test` only when `DISCORD_WEBHOOK_URL` is set.
4. If GitHub side effects are not desired, omit `--github`.
5. After setup, inspect `.agentic-dev/onboarding.json`, `sdd/02_plan`, and `sdd/03_verify`.
