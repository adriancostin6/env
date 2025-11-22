source "$ENV_RUST_CACHE_DIR/../repodir"
source "$ENV_REPO_DIR/scripts/src/bash/log.sh"

env_rust_can_install_pkg() {
  # is rust is available?
  [ -f "$ENV_RUST_INSTALL_LOCK" ] || return 1

  # is the package already installed?
  [ -f "$1" ] && return 1
}
env_rust_can_uninstall_pkg() {
  # is rust is available?
  [ -f "$ENV_RUST_INSTALL_LOCK" ] || return 1

  # is the package already uninstalled?
  [ ! -f "$1" ] && return 1
}
