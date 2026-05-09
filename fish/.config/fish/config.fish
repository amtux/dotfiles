set -U fish_greeting

# Lazy-load pyenv — only initialize when python/pip/pyenv is actually invoked.
for cmd in pyenv python python3 pip pip3
    function $cmd --inherit-variable cmd
        functions -e pyenv python python3 pip pip3
        pyenv init - fish --no-rehash | source
        $cmd $argv
    end
end

# Machine-local config (not checked in). Sourced if present.
test -f $__fish_config_dir/local.fish && source $__fish_config_dir/local.fish
