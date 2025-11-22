#!/usr/bin/env bash

source ../../env.sh
source ../../utils.sh

ENV_RUST_YAZI_INSTALL_LOCK="$ENV_RUST_TOOLS_CACHE_DIR/yazi-install.lock"
env_rust_can_uninstall_pkg "$ENV_RUST_YAZI_INSTALL_LOCK" || exit 1

cargo uninstall yazi_build
rm -f "$ENV_RUST_YAZI_INSTALL_LOCK"
