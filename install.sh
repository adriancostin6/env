#!/usr/bin/env bash

ENV_USER=$(whoami)

ENV_REPO_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )"
source "$ENV_REPO_DIR/scripts/src/bash/log.sh"
logger_set_log_component "env installer"

ENV_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/env"
mkdir -p "$ENV_STATE_DIR"
log "starting environment installer." | tee -a "$ENV_STATE_DIR/env.log"


ENV_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.local/share}/env"
if [ -f "$ENV_CACHE_DIR/install.lock" ]; then
  die "already setup, exiting" | tee -a "$ENV_STATE_DIR/env.log"
fi
dbg "creating $ENV_CACHE_DIR" | tee -a "$ENV_STATE_DIR/env.log"
mkdir -p "$ENV_CACHE_DIR"

dbg "storing $ENV_REPO_DIR in $ENV_CACHE_DIR/repodir" | tee -a "$ENV_STATE_DIR/env.log"
printf "ENV_REPO_DIR=$ENV_REPO_DIR" > "$ENV_CACHE_DIR/repodir"

# Install tools
env_install() {
  dbg "running $1/install.sh" | tee -a "$ENV_STATE_DIR/env.log"
  pushd $1
  ./install.sh
  popd
}
env_install_in_new_shell() {
  dbg "running $1/install.sh" | tee -a "$ENV_STATE_DIR/env.log"
  pushd $1
  bash ./install.sh
  popd
}

REPO_CONFIG="$ENV_REPO_DIR/configurations"
#log "installing tools." | tee -a "$ENV_STATE_DIR/env.log"
#env_install "$REPO_CONFIG/configurations/rust"
#env_install_in_new_shell "$REPO_CONFIG/configurations/tools/bat"
#env_install_in_new_shell "$REPO_CONFIG/configurations/tools/cargo-update"
#env_install_in_new_shell "$REPO_CONFIG/configurations/tools/eza"
#env_install_in_new_shell "$REPO_CONFIG/configurations/tools/fd"
#env_install_in_new_shell "$REPO_CONFIG/configurations/tools/ripgrep"
#env_install_in_new_shell "$REPO_CONFIG/configurations/tools/yazi"
#env_install_in_new_shell "$REPO_CONFIG/configurations/tools/zellij"

log "checking installed tools." | tee -a "$ENV_STATE_DIR/env.log"
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
    wrn "please install $want" | tee -a "$ENV_STATE_DIR/env.log"
  fi
done

symlink() {
  dbg "linking $1 to $2" | tee -a "$ENV_STATE_DIR/env.log"
  ln -s "$1" "$2"
}
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
log "linking configuration files." | tee -a "$ENV_STATE_DIR/env.log"
symlink "$REPO_CONFIG/bat"          "$CONFIG/bat"
symlink "$REPO_CONFIG/git"          "$CONFIG/git"
symlink "$REPO_CONFIG/nvim"         "$CONFIG/nvim"
symlink "$REPO_CONFIG/wezterm"      "$CONFIG/wezterm"
symlink "$REPO_CONFIG/yazi"         "$CONFIG/yazi"
symlink "$REPO_CONFIG/zellij"       "$CONFIG/zellij"
symlink "$REPO_CONFIG/oh-my-posh"   "$CONFIG/oh-my-posh"
symlink "$REPO_CONFIG/bash/.bashrc" "$HOME/.bashrc.$ENV_USER.env"

append_to_bashrc() {
  local file="$1"
  local cmd="$2"

  if [ -z "$file" ]; then
    file="$HOME/.bashrc"
  fi

  if ! grep -q "$cmd" "$file"; then
    printf "$cmd\n" | tee -a "$file"
  fi
}
if [ -z "$1" ]; then
  log "appending env configuration to local .bashrc" | tee -a "$ENV_STATE_DIR/env.log"
  append_to_bashrc "" ". \"$HOME/.bashrc.$ENV_USER.env\""
else
 log "appending env configuration to local .bashrc.$ENV_USER" | tee -a "$ENV_STATE_DIR/env.log"
 append_to_bashrc "$HOME/.bashrc.$ENV_USER" ". \"$HOME/.bashrc.$ENV_USER.env\""
fi

log "setup done, creating lock file at $ENV_CACHE_DIR/install.lock" | tee -a "$ENV_STATE_DIR/env.log"
touch "$ENV_CACHE_DIR/install.lock"
