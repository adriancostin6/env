#!/usr/bin/env bash

ENV_USER=$(whoami)

ENV_REPO_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )"
source "$ENV_REPO_DIR/scripts/src/bash/log.sh"
logger_set_log_component "env uninstaller"

ENV_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/env"
log "starting uninstaller." | tee -a "$ENV_STATE_DIR/env.log"
ENV_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.local/share}/env"
if [ ! -f "$ENV_CACHE_DIR/install.lock" ]; then
  die "already clean, exiting." | tee -a "$ENV_STATE_DIR/env.log"
fi
log "removing $ENV_CACHE_DIR" | tee -a "$ENV_STATE_DIR/env.log"
rm -rf "$ENV_CACHE_DIR"

env_uninstall() {
  dbg "running $1/uninstall.sh" | tee -a "$ENV_STATE_DIR/env.log"
  pushd $1
  bash ./uninstall.sh
  popd
}

#log "uninstalling tools" | tee -a "$ENV_STATE_DIR/env.log"
#env_uninstall "$REPO_CONFIG/configurations/tools/bat"
#env_uninstall "$REPO_CONFIG/configurations/tools/cargo-update"
#env_uninstall "$REPO_CONFIG/configurations/tools/eza"
#env_uninstall "$REPO_CONFIG/configurations/tools/fd"
#env_uninstall "$REPO_CONFIG/configurations/tools/ripgrep"
#env_uninstall "$REPO_CONFIG/configurations/tools/yazi"
#env_uninstall "$REPO_CONFIG/configurations/tools/zellij"
#env_uninstall "$REPO_CONFIG/configurations/rust"

rm_symlink() {
  dbg "removing symlink $1" | tee -a "$ENV_STATE_DIR/env.log"
  rm -f $1
}
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
rm_symlink "$CONFIG/bat"
rm_symlink "$CONFIG/git"
rm_symlink "$CONFIG/nvim"
rm_symlink "$CONFIG/wezterm"
rm_symlink "$CONFIG/yazi"
rm_symlink "$CONFIG/zellij"
rm_symlink "$CONFIG/oh-my-posh"
rm_symlink "$HOME/.bashrc.$ENV_USER.env"

log "sanitizing user .bashrc to remove environment script sourcing." | tee -a "$ENV_STATE_DIR/env.log"
if [ -z "$1" ]; then
  sed -i "/.bashrc.$ENV_USER.env/d" "$HOME/.bashrc"
else
  sed -i "/.bashrc.$ENV_USER.env/d" "$HOME/.bashrc.$(whoami)"
fi
