#!/usr/bin/env bash

ENV_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.local/share}/env"
if [ ! -f "$ENV_CACHE_DIR/install.lock" ]; then
  printf "env: already clean, exiting.\n"
  exit 1
fi
rm -rf "$ENV_CACHE_DIR"

env_uninstall() {
  pushd $1
  bash ./uninstall.sh
  popd
}

env_uninstall "$REPO_CONFIG/configurations/tools/bat"
env_uninstall "$REPO_CONFIG/configurations/tools/cargo-update"
env_uninstall "$REPO_CONFIG/configurations/tools/eza"
env_uninstall "$REPO_CONFIG/configurations/tools/fd"
env_uninstall "$REPO_CONFIG/configurations/tools/ripgrep"
env_uninstall "$REPO_CONFIG/configurations/tools/yazi"
env_uninstall "$REPO_CONFIG/configurations/tools/zellij"
env_uninstall "$REPO_CONFIG/configurations/rust"

CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
rm -f "$CONFIG/bat"
rm -f "$CONFIG/git"
rm -f "$CONFIG/nvim"
rm -f "$CONFIG/wezterm"
rm -f "$CONFIG/yazi"
rm -f "$CONFIG/zellij"
rm -f "$CONFIG/oh-my-posh"
rm -f "$HOME/.bashrc.$(whoami)"

sed -i "/.bashrc.$(whoami)/d" "$HOME/.bashrc"
