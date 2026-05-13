#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v brew >/dev/null 2>&1; then
    echo "error: Homebrew not installed — see https://brew.sh" >&2
    exit 1
fi

echo "=== CLI tools ==="
brew install \
    stow \
    fish \
    neovim \
    node \
    go \
    pyenv \
    fzf \
    ripgrep \
    fd \
    eza \
    bat \
    jq \
    yq \
    yt-dlp \
    git-delta \
    lazygit \
    kubectl \
    kubectx \
    k9s \
    stern

echo "=== GUI apps ==="
brew install --cask ghostty

if ! command -v rustup >/dev/null 2>&1; then
    echo "=== Rust toolchain ==="
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

echo "=== Fish as login shell ==="
fish_path="$(command -v fish)"
if ! grep -qx "$fish_path" /etc/shells; then
    echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
fi
if [ "$(dscl . -read "/Users/$USER" UserShell | awk '{print $2}')" != "$fish_path" ]; then
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
"$DOTFILES/nvim/.config/nvim/deps-macos.sh"

echo
echo "=== Done ==="
