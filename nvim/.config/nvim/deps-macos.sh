#!/usr/bin/env bash
set -euo pipefail

echo "=== Neovim external dependencies ==="

require() {
    command -v "$1" >/dev/null 2>&1 || {
        echo "error: '$1' not found — install it first ($2)" >&2
        exit 1
    }
}

require brew "https://brew.sh"
require go "brew install go"
require npm "brew install node"
require rustup "https://rustup.rs"
require jq "brew install jq"

echo "--- tree-sitter-cli ---"
brew install tree-sitter

echo "--- LSP servers ---"
brew install \
    lua-language-server \
    yaml-language-server \
    bash-language-server \
    helm-ls \
    vscode-langservers-extracted \
    cue
go install golang.org/x/tools/gopls@latest
rustup component add rust-analyzer

echo "--- Formatters ---"
brew install stylua shfmt
npm install -g prettier
go install mvdan.cc/gofumpt@latest
rustup component add rustfmt

echo "=== Done ==="
