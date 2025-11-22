# Rust + Cargo
ENV_RUST_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.local/share}/env/rust"
ENV_RUST_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/env/rust"

ENV_RUST_INSTALL_LOCK="$ENV_RUST_CACHE_DIR/install.lock"
ENV_RUST_REQUIRES_RESTART="$ENV_RUST_STATE_DIR/restart.lock"

# Rust packages
ENV_RUST_TOOLS_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.local/share}/env/rust/tools"
ENV_RUST_TOOLS_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/env/rust/tools"
