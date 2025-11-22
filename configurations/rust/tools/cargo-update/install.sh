#!/usr/bin/env bash
source ../../env.sh
source ../../utils.sh

logger_set_log_component "cargo-update"

ENV_RUST_CARGO_UPDATE_INSTALL_LOCK="$ENV_RUST_TOOLS_CACHE_DIR/cargo-update.install.lock"
env_rust_can_install_pkg "$ENV_RUST_CARGO_UPDATE_INSTALL_LOCK" || die "cannot install" | tee -a "$ENV_RUST_TOOLS_STATE_DIR/cargo-update.log"

log "installing" | tee -a "$ENV_RUST_TOOLS_STATE_DIR/cargo-update.log"
cargo install cargo_update &| tee -a "$ENV_RUST_TOOLS_STATE_DIR/cargo-update.log"

log "setup done, creating $ENV_RUST_CARGO_UPDATE_INSTALL_LOCK." | tee -a "$ENV_RUST_TOOLS_STATE_DIR/cargo-update.log"
touch "$ENV_RUST_CARGO_UPDATE_INSTALL_LOCK"
