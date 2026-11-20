---
name: interview-me
description: Interview the user, one question at a time, to pin down what they actually want before planning or building. Use when the user asks to be interviewed, grilled, or questioned first ("interview me", "grill me", "ask me questions before you start", "stress-test this"); not for clear requests, and not a substitute for writing a spec.
---

# Interview me

Reach a confirmed, shared understanding of what the user wants with as few of their turns as possible, then stop before planning or building. The understanding covers the outcome, who it is for and why now, what success looks like, the binding constraints, and what is explicitly out of scope.

## Prepare before asking

Read the request, the earlier conversation, and the relevant code and documentation first. Never ask what the repository or earlier messages already answer; state those findings as facts instead. Write a one-sentence hypothesis of what the user wants, a confidence level with what is still unresolved, and a short list of open questions ordered by how much each answer would change the work.

## Ask

- Ask one question per turn: the most consequential open one, with your best guess, the reasoning behind it, and a recommendation where you have one. Prefer concrete choices over abstract prompts.
- Show the remaining open items briefly, so the user can answer several at once if they choose. Fold in whatever they answer and do not re-ask it.
- When an answer sounds like what one should want ("scalable", "best practice", "intuitive") rather than a specific outcome, translate it into a concrete proposal and ask them to confirm it.
- When the user delegates ("use your judgement"), propose a specific default, record it as an assumption, and move on rather than stalling.
- Update the hypothesis and confidence each turn. If confidence stops rising after a few turns, say what seems foundationally missing.

## Restate and confirm

When you can predict the user's answers to your next few questions, restate the result briefly, in their language: outcome, scope (in and explicitly out), success criteria, constraints, the defaults you chose, and remaining risks. Ask for an explicit yes or corrections. A vague "sounds good" counts only if the restate was concrete; otherwise ask what they would refine.

## Stop

On confirmation, give the final restate and offer next steps (implement, write a spec, save it to a file), then stop. Do not implement, write files, or take other actions until the user asks. In a non-interactive run, list the open questions as blockers instead of interviewing.
