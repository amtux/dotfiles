---
name: spec-driven-development
description: Define and agree on medium-to-large changes before implementation. Use when requirements, design trade-offs, or scope need a reviewable specification; skip mechanical edits and small, unambiguous fixes.
---

# Spec-driven development

Make implementation easier by resolving consequential uncertainty before coding. Optimize for a correct, usable agreement, not the shortest skill or spec. Detail earns its place when it prevents a material implementation guess, exposes risk, or makes acceptance verifiable.

## 1. Establish the facts and the decision stage

Inspect relevant code, project instructions, existing specs, interfaces, and test/build commands. Reuse terminology and document conventions. Distinguish implemented behaviour from README claims, missing components, and proposed additions. Never invent an existing stack, interface, command, or verification result.

Identify the user's goal, affected users, constraints, compatibility needs, and explicit non-goals. Ask focused questions about choices the repository cannot answer. Clearly distinguish:

- **Confirmed:** supplied by the user or supported by inspected project evidence.
- **Proposed:** a recommendation with its trade-off, awaiting agreement.
- **Unresolved:** a question or missing dependency, including what work it blocks.

Choose the next useful artifact rather than defaulting to a comprehensive document:

- **Well-scoped change:** draft the feature specification directly.
- **Large or foundationally uncertain work:** first save a decision brief with scope, capability boundaries, interfaces at a responsibility level, dependencies/build order, consequential alternatives, and blocking questions. Ask for review and stop before elaborating dependent module specs or implementation details.

Do not repeat that gate when the relevant decisions are already approved. If the user explicitly requests a comprehensive exploratory draft, provide one with assumptions and blockers labeled; do not mistake that request for approval of its contents.

## 2. Resolve decisions before elaborating their consequences

Prioritize choices that change product behaviour, architecture, safety, compatibility, or substantial work. Explain the available options and recommend one; do not hand the user an unexplained questionnaire.

For example, duplicate prevention needs an agreed definition of transaction identity: identical values can represent separate legitimate purchases. A detailed matching algorithm cannot resolve that product decision.

Do not settle major choices silently, nor flesh out routes, schemas, parser grammar, or operational machinery that depends on unanswered foundational questions. Record enough detail to make the current decision understandable. Non-blocking details can be deferred explicitly with a condition for revisiting them.

## 3. Write the specification at the agreed level

Use the project's format and location; otherwise use `SPEC-<topic>.md`. Mark draft/approved status and make the next requested decision obvious near the beginning. Use sections or links to keep research and progress tracking distinct from the agreement; extra files are not mandatory.

Cover what this change needs:

- **Goal and scope:** outcomes, users, included behaviour, and non-goals.
- **Behaviour and contracts:** inputs, outputs, states, permissions, important edge cases, and representative examples. Distinguish required outcomes from suggested implementation mechanisms.
- **Approach and trade-offs:** boundaries, dependencies, compatibility, and the rationale for consequential choices. Decompose independently testable capabilities, not arbitrary files. For larger work, show dependencies and sensible build order without prematurely expanding every task into code.
- **Acceptance and verification:** observable scenarios covering success, failure, and preservation of existing behaviour. Identify the boundary each check must exercise, applicable project commands, and unavailable infrastructure. Planned tests are not evidence of tests already run.
- **Open decisions:** blocking questions, proposed defaults needing approval, and deliberately deferred details. Explain how each blocker affects implementation readiness.

Do not pad the spec with restated stack information, code-style examples, or generic checklists already established elsewhere. Conversely, do not omit necessary detail merely to shorten the document.

## 4. Check the failure and safety contract

Consider these where relevant; turn actual risks into explicit behaviour and acceptance criteria, not a pasted checklist:

- Invalid or hostile input; resource limits such as input size, record count, memory, timeout, and diagnostic volume. Establish justified bounds or flag them as unresolved blockers; do not dismiss them as out of scope when safe operation depends on them. Label any suggested numbers as proposals, not measured capacity.
- Data preservation and backward compatibility, including legacy records. Do not retroactively impose stricter new-input rules on existing data without an approved migration policy.
- Concurrency, retries, duplicate identity, and idempotency. Define conflicts and commit boundaries; distinguish failures before commit from uncertain outcomes afterward. Atomic replacement is not automatically lost-update protection or power-loss durability.
- Authorization, workspace/user isolation, secrets, and source/destination boundaries when reading or writing files, including aliases where relevant.
- External-service failures, recovery, migrations, rollout/rollback, and operational ownership when the feature actually requires them. Avoid guarantees the proposed mechanism cannot establish.

For critical invariants, specify how verification could detect their violation; a generic “tests pass” criterion is insufficient.

## 5. Review, agree, and hand off

Before presenting, check for contradictions, invented facts, unapproved scope expansion, hidden blockers, and decisions an implementer would still have to guess. Ensure critical requirements have concrete acceptance scenarios. Put the few decisions needed now ahead of supporting detail.

Present the artifact, recommendations, blockers, and requested approval; then stop. A saved draft or unanswered question is not approval to implement. After agreement, plan proportionate, verifiable increments without requiring approval for every routine step. Material discoveries that change scope or design require updating the spec and renewed agreement.

Specification approval does not authorize production changes, destructive operations, or broader work outside the agreed scope.
