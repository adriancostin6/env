#!/usr/bin/env bash

source ../../env.sh
source ../../utils.sh

logger_set_log_component "eza"

ENV_RUST_EZA_INSTALL_LOCK="$ENV_RUST_TOOLS_CACHE_DIR/eza-install.lock"
env_rust_can_install_pkg "$ENV_RUST_EZA_INSTALL_LOCK" || die "cannot install" | tee -a "$ENV_RUST_TOOLS_STATE_DIR/eza.log"

log "installing" | tee -a "$ENV_RUST_TOOLS_STATE_DIR/eza.log"
cargo install eza &| tee -a "$ENV_RUST_TOOLS_STATE_DIR/eza.log"

log "setup done, creating $ENV_RUST_EZA_INSTALL_LOCK." | tee -a "$ENV_RUST_TOOLS_STATE_DIR/eza.log"
touch "$ENV_RUST_EZA_INSTALL_LOCK"
