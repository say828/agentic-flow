# SDD Development

Use the bundled SDD skill when a repository treats `sdd/` as the canonical delivery system or when the user asks for SDD-first planning, implementation, verification, deployment, or monitoring.

The canonical instructions are vendored unchanged at:

- `skill/SKILL.md`
- `skill/references/section-map.md`
- `skill/agents/openai.yaml`

When this plugin applies:

1. Read `skill/SKILL.md`.
2. Follow its SDD-first workflow.
3. Keep planning, build, verify, and operate records under the target repository's `sdd/` tree.
4. Use `skill/references/section-map.md` for destination paths when needed.
5. Do not create a parallel `docs/` tree in repositories that use `sdd/`.

Command surface:

- `/sdd:workflow` - print the SDD workflow and expected retained outputs.
