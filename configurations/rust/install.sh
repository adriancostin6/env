source ./env.sh
source ./utils.sh

logger_set_log_component "rust"

mkdir -p ENV_RUST_CACHE_DIR
mkdir -p ENV_RUST_STATE_DIR
mkdir -p ENV_RUST_TOOLS_CACHE_DIR
mkdir -p ENV_RUST_TOOLS_STATE_DIR

[ -f "$ENV_RUST_INSTALL_LOCK" ] && die "Rust already installed" | tee -a "$ENV_RUST_STATE_DIR/rust.log"

log "installing Rust" | tee -a "$ENV_RUST_STATE_DIR/rust.log"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh &| tee -a "$ENV_RUST_STATE_DIR/rust.log"

log "setup done, creating $ENV_RUST_INSTALL_LOCK." | tee -a "$ENV_RUST_STATE_DIR/rust.log"
touch "$ENV_RUST_INSTALL_LOCK"
