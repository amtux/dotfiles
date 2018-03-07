# dotfiles
setup for macos iterm2, zsh, tmux, neovim

Inspired by https://wrotenwrites.com/a_modern_terminal_workflow_1/

Pre-requisites to install script:
- install xcode and xcode command line tools: `xcode-select --install`
- install brew: `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
- upgrade pip3 if needed: `pip3 install --upgrade pip3`
- echo result of `which zsh` to /etc/shells if not already there

```bash
$ git clone https://github.com/amtux/dotfiles.git ~/dotfiles
$ git clone https://github.com/tmux-plugins/tpm ~/dotfiles/tpm
$ cd ~/dotfiles
$ ./init.sh
```
Post-install:
- Log out and log back in with zsh to install antigen and it's plugins
- Start up tmux and do `prefix + I` to install tpm plugins