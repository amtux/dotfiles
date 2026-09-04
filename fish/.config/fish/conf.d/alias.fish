# Written as a function (not `alias`) because `alias cp="command cp -i"`
# auto-wraps the literal body string instead of `cp`, which breaks tab
# completion. `--wraps cp` reuses cp's real completions.
function cp --wraps cp --description "cp with -i (confirm before overwrite)"
    command cp -i $argv
end
alias k="kubectl"
alias kctx="kubectx"
alias kns="kubens"
alias v="nvim"
alias yt-audio="yt-dlp --extract-audio --audio-quality=0 -f ba --add-metadata --embed-thumbnail"
