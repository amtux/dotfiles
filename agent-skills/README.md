# agent-skills

Portable [Agent Skills](https://agentskills.io) for Claude Code, Pi, and Oh My Pi (OMP). `stow agent-skills` links each skill into `~/.agents/skills` (read by Pi and OMP) and `~/.claude/skills` (Claude Code), one link per skill, so other skills in those directories are left alone.

In Pi and OMP, invoke a skill explicitly with `/skill:<name>`; in Claude Code with `/<name>`. Refresh Pi with `/reload` and restart other agents after adding a skill.

To add a skill, create `.agents/skills/<name>/SKILL.md` here, add a relative link `.claude/skills/<name> -> ../../.agents/skills/<name>`, and restow.

## Skills

| Skill | Purpose |
|---|---|
| `debugging-and-error-recovery` | Reproduce with a failing test before fixing; rerun the same test afterward. |
| `spec-driven-development` | Agree on medium-to-large work before implementation, with staged decisions, safety contracts, and verifiable acceptance criteria. |
| `test-driven-development` | Implement and change behaviour through focused failing tests; test the contract at the boundary that matters. |
| `code-review-and-quality` | Review a change on request: evidence-backed, severity-ranked findings checked against the repo's documented rules; no invented issues. |
| `code-simplification` | Simplify working code on request without changing behaviour; pin untested behaviour first, and leave clear code alone. |
| `security-and-hardening` | Threat-model trust boundaries, audit or harden code, and prove fixes with abuse-case tests. |
| `source-driven-development` | Check version-sensitive and internal API use against the pinned version's own source or official docs. |
| `observability-and-instrumentation` | Add logs, metrics, traces, and alerts that answer on-call questions, with bounded cardinality, no secrets, and tested telemetry. |
| `interview-me` | When asked to be grilled first: ground in the code, ask one question at a time with a guess, confirm a restate, then stop. |

## Credit

These skills were inspired by, and benchmarked against, [Addy Osmani's agent-skills](https://github.com/addyosmani/agent-skills).
