alias gl='git pull --prune'
alias glg="git log --graph --decorate --oneline --abbrev-commit"
alias gp='git push origin HEAD'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch -v'
alias ga='git add'
alias gcm='git commit -m'
alias gs='git status -sb'

function gi --description 'Adds a Gitignore for language'
    curl -s "https://www.gitignore.io/api/$argv"
end
