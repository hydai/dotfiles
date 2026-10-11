#!/usr/bin/env bash

set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

if [[ -e "$DOTFILES_DIR" ]]; then
  echo "Dotfiles destination already exists: $DOTFILES_DIR" >&2
  exit 1
fi

"${BASEDIR}/scripts/check-dotbot-python.sh"

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
      clang-format \
      cmake \
      curl \
      gh \
      git \
      git-delta \
      git-lfs \
      gnupg \
      screen \
      tmux \
      universal-ctags \
      vim \
      zsh
    ;;
  Darwin)
    if command -v brew >/dev/null 2>&1; then
      brew_bin="$(command -v brew)"
    elif [[ -x /opt/homebrew/bin/brew ]]; then
      brew_bin=/opt/homebrew/bin/brew
    elif [[ -x /usr/local/bin/brew ]]; then
      brew_bin=/usr/local/bin/brew
    else
      echo "Homebrew is required on macOS. Install it before running setup.sh." >&2
      exit 1
    fi

    "$brew_bin" install difftastic gh git-delta git-lfs tmux
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
