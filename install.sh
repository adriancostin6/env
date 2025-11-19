#!/usr/bin/env bash

# Create if it does not exist, we will symlink binaries into here.
mkdir -p "$HOME/.local/bin"

ENV_REPO_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )"
export ENV_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.local/share}/env"
if [ -f "$ENV_CACHE_DIR/setup.lock" ]; then
  printf "env: already setup, Exiting.\n"
  exit 1
fi
mkdir -p "$ENV_CACHE_DIR"

ENV_PREFIX="$HOME"
PATH="$ENV_REPO_DIR/external/linux:$PATH"


mkdir -p "$ENV_PREFIX/apps"
mkdir -p "$ENV_PREFIX/repos"

append_to_bashrc() {
  if ! grep -q "$1" "$HOME/.bashrc"; then
    printf "$1\n" >> "$HOME/.bashrc"
  fi
}
append_to_bashrc "ENV_PREFIX=\"$ENV_PREFIX\""
append_to_bashrc "ENV_REPO_DIR=\"$ENV_REPO_DIR\""
append_to_bashrc ". \"$HOME/.bashrc.$(whoami)\""

ln -s "$ENV_REPO_DIR/configurations/bash/.bashrc" "$HOME/.bashrc.$(whoami)"

# Setup is done
touch "$ENV_CACHE_DIR/setup.lock"
