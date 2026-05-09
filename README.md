# dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level
directory is a Stow package that mirrors the path under `$HOME`.

## Install

```sh
brew install stow  # or apt / dnf / pacman
git clone https://github.com/amtux/dotfiles ~/dotfiles
cd ~/dotfiles
stow fish nvim ghostty
```

That creates symlinks:

```
~/.config/fish     -> ~/dotfiles/fish/.config/fish
~/.config/nvim     -> ~/dotfiles/nvim/.config/nvim
~/.config/ghostty  -> ~/dotfiles/ghostty/.config/ghostty
```

Install packages selectively if you only want one (`stow fish`).
