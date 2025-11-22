source ./env.sh

mkdir -p ENV_RUST_CACHE_DIR
mkdir -p ENV_RUST_STATE_DIR
mkdir -p ENV_RUST_TOOLS_CACHE_DIR
mkdir -p ENV_RUST_TOOLS_STATE_DIR

[ -f "$ENV_RUST_INSTALL_LOCK" ] && exit 1
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
touch "$ENV_RUST_INSTALL_LOCK"
