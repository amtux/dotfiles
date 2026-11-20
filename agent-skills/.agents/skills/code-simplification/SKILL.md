---
name: code-simplification
description: Simplify working code for clarity while preserving its behaviour exactly. Use when asked to simplify, clean up, untangle, or make existing code easier to read, even when the code is pasted inline; not for adding features, fixing bugs, or changing behaviour.
---

# Code simplification

Make working code easier to understand and change without changing what it does. Simpler means fewer concepts a reader must hold, not fewer lines. Scale effort to the code's risk; leaving clear code alone is a valid outcome.

## Scope and understand first

Simplify what you were asked to, or the recent change if that is the request; note other opportunities instead of making drive-by edits. Keep simplification separate from feature or bug-fix work.

Before changing anything, establish what the code is responsible for, who calls it, and what its tests pin down. Read project instructions and neighbouring code, and follow their conventions rather than your own preferences. When something looks redundant, find out why it exists before removing it: a copy, ordering step, lock, nil check, or odd boundary is often load-bearing. Check history (`git log`/`blame`) when the reason is not evident. If you cannot establish that it is unnecessary, keep it.

## Preserve behaviour exactly

Treat every observable effect as part of the contract: return values, including nil versus empty and ordering of results and ties; errors, including which error wins when several apply; boundary inclusivity; side effects and their order; whether inputs are mutated; concurrency guarantees; and performance where it matters.

Existing tests often pin only a fraction of this. Before restructuring behaviour the tests do not cover, add characterization tests for it and confirm they pass against the original code. Do not change existing tests to make a simplification pass; if one has to change, the behaviour changed, so revert or explain and ask.

## Simplify in small, checked steps

Prefer changes that remove moving parts: guard clauses instead of deep nesting, one flow instead of duplicated branches, deleting dead code and pass-through wrappers, replacing a one-implementation abstraction or hand-rolled utility with the direct form or standard library, and names that say what a value is. Make one kind of change at a time and run the relevant tests after each; revert a step that does not clearly help.

Avoid the opposite failure: compressing code into clever one-liners, inlining a helper whose name explained a concept, merging unrelated logic, or reorganising code without reducing what a reader must track. Keep comments that explain why; delete comments that restate what the code does.

## Finish honestly

Run the relevant suite and checks (race detector, types, build, lint) after the final change, and compare the result with the original as a whole: if it is not clearly easier to follow, revert it. Do not commit unless asked.

Report what you simplified and why it is clearer, what you deliberately kept and why, the tests you added, what you ran, and anything you noticed outside scope. If the code was already clear, say so rather than churning it.
