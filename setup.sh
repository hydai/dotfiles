#!/usr/bin/env bash

case `uname` in
  Linux)
    sudo -H apt update
    sudo -H apt install vim git zsh build-essential cmake tmux
  ;;
esac

git clone https://github.com/hydai/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
git submodule update --init --recursive
git remote set-url --push origin git@github.com:hydai/dotfiles.git
./install
