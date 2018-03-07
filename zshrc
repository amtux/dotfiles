precmd() { print "" }

# set history
export HISTFILE=~/.zhistory
export HISTSIZE=10000
export SAVEHIST=10000
setopt append_history
setopt extended_history
setopt inc_append_history

# Auto CD
setopt auto_cd

# Typo Correction
setopt correctall
alias git status='nocorrect git status'

# Plugins
if [[ ! -f ~/antigen.zsh ]]; then
  curl -L git.io/antigen > ~/antigen.zsh
fi
source ~/antigen.zsh
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle git
antigen theme refined
antigen apply

alias vim="nvim"
alias ls="exa"
alias ll="exa -lha"

### Added by IBM Cloud CLI
source /usr/local/Bluemix/bx/zsh_autocomplete
