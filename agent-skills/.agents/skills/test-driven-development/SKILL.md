---
name: test-driven-development
description: Develop new behavior and change existing behavior through focused failing tests, then implementation and refactoring. Use when implementing logic, fixing bugs, or adding behavioral test coverage; not for read-only review or edits with no behavioral impact.
---

# Test-driven development

Use tests to establish the intended behavior before changing implementation, then verify it at the boundary where it matters. A green suite is evidence within its coverage, not proof that every requirement works. Scale test scope to uncertainty and risk, not fixed test counts or coverage percentages.

## Establish the test and contract

Read project instructions, the relevant code and tests, and the agreed requirements. Discover the repository's actual focused-test, suite, build, and type-check commands from its configuration, documentation, and CI; do not assume a language or runner. Prefer checked-in wrappers and scripts (such as `make test`, `./gradlew`, or repository scripts) over globally installed tools. Reuse existing tooling and conventions. Check relevant existing tests when useful to distinguish baseline failures from regressions.

Choose one observable behavior and the smallest test that can meaningfully verify it. Resolve consequential ambiguity rather than encoding a guess as the expected result. Include relevant boundary values, failure paths, and invariants from the requirements, not just the happy path.

## Red → green → refactor

1. **Red:** Write or select a focused test before implementation changes. Run it and inspect the failure: it must expose the intended missing or incorrect behavior, not a malformed assertion, unrelated failure, or broken setup. For a new API, a compile or missing-symbol failure does not exercise the behavioral assertions: add a minimal stub with the agreed signature so the test fails on its assertions before you implement.
2. **Green:** Implement the behavior needed for that test without speculative features. Rerun the same test unchanged and confirm it passes. Do not hard-code the fixture when the contract requires general behavior. Add cases incrementally to expose meaningful gaps.
3. **Refactor:** With tests green, improve clarity without expanding scope or changing the contract. Rerun affected checks after changes. Keep this step proportionate; passing tests do not require a refactor.

**Bug fixes require reproducing the reported symptom against the original implementation before fixing it, followed by the same unchanged test passing.** If automated reproduction is blocked, explain why and agree on alternative verification with the user before applying a fix.

A characterization test for existing behavior can legitimately pass immediately. If a proposed new-behavior test already passes, inspect whether the behavior already exists or the test misses the requirement. Do not break correct code merely to manufacture red. For an unreproduced bug, a passing test does not satisfy the reproduction requirement.

If a test expectation is wrong, explain the evidence before correcting it. Re-establish the appropriate baseline before relying on the corrected test; do not quietly edit assertions after a fix to manufacture success.

## Make the evidence meaningful

- Assert observable results, errors, and relevant side effects rather than incidental private call sequences. Interaction assertions are appropriate when the interaction itself is the contract.
- Prefer real implementations or controlled local dependencies where practical. Use doubles for unsafe, unavailable, slow, or nondeterministic boundaries, and state what they leave unverified.
- Default to small, fast, in-process tests for logic. Match the claimed guarantee to the exercised boundary: mocked persistence cannot prove rollback, and an injected exception cannot prove recovery after process termination. Use integration or end-to-end checks when the risk requires them, and keep them to the critical paths; use the available browser tools for relevant UI behavior, not a mandatory vendor integration.
- Keep each test focused on one behavior, named for that behavior, and readable on its own; prefer some duplication over shared helpers that hide what a test checks. Keep tests isolated and deterministic. Control time, randomness, and concurrency where appropriate; clean up test-owned resources. Use disposable data, protect secrets, and obtain approval for production access, destructive operations, or new dependencies.

## Finish honestly

Run the relevant suite and applicable build/types checks after the final changes. Confirm the intended tests actually executed: a filter that matches nothing or a skipped package can look green. Investigate failures; never skip tests, weaken assertions, suppress errors, or introduce silent fallbacks to get green. Repeat checks when edits or an explicit investigation warrant it, not ritualistically.

Report what failed before implementation, what passed afterward, and remaining verification limits. Distinguish pre-existing failures from regressions and planned checks from executed ones. If the required test environment is unavailable, say so and agree on an alternative rather than claiming success.
