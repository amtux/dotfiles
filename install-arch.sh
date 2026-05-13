#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v pacman >/dev/null 2>&1; then
    echo "error: pacman not found — this script targets Arch Linux / Omarchy" >&2
    exit 1
fi

if ! command -v yay >/dev/null 2>&1; then
    echo "=== Installing yay (AUR helper) ==="
    sudo pacman -S --needed --noconfirm base-devel git
    tmp="$(mktemp -d)"
    git clone https://aur.archlinux.org/yay.git "$tmp/yay"
    (cd "$tmp/yay" && makepkg -si --noconfirm)
    rm -rf "$tmp"
fi

echo "=== CLI tools ==="
sudo pacman -S --needed --noconfirm \
    stow \
    fish \
    neovim \
    nodejs npm \
    go \
    pyenv \
    fzf \
    ripgrep \
    fd \
    eza \
    bat \
    jq \
    go-yq \
    yt-dlp \
    git-delta \
    lazygit \
    kubectl \
    kubectx \
    k9s \
    stern \
    ghostty

if ! command -v rustup >/dev/null 2>&1; then
    echo "=== Rust toolchain ==="
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

echo "=== Fish as login shell ==="
fish_path="$(command -v fish)"
if ! grep -qx "$fish_path" /etc/shells; then
    echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
fi
if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$fish_path" ]; then
    chsh -s "$fish_path"
fi

echo "=== Stow packages ==="
cd "$DOTFILES"
stow bat fish ghostty git k9s lazygit nvim

echo "=== Fisher plugins ==="
fish -c '
    if not functions -q fisher
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
        fisher install jorgebucaran/fisher
    end
    fisher update
'

echo "=== Neovim dependencies ==="
"$DOTFILES/nvim/.config/nvim/deps-arch.sh"

echo
echo "=== Done ==="
