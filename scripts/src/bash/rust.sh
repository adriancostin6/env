# TODO: set up local cache
# This should do it, if I got expanding default values right
ENV_RUST_TOOLS_CACHE_DIR="${XDG_CACHE_HOME/env/rust:$HOME/.local/share/env/rust}"
ENV_RUST_TOOLS_STATE_DIR="${XDG_STATE_HOME/env/rust:$HOME/.local/state/env/rust}"

# Get our hands rusty.
ENV_RUST_INSTALL_LOCK="$ENV_RUST_TOOLS_CACHE_DIR/install.lock"
ENV_RUST_REQUIRES_RESTART="$ENV_RUST_TOOLS_STATE_DIR/restart.lock"
env_install_rust() {
    [ -f "$ENV_RUST_INSTALL_LOCK" ] && return
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    touch "$ENV_RUST_INSTALL_LOCK"
    touch "$ENV_RUST_REQUIRES_RESTART"
}
env_uninstall_rust() {
    if [ -f "$ENV_RUST_INSTALL_LOCK" ]; then
        rustup self uninstall
        rm -f $ENV_RUST_INSTALL_LOCK
    fi
}

# Grab the tools
ENV_RUST_PACKAGE_INSTALL_LOCK="$ENV_RUST_TOOLS_CACHE_DIR/install.lock"
env_install_rust_tools() {
    [ -f "$ENV_RUST_PACKAGE_INSTALL_LOCK" ] && return
    if [ -f "$ENV_RUST_REQUIRES_RESTART" ]; then
        printf "Cargo needs to be in path to install Rust packages.\n"
        printf "Please restart your shell...\n"
        return
    fi
    # TODO: what do we do if one of these fails?
    cargo install eza
    cargo install ripgrep
    cargo install fd-find
    cargo install --locked zellij
    cargo install --locked bat
    cargo install --force yazi-build
    cargo install cargo-update
    # no need to install them twice
    touch "$ENV_RUST_PACKAGE_INSTALL_LOCK"
}
env_uninstall_rust_tools() {
    if [ -f "$ENV_RUST_INSTALL_LOCK" ]; then
        # TODO: how do we uninstall with cargo?
        rm -f "$ENV_RUST_PACKAGE_INSTALL_LOCK"
    fi
}
env_update_rust_tools() {
    cargo install-update -a
}

env_install_rust
env_install_rust_tools
