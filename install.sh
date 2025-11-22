#!/usr/bin/env bash

ENV_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.local/share}/env"
if [ -f "$ENV_CACHE_DIR/install.lock" ]; then
  printf "env: already setup, exiting.\n"
  exit 1
fi
mkdir -p "$ENV_CACHE_DIR"

ENV_REPO_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )"
printf "ENV_REPO_DIR=$ENV_REPO_DIR" > "$ENV_CACHE_DIR/repodir"

CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
REPO_CONFIG="$ENV_REPO_DIR/configurations"

# Install tools
env_install() {
  pushd $1
  ./install.sh
  popd
}
env_install_in_new_shell() {
  pushd $1
  bash ./install.sh
  popd
}

# Can we run all these in the background?
# We need to keep a log.
# TODO: we also need to take care of logging everything, if we plan to run in parallel
env_install "$REPO_CONFIG/configurations/rust"
env_install_in_new_shell "$REPO_CONFIG/configurations/tools/bat"
env_install_in_new_shell "$REPO_CONFIG/configurations/tools/cargo-update"
env_install_in_new_shell "$REPO_CONFIG/configurations/tools/eza"
env_install_in_new_shell "$REPO_CONFIG/configurations/tools/fd"
env_install_in_new_shell "$REPO_CONFIG/configurations/tools/ripgrep"
env_install_in_new_shell "$REPO_CONFIG/configurations/tools/yazi"
env_install_in_new_shell "$REPO_CONFIG/configurations/tools/zellij"

# Check installation
wants=(
  bat
  delta
  fd
  fzf
  nvim
  oh-my-posh
  rg
  wezterm
  yazi
  z
  zellij
)
RESET='\033[0m'
YELLOW='\033[93;1m'
for want in "${wants[@]}"
do
  command -v "$want" &>/dev/null || printf "${YELLOW}env: please install $want$RESET\n"
done

# Link configurations
ln -s "$REPO_CONFIG/bat"          "$CONFIG/bat"
ln -s "$REPO_CONFIG/git"          "$CONFIG/git"
ln -s "$REPO_CONFIG/nvim"         "$CONFIG/nvim"
ln -s "$REPO_CONFIG/wezterm"      "$CONFIG/wezterm"
ln -s "$REPO_CONFIG/yazi"         "$CONFIG/yazi"
ln -s "$REPO_CONFIG/zellij"       "$CONFIG/zellij"
ln -s "$REPO_CONFIG/oh-my-posh"   "$CONFIG/oh-my-posh"
ln -s "$REPO_CONFIG/bash/.bashrc" "$HOME/.bashrc.$(whoami)"

append_to_bashrc() {
  if ! grep -q "$1" "$HOME/.bashrc"; then
    printf "$1\n" >> "$HOME/.bashrc"
  fi
}
append_to_bashrc ". \"$HOME/.bashrc.$(whoami)\""

# Setup is done
touch "$ENV_CACHE_DIR/install.lock"
