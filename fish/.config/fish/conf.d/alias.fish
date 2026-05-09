alias cp="cp -i" # Confirm before overwriting something
alias k="kubectl"
alias kctx="kubectx"
alias kns="kubens"
if type -q eza
    alias ls="eza -lha"
end
alias v="nvim"
alias yt-playlist="yt-dlp -f140 -x --embed-thumbnail --add-metadata"
alias yt-audio="yt-dlp -f140 --extract-audio --add-metadata --embed-thumbnail"
alias yt-opus="yt-dlp -f 'bestaudio' --extract-audio --embed-thumbnail --add-metadata"
alias yt-hq-audio="yt-dlp --extract-audio --audio-quality=0 -f ba --add-metadata --embed-thumbnail"
