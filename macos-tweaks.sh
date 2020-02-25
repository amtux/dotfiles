#!/bin/sh

# credit to this medium article to help make mac suck less
# https://medium.com/@echohack/guide-to-make-your-mac-suck-less-2017-88a57563aac7

setu -eux

echo "Use 24-hour time. Use the format EEE MMM d  H:mm:ss"
defaults write com.apple.menuextra.clock DateFormat -string 'EEE MMM d  H:mm:ss'

echo "Disable press-and-hold for keys in favor of key repeat."
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

echo "Set a fast keyboard repeat rate, after a small initial delay."
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

echo "Disable auto-correct."
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false


echo "Disable press-and-hold for keys in favor of key repeat."
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

echo "Set a fast keyboard repeat rate, after a good initial delay."
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 20

echo "Disable auto-correct."
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

echo "Speed up mission control animations."
defaults write com.apple.dock expose-animation-duration -float 0.1

echo "Remove the auto-hiding dock delay."
defaults write com.apple.dock autohide-delay -int 0

echo "Use the dark theme."
defaults write ~/Library/Preferences/.GlobalPreferences AppleInterfaceStyle -string "Dark"

echo "Save screenshots in PNG format."
defaults write com.apple.screencapture type -string png

echo "Save screenshots to user screenshots directory instead of desktop."
mkdir ~/screenshots
defaults write com.apple.screencapture location -string ~/screenshots

echo "Disable menu transparency."
defaults write com.apple.universalaccess reduceTransparency -int 1

echo "Disable spotlight universal search (don't send info to Apple)."
defaults write com.apple.safari UniversalSearchEnabled -int 0

echo "Disable spotlight universal search (don't send info to Apple)."
defaults write com.apple.safari UniversalSearchEnabled -int 0
