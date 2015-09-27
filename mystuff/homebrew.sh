#!/usr/bin/env bash

cwd=$(pwd)
source $cwd/config.sh

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
echo "Setting homebrew cask path to /Applications"
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Make sure we’re using the latest Homebrew.
echo "Checking if we use newest homebrew"
brew update

brew upgrade --all

# taps
#tap=$(<$cwd/tap.sh)
# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "Tapping now varios things"

let counter=1
total=${#taps[@]}
for i in "${taps[@]}"; do
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Tapping $i - $counter/$total"
    brew tap $i
    ((counter++))
done


let counter=1
total=${#binaries[@]}
echo "installing binaries"
for i in "${binaries[@]}"; do
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> (Binary) Installling $i - $counter/$total"
    brew install $i
    ((counter++))
done

let counter=1
total=${#apps[@]}
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
echo "installing apps"
for i in "${apps[@]}"; do
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> (App) Installling $i - $counter/$total"
    brew cask $i
    ((counter++))
done

let counter=1
total=${#otherTasks[@]}
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
echo "doing other things"
for i in "${otherTasks[@]}"; do
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> (doing other things) $i - $counter/$total"
    eval $i
    ((counter++))
done

echo "clean up"
brew cleanup
echo "just checking"
brew doctor
echo "done"