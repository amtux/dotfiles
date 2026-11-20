# dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level
directory is a Stow package that mirrors the path under `$HOME`.

## Install

Fresh machine bootstrap (installs all tools, stows everything, sets fish as
login shell, runs Neovim dep install):

```sh
git clone https://github.com/amtux/dotfiles ~/dotfiles
cd ~/dotfiles
./install-macos.sh    # macOS
./install-arch.sh     # Arch / Omarchy
```

Or manually, if you only want the symlinks:

```sh
brew install stow  # or: sudo pacman -S stow
cd ~/dotfiles
stow agent-skills bat fish ghostty git k9s lazygit nvim skhd
stow --no-folding --target="$HOME" pi
```

Install packages selectively (`stow fish`) if you only want one.

## Packages

| Package | Target |
|---|---|
| `agent-skills` | `~/.agents/skills`, `~/.claude/skills` (one link per skill; see [agent-skills/README.md](agent-skills/README.md)) |
| `bat`     | `~/.config/bat` |
| `fish`    | `~/.config/fish` |
| `ghostty` | `~/.config/ghostty` |
| `git`     | `~/.config/git` |
| `k9s`     | `~/.config/k9s` |
| `lazygit` | `~/.config/lazygit` |
| `nvim`    | `~/.config/nvim` |
| `skhd`    | `~/.config/skhd` |
| `pi`      | Individual files under `~/.pi/agent/extensions` and `~/.pi/agent/themes` (use `--no-folding`; see [pi/README.md](pi/README.md)) |

## Machine-local files

A few files are gitignored because they hold identity or per-machine state.
Copy them manually when moving to a new machine:

- `fish/.config/fish/local.fish` — machine-local fish config
- `git/.config/git/config.local` — personal identity + work routing
- `git/.config/git/config.work` — work-specific config
- Pi authentication, settings, model config, sessions, and caches remain outside the repo; only extensions/themes are managed.
