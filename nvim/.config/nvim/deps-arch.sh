#!/usr/bin/env bash
set -euo pipefail

echo "=== Neovim external dependencies ==="

require() {
    command -v "$1" >/dev/null 2>&1 || {
        echo "error: '$1' not found — install it first ($2)" >&2
        exit 1
    }
}

require pacman "this script targets Arch Linux"
require yay "install yay first (see install-arch.sh)"
require go "sudo pacman -S go"
require npm "sudo pacman -S npm"
require rustup "https://rustup.rs"

echo "--- tree-sitter-cli ---"
sudo pacman -S --needed --noconfirm tree-sitter-cli

echo "--- LSP servers ---"
sudo pacman -S --needed --noconfirm \
    lua-language-server \
    yaml-language-server \
    bash-language-server \
    cue-lang
yay -S --needed --noconfirm helm-ls-bin
sudo npm install -g vscode-langservers-extracted
go install golang.org/x/tools/gopls@latest
rustup component add rust-analyzer

echo "--- Formatters ---"
sudo pacman -S --needed --noconfirm stylua shfmt
sudo npm install -g prettier
go install mvdan.cc/gofumpt@latest
rustup component add rustfmt

echo "=== Done ==="
