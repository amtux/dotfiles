# pi-usage

On-demand provider account reports, separate from `pi-statusbar`.

## Commands

- `/usage-openai-sub`: show ChatGPT/OpenAI Codex subscription limits (5-hour and weekly), percentage remaining, and reset countdowns in a local dialog. Enter or Escape closes it.

Run `/reload` after installing or editing. The named provider is used regardless of the current model.
Sign in to **OpenAI Codex** using `/login` first; an OpenAI API key is not a ChatGPT subscription login.

## Behaviour and security

- No polling, background timers, persistent cache, new dependencies, or separate credential storage.
- Pi resolves the existing `openai-codex` login and handles OAuth refresh.
- One read-only GET per invocation to `https://chatgpt.com/backend-api/wham/usage`.
- Requests time out after 15 seconds and refuse redirects; credentials go only to the fixed OpenAI endpoint.
- Validate the returned windows before displaying them. Missing data is unavailable, never assumed to mean 100% remaining.
- Reports are local UI dialogs, not transcript messages or model context. Errors do not include credentials or raw server bodies.
- Reset countdowns are a snapshot taken when the request completes; reopening the command refreshes them.
- This is an internal endpoint used by [OpenAI's Codex CLI](https://github.com/openai/codex/blob/main/codex-rs/backend-client/src/client/rate_limit_resets.rs), not a guaranteed public API. It may change.

## Structure

`index.ts` registers commands and presents results. `openai.ts` owns OpenAI's request, response validation, and report formatting.

For future OpenRouter support, verify its credits endpoint, add `openrouter.ts`, and register `/usage-openrouter` in `index.ts`.
Keep authentication and formatting provider-specific: credits and subscription rate-limit windows are different concepts.
Do not add a generic provider framework or a placeholder command before another provider is implemented.

## Tests

With a recent Node supporting TypeScript stripping (Node 26 is installed):

```sh
node --test ~/.pi/agent/extensions/pi-usage/*.test.mjs
```

Tests use synthetic credentials and stubbed requests. They do not read real credentials or call external services.

To remove, move this directory outside `~/.pi/agent/extensions/` and run `/reload`.
