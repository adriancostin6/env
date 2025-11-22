#!/usr/bin/env bash

source ../../env.sh
source ../../utils.sh

ENV_RUST_YAZI_INSTALL_LOCK="$ENV_RUST_TOOLS_CACHE_DIR/yazi-install.lock"
env_rust_can_uninstall_pkg "$ENV_RUST_YAZI_INSTALL_LOCK" || die "cannot install" | tee -a "$ENV_RUST_TOOLS_STATE_DIR/yazi.log"

log "uninstalling" | tee -a "$ENV_RUST_TOOLS_STATE_DIR/yazi.log"
cargo uninstall yazi_build &| tee -a "$ENV_RUST_TOOLS_STATE_DIR/yazi.log"

log "cleanup done, creating $ENV_RUST_YAZI_INSTALL_LOCK." | tee -a "$ENV_RUST_TOOLS_STATE_DIR/yazi.log"
rm -f "$ENV_RUST_YAZI_INSTALL_LOCK"
