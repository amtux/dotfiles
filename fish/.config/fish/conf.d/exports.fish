set -gx K9S_CONFIG_DIR $HOME/.config/k9s
set -gx GOPATH $HOME/go
set -gx npm_config_prefix $HOME/.local

fish_add_path --path \
    /opt/homebrew/bin \
    $HOME/.local/bin \
    $HOME/.krew/bin \
    /usr/local/go/bin \
    $GOPATH/bin \
    $HOME/.cargo/bin
