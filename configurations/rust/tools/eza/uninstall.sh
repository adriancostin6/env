#!/usr/bin/env bash

source ../../env.sh
source ../../utils.sh

logger_set_log_component "eza"
log "starting uninstaller" | tee -a "$ENV_RUST_TOOLS_STATE_DIR/eza.log"

ENV_RUST_EZA_INSTALL_LOCK="$ENV_RUST_TOOLS_CACHE_DIR/eza-install.lock"
env_rust_can_uninstall_pkg "$ENV_RUST_EZA_INSTALL_LOCK" || die "cannot install" | tee -a "$ENV_RUST_TOOLS_STATE_DIR/eza.log"

log "uninstalling" | tee -a "$ENV_RUST_TOOLS_STATE_DIR/eza.log"
cargo uninstall eza &| tee -a "$ENV_RUST_TOOLS_STATE_DIR/eza.log"

log "cleanup done, creating $ENV_RUST_EZA_INSTALL_LOCK." | tee -a "$ENV_RUST_TOOLS_STATE_DIR/eza.log"
rm -f "$ENV_RUST_EZA_INSTALL_LOCK"
