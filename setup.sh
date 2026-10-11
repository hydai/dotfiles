#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

if [[ -e "$DOTFILES_DIR" ]]; then
  echo "Dotfiles destination already exists: $DOTFILES_DIR" >&2
  exit 1
fi

case "$(uname -s)" in
  Linux)
    if ! command -v apt-get >/dev/null 2>&1; then
      echo "Unsupported Linux distribution: apt-get is required." >&2
      exit 1
    fi

    sudo -H apt-get update
    sudo -H apt-get install -y \
      build-essential \
      ca-certificates \
      cmake \
      curl \
      git \
      tmux \
      universal-ctags \
      vim \
      zsh
    ;;
  Darwin)
    if ! command -v brew >/dev/null 2>&1 \
      && [[ ! -x /opt/homebrew/bin/brew ]] \
      && [[ ! -x /usr/local/bin/brew ]]; then
      echo "Homebrew is required on macOS. Install it before running setup.sh." >&2
      exit 1
    fi
    ;;
  *)
    echo "Unsupported operating system: $(uname -s)" >&2
    exit 1
    ;;
esac

git clone https://github.com/hydai/dotfiles.git "$DOTFILES_DIR"
git -C "$DOTFILES_DIR" submodule update --init --recursive
git -C "$DOTFILES_DIR" remote set-url --push origin git@github.com:hydai/dotfiles.git
"$DOTFILES_DIR/install"
