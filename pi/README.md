# Pi extensions and themes

Only extension/theme source, tests, and documentation belong in this package. Skills are in the separate `agent-skills` package. Pi credentials, model configuration, settings, instructions, sessions, caches, and temporary files stay machine-local.

## Install

Install Pi separately; these resources were verified with `@earendil-works/pi-coding-agent` 1.5.2. Then:

```sh
cd ~/dotfiles
stow --no-folding --target="$HOME" pi
```

**Keep `--no-folding`.** On a fresh machine, ordinary directory folding can make `~/.pi` or `~/.pi/agent` a symlink into this repository, causing later logins/session writes to land here. No-folding creates real directories with individual resource-file symlinks instead.

Existing conflicting files are not overwritten. Back them up and compare them before replacing them; do not use `--adopt` to import an entire Pi installation.

Run `/reload` in an existing Pi session. Select a Tokyo Night theme through `/settings`; settings are intentionally not shared. Login separately through `/login`. Rex is optional, but needed to exercise Rex notification presentation.

## Contents

- `extensions/exit-alias.ts`: `/exit` alias.
- `extensions/pi-statusbar/`: footer and token-speed display.
- `extensions/pi-usage/`: on-demand OpenAI subscription usage using the local Pi login. No credentials are stored here.
- `extensions/pi-questions/`: blocking questions using Pi's native dialogs/status reporting.
- `themes/`: Tokyo Night Night, Storm, and Moon.

The paths above are under `.pi/agent/` in this package. New files added directly under `~/.pi` are not automatically added to dotfiles: create them in this package and restow.

## Tests

With a recent Node supporting TypeScript stripping (verified with Node 26), npm, and Pi installed globally:

```sh
cd ~/dotfiles
node --test pi/.pi/agent/extensions/*/*.test.mjs pi/.pi/agent/themes/*.test.mjs
```

Tests resolve the installed host package using `npm root -g`; there are no vendored dependencies. Some tests exercise Pi internals, so rerun them after Pi upgrades. Requests and credentials in tests are synthetic/stubbed.

## Remove

```sh
cd ~/dotfiles
stow --no-folding --target="$HOME" --delete pi
```

This removes managed links, not private Pi state. Run `/reload` afterward.
