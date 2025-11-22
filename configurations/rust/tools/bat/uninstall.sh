#!/usr/bin/env bash

source ../../env.sh
source ../../utils.sh

logger_set_log_component "bat"

ENV_RUST_BAT_INSTALL_LOCK="$ENV_RUST_TOOLS_CACHE_DIR/bat-install.lock"
env_rust_can_uninstall_pkg "$ENV_RUST_BAT_INSTALL_LOCK" || die "Cannot install bat" | tee -a $ENV_RUST_TOOLS_STATE_DIR/bat.log

log "uninstalling bat." | tee -a $ENV_RUST_TOOLS_STATE_DIR/bat.log
cargo uninstall bat &| tee -a $ENV_RUST_TOOLS_STATE_DIR/bat.log

log "cleanup done, removing $ENV_RUST_BAT_INSTALL_LOCK." | tee -a $ENV_RUST_TOOLS_STATE_DIR/bat.log
rm -f "$ENV_RUST_BAT_INSTALL_LOCK"
