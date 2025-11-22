#!/usr/bin/env bash

ENV_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.local/share}/env"
if [ -f "$ENV_CACHE_DIR/install.lock" ]; then
  printf "env: already setup, exiting.\n"
  exit 1
fi
mkdir -p "$ENV_CACHE_DIR"

ENV_STATE_DIR="${XDG_CACHE_HOME:-$HOME/.local/state}/env"
mkdir -p "$ENV_STATE_DIR"

log() {
  printf "[INFO]  $(date) env installer: $1\n"
}
dbg() {
  [ -n "$ENV_DEBUG" ] && printf "[DEBUG] $(date) env installer: $1\n"
}
wrn() {
  printf "[WARN]  $(date) env installer: $1\n"
}

ENV_REPO_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )"
printf "ENV_REPO_DIR=$ENV_REPO_DIR" > "$ENV_CACHE_DIR/repodir"

CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
REPO_CONFIG="$ENV_REPO_DIR/configurations"

# Install tools
env_install() {
  dbg "running $1/install.sh" >> "$ENV_STATE_DIR/env.log"
  pushd $1
  ./install.sh
  popd
}
env_install_in_new_shell() {
  dbg "running $1/install.sh" >> "$ENV_STATE_DIR/env.log"
  pushd $1
  bash ./install.sh
  popd
}

# Can we run all these in the background?
# We need to keep a log.
# TODO: we also need to take care of logging everything, if we plan to run in parallel
log "installing tools." >> "$ENV_STATE_DIR/env.log"
env_install "$REPO_CONFIG/configurations/rust"
env_install_in_new_shell "$REPO_CONFIG/configurations/tools/bat"
env_install_in_new_shell "$REPO_CONFIG/configurations/tools/cargo-update"
env_install_in_new_shell "$REPO_CONFIG/configurations/tools/eza"
env_install_in_new_shell "$REPO_CONFIG/configurations/tools/fd"
env_install_in_new_shell "$REPO_CONFIG/configurations/tools/ripgrep"
env_install_in_new_shell "$REPO_CONFIG/configurations/tools/yazi"
env_install_in_new_shell "$REPO_CONFIG/configurations/tools/zellij"

# Check installation

log "checking installed tools." >> "$ENV_STATE_DIR/env.log"
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
  if ! command -v "$want" &>/dev/null; then
    wrn "please install $want" >> "$ENV_STATE_DIR/env.log"
  fi
done

log "linking configuration files." >> "$ENV_STATE_DIR/env.log"
symlink() {
  dbg "linking $1 to $2" >> "$ENV_STATE_DIR/env.log"
  ln -s "$1" "$2"
}
symlink "$REPO_CONFIG/bat"          "$CONFIG/bat"
symlink "$REPO_CONFIG/git"          "$CONFIG/git"
symlink "$REPO_CONFIG/nvim"         "$CONFIG/nvim"
symlink "$REPO_CONFIG/wezterm"      "$CONFIG/wezterm"
symlink "$REPO_CONFIG/yazi"         "$CONFIG/yazi"
symlink "$REPO_CONFIG/zellij"       "$CONFIG/zellij"
symlink "$REPO_CONFIG/oh-my-posh"   "$CONFIG/oh-my-posh"
symlink "$REPO_CONFIG/bash/.bashrc" "$HOME/.bashrc.$(whoami)"

append_to_bashrc() {
  if ! grep -q "$1" "$HOME/.bashrc"; then
    printf "$1\n" >> "$HOME/.bashrc"
  fi
}
log "appending env configuration .bashrc to local .bashrc" >> "$ENV_STATE_DIR/env.log"
append_to_bashrc ". \"$HOME/.bashrc.$(whoami)\""

log "setup complete, creating lock file at $ENV_CACHE_DIR/install.lock" >> "$ENV_STATE_DIR/env.log"
touch "$ENV_CACHE_DIR/install.lock"
