source ./env.sh
source ./utils.sh

logger_set_log_component "rust"

if [ -f "$ENV_RUST_INSTALL_LOCK" ]; then
  log "uninstalling" | tee -a "$ENV_RUST_STATE_DIR/rust.log"
  rustup self uninstall &| tee -a "$ENV_RUST_STATE_DIR/rust.log"

  log "cleanup done, removing $ENV_RUST_INSTALL_LOCK." | tee -a "$ENV_RUST_STATE_DIR/rust.log"
  rm -f $ENV_RUST_INSTALL_LOCK
fi
