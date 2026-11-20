# Pi questions / Rex notifications

Adds `ask_user`: an explicit blocking question tool with optional choices and a free-text alternative. Uses Pi's standard dialogs, so the existing native integration reports `blocked`, `kind=question`, and the question title to Rex. There is no second OSC emitter or notification service.

## Usage

Run `/reload` after installation. The agent should use `ask_user` when it genuinely needs your answer before continuing. The tool's prompt guidelines and global `AGENTS.md` document this convention.

For a manual notification test, run `/rex-question-test` and switch to another app within five seconds. A real question dialog then opens. Check that Rex distinguishes it from Done, includes the question text, and returns to the appropriate tab when clicked. Sounds and notification preferences remain controlled by Rex under Settings → Notifications → Program Activity.

## Contract

- A free-text question uses `ctx.ui.input`; optional choices use `ctx.ui.select` with an additional free-text option.
- Answers return to the model, limited to 8000 characters, and are recorded in the session as tool results. Do not use this for secrets.
- Question titles are single-line, control-character-free, and capped at 500 Unicode code points. Titles can appear in desktop notifications; use safe wording.
- Cancellation or an abort is not consent. A cancelled result requests termination of the tool batch. Pi only honors this when every result in the batch is terminating, so the agent is instructed to call this tool alone.
- Print/JSON modes fail explicitly rather than pretending an answer was supplied. RPC can use its standard dialog bridge; Rex terminal reporting applies only to interactive TUI mode.
- Normal working/done/error reporting stays native. Completion text stays at Pi's privacy-preserving default (session name), not an automatically extracted assistant summary.
- A question mark in ordinary assistant text does not mean the agent is blocked.

## Verification

```sh
node --test ~/.pi/agent/extensions/pi-questions/index.test.mjs
```

Tests cover dialog inputs/results, choices, cancellation, aborts, title sanitation, noninteractive behavior, the delayed test command, and transitions using the installed native reporter. UI adapters are simulated in tests; actual macOS banners, sound, and click routing require the manual test above.

Verified against the installed Pi 1.5.2 source:

- `dist/modes/interactive/interactive-mode.js`: extension input/select dialogs set a blocked question status using the dialog title.
- `dist/modes/interactive/program-status-reporter.js`: native working, blocked, done, error, and cancellation reporting; completion waits for `agent_settled`.
- `docs/extensions.md`: tool registration, sequential/model-only exposure, abort-aware dialogs, and cancellation result semantics.

Rex protocol: https://www.superlogical.com/rex/docs/build/program-status
