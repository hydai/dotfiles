#!/usr/bin/env bash

# Detect OS and install dependencies
case `uname` in
  Linux)
    # Check if running on WSL
    if grep -qEi "(Microsoft|WSL)" /proc/version 2>/dev/null; then
      echo "Detected WSL (Windows Subsystem for Linux)"
    fi

    # Install dependencies based on package manager
    if command -v apt > /dev/null; then
      echo "Installing dependencies using apt..."
      sudo apt update
      sudo apt install -y vim git zsh build-essential cmake tmux curl
    elif command -v yum > /dev/null; then
      echo "Installing dependencies using yum..."
      sudo yum install -y vim git zsh gcc gcc-c++ make cmake tmux curl
    elif command -v dnf > /dev/null; then
      echo "Installing dependencies using dnf..."
      sudo dnf install -y vim git zsh gcc gcc-c++ make cmake tmux curl
    elif command -v pacman > /dev/null; then
      echo "Installing dependencies using pacman..."
      sudo pacman -Sy --noconfirm vim git zsh base-devel cmake tmux curl
    else
      echo "No supported package manager found. Please install dependencies manually."
    fi
  ;;
  Darwin)
    echo "Detected macOS"
    # Check if Homebrew is installed
    if ! command -v brew > /dev/null; then
      echo "Homebrew not found. Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    echo "Installing dependencies using Homebrew..."
    brew install vim git zsh cmake tmux curl
  ;;
  FreeBSD)
    echo "Detected FreeBSD"
    echo "Installing dependencies using pkg..."
    sudo pkg update
    sudo pkg install -y vim git zsh cmake tmux curl
  ;;
  *)
    echo "Unknown operating system: $(uname)"
    echo "Please install the following dependencies manually:"
    echo "  - vim, git, zsh, build tools, cmake, tmux, curl"
  ;;
esac

git clone https://github.com/hydai/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
git submodule update --init --recursive
git remote set-url --push origin git@github.com:hydai/dotfiles.git
./install
