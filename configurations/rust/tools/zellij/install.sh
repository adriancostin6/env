#!/usr/bin/env bash

source ../../env.sh
source ../../utils.sh

ENV_RUST_ZELLIJ_INSTALL_LOCK="$ENV_RUST_TOOLS_CACHE_DIR/zellij-install.lock"
env_rust_can_install_pkg "$ENV_RUST_ZELLIJ_INSTALL_LOCK" || exit 1

cargo install --locked zellij
touch "$ENV_RUST_ZELLIJ_INSTALL_LOCK"
