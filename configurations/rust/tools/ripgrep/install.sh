#!/usr/bin/env bash

source ../../env.sh
source ../../utils.sh

logger_set_log_component "ripgrep"

ENV_RUST_RIPGREP_INSTALL_LOCK="$ENV_RUST_TOOLS_CACHE_DIR/ripgrep-install.lock"
env_rust_can_install_pkg "$ENV_RUST_RIPGREP_INSTALL_LOCK" || die "cannot install" | tee -a "$ENV_RUST_TOOLS_STATE_DIR/ripgrep.log"

log "installing" | tee -a "$ENV_RUST_TOOLS_STATE_DIR/ripgrep.log"
cargo install ripgrep &| tee -a"$ENV_RUST_TOOLS_STATE_DIR/ripgrep.log"

log "setup done, creating $ENV_RUST_RIPGREP_INSTALL_LOCK." | tee -a "$ENV_RUST_TOOLS_STATE_DIR/ripgrep.log"
touch "$ENV_RUST_RIPGREP_INSTALL_LOCK"
