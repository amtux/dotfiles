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
stow bat fish ghostty git k9s lazygit nvim skhd
```

Install packages selectively (`stow fish`) if you only want one.

## Packages

| Package | Target |
|---|---|
| `bat`     | `~/.config/bat` |
| `fish`    | `~/.config/fish` |
| `ghostty` | `~/.config/ghostty` |
| `git`     | `~/.config/git` |
| `k9s`     | `~/.config/k9s` |
| `lazygit` | `~/.config/lazygit` |
| `nvim`    | `~/.config/nvim` |
| `skhd`    | `~/.config/skhd` |

## Machine-local files

A few files are gitignored because they hold identity or per-machine state.
Copy them manually when moving to a new machine:

- `fish/.config/fish/local.fish` — machine-local fish config
- `git/.config/git/config.local` — personal identity + work routing
- `git/.config/git/config.work` — work-specific config
