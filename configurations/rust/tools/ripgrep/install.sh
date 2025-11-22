#!/usr/bin/env bash

source ../../env.sh
source ../../utils.sh

ENV_RUST_RIPGREP_INSTALL_LOCK="$ENV_RUST_TOOLS_CACHE_DIR/ripgrep-install.lock"
env_rust_can_install_pkg "$ENV_RUST_RIPGREP_INSTALL_LOCK" || exit 1

cargo install ripgrep
touch "$ENV_RUST_RIPGREP_INSTALL_LOCK"
