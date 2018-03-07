#!/bin/bash

echo "> installing dependencies and apps"
brew install zsh tmux neovim/neovim/neovim python3 ag
brew tap caskroom/cask

echo "> install neovim"
pip3 install neovim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "> installing fonts"
brew tap caskroom/fonts
brew cask install font-hack

echo "> setting default shell to zsh and remove 'Last login' prompt"
touch .hushlogin
chsh -s $(which zsh)

echo "> deleting existing configs and symlinking new ones"
rm -rf ~/.vim ~/.vimrc ~/.zshrc ~/.tmux ~/.tmux.conf ~/.config/nvim 2> /dev/null
mkdir -p ~/.config ~/.config/nvim
ln -s ~/dotfiles/zshrc ~/.zshrc
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/vimrc ~/.config/nvim/init.vim

echo "> remember to logout and log back in!"
