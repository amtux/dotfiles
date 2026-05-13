status is-interactive; or exit 0
type -q fzf; or exit 0

set -l fzf_bindings /opt/homebrew/opt/fzf/shell/key-bindings.fish
test -r $fzf_bindings; or exit 0

if type -q rg
    set -gx FZF_CTRL_T_COMMAND 'rg --files --hidden --follow --glob "!.git"'
    set -gx FZF_DEFAULT_COMMAND $FZF_CTRL_T_COMMAND
end

# Ctrl-T: show a syntax-highlighted file preview of the hovered candidate
if type -q bat
    set -gx FZF_CTRL_T_OPTS "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
end

# Alt-C: show a directory tree preview of the hovered candidate
if type -q eza
    set -gx FZF_ALT_C_OPTS "--preview 'eza --tree --color=always {} | head -200'"
end

# Catppuccin Mocha — https://github.com/catppuccin/fzf
set -gx FZF_DEFAULT_OPTS "\
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

source $fzf_bindings
fzf_key_bindings
