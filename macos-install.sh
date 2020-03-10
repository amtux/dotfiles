#!/bin/sh
set -ex

if ! [ "$(command -v brew)" ]; then
    echo "'brew' is not installed. install it first."
    exit 1
fi

RUN_PATH="`dirname \"$0\"`"


#echo ">upgrade existing brew packaages"
#brew update || brew update
#brew upgrade

echo "> make sure xcode is upto date"
xcode-select --install

echo "> start with some cool utils and apps"
brew install jq \
  htop \
  watch \
  exa \
  ripgrep \
  gnupg \
  imagemagick \
  golang \
  helm \
  nodejs \
  gnu-sed \
  gcc \
  telnet \
  docker-compose \
  kubectx

brew tap homebrew/cask-versions

brew cask install google-cloud-sdk \
  discord \
  vlc \
  windscribe \
  1password \
  docker \
  balenaetcher \
  firefox-developer-edition

gcloud components install --quiet kubectl

# install font
echo "> font"
brew tap homebrew/cask-fonts
brew cask install font-iosevka-nerd-font


echo "> alacritty"
mkdir -p ~/.config
ln -s $PWD/$RUN_PATH/alacritty ~/.config/alacritty
brew cask install alacritty


echo "> zsh" 
brew install getantibody/tap/antibody
antibody bundle < ./zsh/zsh-plugins.txt > ~/.zsh-plugins.sh
touch ~/.hushlogin
echo "manually do chsh -s $(which zsh)"
rm -rf ~/.zshrc
ln -s $PWD/$RUN_PATH/zsh/zshrc ~/.zshrc


echo "> tmux"
ln -s $PWD/$RUN_PATH/tmux/.tmux.conf ~/.tmux.conf
brew install tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm


echo "> nvim"
ln -s $PWD/$RUN_PATH/nvim ~/.config/nvim
brew install neovim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


echo "> setting up fzf"
# install fzf
brew install fzf
/usr/local/opt/fzf/install --no-fish --no-bash --all


echo "> diff-so-fancy"
brew install diff-so-fancy
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
git config --global color.ui true

git config --global color.diff-highlight.oldNormal    "red bold"
git config --global color.diff-highlight.oldHighlight "red bold 52"
git config --global color.diff-highlight.newNormal    "green bold"
git config --global color.diff-highlight.newHighlight "green bold 22"

git config --global color.diff.meta       "11"
git config --global color.diff.frag       "magenta bold"
git config --global color.diff.commit     "yellow bold"
git config --global color.diff.old        "red bold"
git config --global color.diff.new        "green bold"
git config --global color.diff.whitespace "red reverse"


chsh -s $(which zsh) || echo "failed to switch to zsh - DIY"
echo "> done"
