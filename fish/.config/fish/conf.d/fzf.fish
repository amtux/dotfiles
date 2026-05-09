status is-interactive; or exit 0
type -q fzf; or exit 0

set -l fzf_bindings /opt/homebrew/opt/fzf/shell/key-bindings.fish
test -r $fzf_bindings; or exit 0

if type -q rg
    set -gx FZF_CTRL_T_COMMAND 'rg --files --hidden --follow --glob "!.git"'
    set -gx FZF_DEFAULT_COMMAND $FZF_CTRL_T_COMMAND
end

source $fzf_bindings
fzf_key_bindings
