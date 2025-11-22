#!/usr/bin/env bash

source ../../env.sh
source ../../utils.sh

logger_set_log_component "yazi"

ENV_RUST_YAZI_INSTALL_LOCK="$ENV_RUST_TOOLS_CACHE_DIR/yazi-install.lock"
env_rust_can_install_pkg "$ENV_RUST_YAZI_INSTALL_LOCK" || die "cannot install" | tee -a "$ENV_RUST_TOOLS_STATE_DIR/yazi.log"

log "installing" | tee -a "$ENV_RUST_TOOLS_STATE_DIR/yazi.log"
cargo install --force yazi_build &| tee -a "$ENV_RUST_TOOLS_STATE_DIR/yazi.log"

log "setup done, creating $ENV_RUST_YAZI_INSTALL_LOCK." | tee -a "$ENV_RUST_TOOLS_STATE_DIR/yazi.log"
touch "$ENV_RUST_YAZI_INSTALL_LOCK"
