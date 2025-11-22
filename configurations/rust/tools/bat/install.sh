#!/usr/bin/env bash

source ../../env.sh
source ../../utils.sh

ENV_RUST_BAT_INSTALL_LOCK="$ENV_RUST_TOOLS_CACHE_DIR/bat-install.lock"
env_rust_can_install_pkg "$ENV_RUST_BAT_INSTALL_LOCK" || exit 1

cargo install --locked bat
touch "$ENV_RUST_BAT_INSTALL_LOCK"
