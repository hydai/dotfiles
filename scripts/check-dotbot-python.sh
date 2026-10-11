#!/usr/bin/env bash

set -euo pipefail

if command -v python3 >/dev/null 2>&1; then
  PYTHON_BIN="$(command -v python3)"
elif command -v python >/dev/null 2>&1; then
  PYTHON_BIN="$(command -v python)"
else
  echo "Python 3.7 or newer is required to run Dotbot, but no Python interpreter was found." >&2
  exit 1
fi

if ! "$PYTHON_BIN" -c 'import sys; raise SystemExit(sys.version_info < (3, 7))'; then
  PYTHON_VERSION="$("$PYTHON_BIN" --version 2>&1)"
  echo "Python 3.7 or newer is required to run Dotbot; found $PYTHON_VERSION at $PYTHON_BIN." >&2
  exit 1
fi
