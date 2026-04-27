# sdd

SDD-first development workflow for Claude Code and Codex.

The plugin vendors the same SDD skill structure used by Codex:

- `skill/SKILL.md`
- `skill/references/section-map.md`
- `skill/agents/openai.yaml`

## Claude Code

```bash
/plugin marketplace add say828/agentic-dev
/plugin install sdd@agentic-dev
```

Use the plugin for repositories where `sdd/` is the canonical delivery record.

## Codex

```bash
curl -fsSL https://raw.githubusercontent.com/say828/agentic-dev/main/scripts/install.sh | bash -s -- --codex-only
```

The installer copies the Codex skill to:

```text
~/.codex/skills/sdd
```
