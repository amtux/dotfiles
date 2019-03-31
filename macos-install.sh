#!/bin/sh
set -ex

if ! [ "$(command -v brew)" ]; then
    echo "'brew' is not installed. install it first."
    exit 1
fi

RUN_PATH="`dirname \"$0\"`"

# install font
echo "> font"
brew tap homebrew/cask-fonts
brew cask install font-fantasque-sans-mono


echo "> vim"
brew install vim
rm -rf ~/.vim
ln -s $PWD/$RUN_PATH/vim ~/.vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
#vim +PlugInstall +qall


echo "> exa, rbenv"
brew install exa rbenv


echo "> tmux"
brew install tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm



echo "> zsh" 
brew install zsh
brew install getantibody/tap/antibody
# zsh plugins gen statically using antibody
antibody bundle < ./zsh/zsh_plugins.txt > ~/.zsh_plugins.sh
touch ~/.hushlogin
chsh -s $(which zsh)
rm -rf ~/.zshrc
ln -s $PWD/$RUN_PATH/zsh/zshrc ~/.zshrc


echo "> setting up fzf"
# install fzf
brew install fzf
/usr/local/opt/fzf/install --no-fish --no-bash --all


echo "> finishing up with some cool utils"
brew install jq \
             htop \
             watch


echo "> done"
echo "configure vim with: `vim +PlugInstall +qall`"
echo "configure tmux with `prefix + I`
