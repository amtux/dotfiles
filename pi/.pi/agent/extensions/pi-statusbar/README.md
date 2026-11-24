# pi-statusbar

Our custom Pi status bar: footer layout, usage stats, model details, and live token speed.
Replaces `npm:pi-token-speed` with a dependency-free local Pi extension (uses Pi's provided TUI utilities).
Auto-discovered through `index.ts`; activate changes with `/reload`.

The existing two footer rows remain:
- First row: working directory/branch/session on the left, `<speed> · <latency>` right-aligned.
- Second row: cache-hit percentage, cost, and context usage on the left, `(<provider>) <model> · <thinking>` right-aligned.
The `(auto)` label is hidden without changing automatic compaction settings.
Cumulative input/output and cache-read token counters are hidden; `/session` still provides token accounting. Cache-write counts remain visible when nonzero.
Speed, latency, and model details use dull grey. Only a numeric speed below 15 tok/s turns red, both live and final; exactly 15 stays grey. Waiting, unavailable speeds, and latency never trigger a colour warning. Existing context-usage warnings are unchanged.
Other extensions' status messages are preserved on their own status row if present. Narrow terminals truncate rather than wrap.

## Measurements

- Per model request, not per whole task. Tool execution is excluded; the next request resets the measurement.
- `waiting 1.2s`: time since the provider request hook (turn start is the fallback when unavailable).
- `1.2s` (shown after the first streamed content arrives): delay until the first nonempty text, thinking, or tool-argument delta. Not the time to the first answer text specifically.
- `~42.0 tok/s`: live running average since the first delta, estimated as streamed UTF-16 characters / 4. It is deliberately approximate, especially for non-English text and code. Updated every 250 ms while streaming.
- `42.0 tok/s`: final provider-reported output tokens / seconds from first delta to message completion. Remains visible until the next request. If usage is missing, the estimate retains its `~`.
- Intervals shorter than 100 ms show `— tok/s` to avoid meaningless spikes. If the request has finished and the provider reported output tokens, the count is shown instead (`13 tok`). This is common with Anthropic, which often delivers short replies in one or two chunks after a hidden thinking phase. Errors/aborts are labeled rather than presented as successful averages.
- Provider-reported output counts can include hidden reasoning, while the live estimate only sees streamed content. Thus the final number may jump, and cross-provider comparisons are not exact benchmarks. Automatic transport retries may also affect timing.

No network calls, tokenizers, settings menus, or persistent state are added. Reloading or switching sessions starts with no speed history.

## Tests

Requires a recent Node with TypeScript stripping (Node 26 is installed) and the globally installed Pi package:

```sh
node --test ~/.pi/agent/extensions/pi-statusbar/*.test.mjs
```

Tests use Pi's installed loader/TUI utilities without adding dependencies. `metrics.ts` owns timing and estimates;
`footer.ts` owns layout/usage formatting; `index.ts` wires Pi events and cleans up its refresh timer.

## Remove / roll back

Move this directory outside `~/.pi/agent/extensions/`, then run `/reload` to restore Pi's default footer.
To return to the old package, run `pi install npm:pi-token-speed` as well.
