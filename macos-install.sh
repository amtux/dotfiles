#!/bin/sh
set -ex

if ! [ "$(command -v brew)" ]; then
    echo "'brew' is not installed. install it first."
    exit 1
fi

RUN_PATH="`dirname \"$0\"`"

echo "> setting up ruby env"
brew install rbenv

echo "> setting up exa - better 'ls' tool"
brew install exa

# install vim
echo "> setting up vim"
brew install vim
rm -rf ~/.vim
ln -s $PWD/$RUN_PATH/vim ~/.vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall

# install fira font
echo ">setting up fonts"
brew tap caskroom/fonts
brew cask install font-fira-code

# install iterm2
echo "> setting up iterm"
brew cask install iterm2

echo "> setting up fzf"
# install fzf
brew install fzf
/usr/local/opt/fzf/install --no-fish --no-bash --all

# install zsh
echo "> setting up zsh"
brew install zsh
brew install getantibody/tap/antibody
# zsh plugins gen statically using antibody
antibody bundle < ./zsh/zsh_plugins.txt > ~/.zsh_plugins.sh
touch ~/.hushlogin
chsh -s $(which zsh)
rm -rf ~/.zshrc
ln -s $PWD/$RUN_PATH/zsh/zshrc ~/.zshrc

# install tmuxtmux
echo "> setting up tmux"
brew install tmux

echo "> finishing up with some cool utils"
brew install jq \
             htop \
             watch

echo "> done"
