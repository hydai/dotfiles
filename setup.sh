#!/usr/bin/env bash

git clone https://github.com/hydai/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
git remote set-url --push origin git@github.com:hydai/dotfiles.git
./install
