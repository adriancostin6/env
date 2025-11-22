#!/usr/bin/env bash

source ../../env.sh
source ../../utils.sh

logger_set_log_component "bat"

ENV_RUST_BAT_INSTALL_LOCK="$ENV_RUST_TOOLS_CACHE_DIR/bat-install.lock"
env_rust_can_install_pkg "$ENV_RUST_BAT_INSTALL_LOCK" || die "Cannot install bat" | tee -a $ENV_RUST_TOOLS_STATE_DIR/bat.log

log "installing bat." | tee -a $ENV_RUST_TOOLS_STATE_DIR/bat.log
cargo install --locked bat &| tee -a $ENV_RUST_TOOLS_STATE_DIR/bat.log

log "setup done, creating $ENV_RUST_BAT_INSTALL_LOCK." | tee -a $ENV_RUST_TOOLS_STATE_DIR/bat.log
touch "$ENV_RUST_BAT_INSTALL_LOCK"
