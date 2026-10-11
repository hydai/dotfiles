#!/usr/bin/env bash

set -euo pipefail

ZUBAN_VERSION="0.10.0"
export UV_TOOL_BIN_DIR="$HOME/.local/bin"

has_universal_ctags() {
  local version

  command -v ctags >/dev/null 2>&1 || return 1
  version="$(ctags --version 2>/dev/null)" || return 1
  [[ "${version%%$'\n'*}" == "Universal Ctags"* ]]
}

has_clang_format() {
  command -v clang-format >/dev/null 2>&1
}

find_brew() {
  if command -v brew >/dev/null 2>&1; then
    command -v brew
  elif [[ -x /opt/homebrew/bin/brew ]]; then
    printf '%s\n' /opt/homebrew/bin/brew
  elif [[ -x /usr/local/bin/brew ]]; then
    printf '%s\n' /usr/local/bin/brew
  else
    return 1
  fi
}

install_universal_ctags() {
  if has_universal_ctags; then
    return
  fi

  case "$(uname -s)" in
    Darwin)
      local brew_bin
      local brew_prefix
      brew_bin="$(find_brew)" || {
        echo "Homebrew is required to install Universal Ctags on macOS." >&2
        exit 1
      }
      "$brew_bin" install universal-ctags
      brew_prefix="$("$brew_bin" --prefix)"
      export PATH="$brew_prefix/bin:$PATH"
      ;;
    Linux)
      if ! command -v apt-get >/dev/null 2>&1; then
        echo "apt-get is required to install Universal Ctags on Linux." >&2
        exit 1
      fi
      sudo -H apt-get update
      sudo -H apt-get install -y universal-ctags
      ;;
    *)
      echo "Unsupported operating system: $(uname -s)" >&2
      exit 1
      ;;
  esac

  if ! has_universal_ctags; then
    echo "Universal Ctags was installed but is not available as 'ctags'." >&2
    exit 1
  fi
}

install_clang_format() {
  if has_clang_format; then
    return
  fi

  case "$(uname -s)" in
    Darwin)
      local brew_bin
      local brew_prefix
      brew_bin="$(find_brew)" || {
        echo "Homebrew is required to install clang-format on macOS." >&2
        exit 1
      }
      "$brew_bin" install clang-format
      brew_prefix="$("$brew_bin" --prefix)"
      export PATH="$brew_prefix/bin:$PATH"
      ;;
    Linux)
      if ! command -v apt-get >/dev/null 2>&1; then
        echo "apt-get is required to install clang-format on Linux." >&2
        exit 1
      fi
      sudo -H apt-get update
      sudo -H apt-get install -y clang-format
      ;;
    *)
      echo "Unsupported operating system: $(uname -s)" >&2
      exit 1
      ;;
  esac

  if ! has_clang_format; then
    echo "clang-format was installed but is not available on PATH." >&2
    exit 1
  fi
}

install_uv() {
  if command -v uv >/dev/null 2>&1; then
    command -v uv
    return
  fi

  if [[ -x "$HOME/.local/bin/uv" ]]; then
    printf '%s\n' "$HOME/.local/bin/uv"
    return
  fi

  if [[ "$(uname -s)" == "Darwin" ]]; then
    local brew_bin
    brew_bin="$(find_brew)" || {
      echo "Homebrew is required to install uv on macOS." >&2
      exit 1
    }
    "$brew_bin" install uv >&2
    printf '%s\n' "$("$brew_bin" --prefix)/bin/uv"
    return
  fi

  if ! command -v curl >/dev/null 2>&1; then
    echo "curl is required to install uv." >&2
    exit 1
  fi

  curl -LsSf https://astral.sh/uv/install.sh \
    | env UV_INSTALL_DIR="$HOME/.local/bin" UV_NO_MODIFY_PATH=1 sh >&2

  if [[ ! -x "$HOME/.local/bin/uv" ]]; then
    echo "uv installation did not create $HOME/.local/bin/uv." >&2
    exit 1
  fi

  printf '%s\n' "$HOME/.local/bin/uv"
}

install_zuban() {
  local uv_bin="$1"
  local tool_bin_dir
  local zuban_bin

  tool_bin_dir="$("$uv_bin" tool dir --bin)"
  zuban_bin="$tool_bin_dir/zuban"

  if [[ -x "$zuban_bin" ]] \
    && [[ "$("$zuban_bin" --version)" == "zuban $ZUBAN_VERSION" ]]; then
    return
  fi

  "$uv_bin" tool install --upgrade "zuban==$ZUBAN_VERSION"

  if [[ ! -x "$zuban_bin" ]]; then
    echo "Zuban was installed but $zuban_bin is missing." >&2
    exit 1
  fi
}

install_universal_ctags
install_clang_format
uv_bin="$(install_uv)"
install_zuban "$uv_bin"

ctags --version | sed -n '1p'
clang-format --version
"$("$uv_bin" tool dir --bin)/zuban" --version
