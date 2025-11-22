#!/usr/bin/env bash

source ../../env.sh
source ../../utils.sh

logger_set_log_component "zellij"

ENV_RUST_ZELLIJ_INSTALL_LOCK="$ENV_RUST_TOOLS_CACHE_DIR/zellij-install.lock"
env_rust_can_install_pkg "$ENV_RUST_ZELLIJ_INSTALL_LOCK" || die "cannot install" | tee -a "$ENV_RUST_TOOLS_STATE_DIR/zellij.log"

log "installing" | tee -a "$ENV_RUST_TOOLS_STATE_DIR/zellij.log"
cargo install --locked zellij &| tee -a "$ENV_RUST_TOOLS_STATE_DIR/zellij.log"

log "setup done, creating $ENV_RUST_ZELLIJ_INSTALL_LOCK." | tee -a "$ENV_RUST_TOOLS_STATE_DIR/zellij.log"
touch "$ENV_RUST_ZELLIJ_INSTALL_LOCK"
