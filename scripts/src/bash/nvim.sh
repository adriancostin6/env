ENV_NVIM_CACHE_DIR="${XDG_CACHE_HOME/env/nvim:$HOME/.local/share/env/nvim}"
ENV_NVIM_STATE_DIR="${XDG_STATE_HOME/env/nvim:$HOME/.local/state/env/nvim}"

ENV_NVIM_INSTALL_LOCK="$ENV_NVIM_CACHE_DIR/install.lock"
env_install_nvim() {
    inf "Installing Neovim nightly..."

    [ -f "$ENV_NVIM_INSTALL_LOCK" ] && return

    pushd $ENV_REPO_HOME
    git clone https://github.com/neovim/neovim.git

    pushd neovim
    make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=$ENV_APP_HOME/neovim
    make install

    pushd $HOME/.local/bin
    ln -s $ENV_APP_HOME/neovim/bin/nvim nvim
    popd

    touch "$ENV_NVIM_INSTALL_LOCK"
    popd
}
env_uninstall_rust() {
    if [ -f "$ENV_NVIM_INSTALL_LOCK" ]; then
        rm -rf $ENV_APP_HOME/neovim
        rm -f $HOME/.local/bin/nvim
        rm -f $ENV_NVIM_INSTALL_LOCK
    fi
}

env_install_nvim
