#!/usr/bin/env bash

source ../../env.sh
source ../../utils.sh

logger_set_log_component "fd"

ENV_RUST_FD_INSTALL_LOCK="$ENV_RUST_TOOLS_CACHE_DIR/fd-install.lock"
env_rust_can_install_pkg "$ENV_RUST_FD_INSTALL_LOCK" || die "cannot install" | tee -a "$ENV_RUST_TOOLS_STATE_DIR/fd.log"

log "installing" | tee -a "$ENV_RUST_TOOLS_STATE_DIR/fd.log"
cargo install fd-find &| tee -a "$ENV_RUST_TOOLS_STATE_DIR/fd.log"

log "setup done, creating $ENV_RUST_FD_INSTALL_LOCK." | tee -a "$ENV_RUST_TOOLS_STATE_DIR/fd.log"
touch $ENV_RUST_FD_INSTALL_LOCK
