echo "Hello"
return # not ready yet

pushd () {
    command pushd "$@" > /dev/null
}

popd() {
    command popd "$@" > /dev/null
}

# VI mode for Readline
set -o vi 
bind -m vi-insert '"\C-l":clear-screen'
bind -m vi-insert '"\C-a":beginning-of-line'
bind -m vi-insert '"\C-e":end-of-line'
bind -m vi-insert '"\C-w":backward-kill-word'
bind -m vi-insert '"\C-k":kill-line'

# XDG
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

export IDEA_PROPERTIES="$ENV_REPO_DIR/env/idea/idea.properties"
export ENV_APP_HOME="$HOME/apps"
export ENV_REPO_HOME="$HOME/repos"

# Add local binary directory if not present already.
[[ ":$PATH:" == "*:$HOME/.local/bin:*" ]] || PATH="$HOME/.local/bin:$PATH"

# Configuration
pushd "$ENV_REPO_DIR/env/scripts"
source ./init.sh
popd

zoxide init bash
oh-my-posh init bash --config "$XDG_CONFIG_HOME/oh-my-posh/.adrianc.omp.json"
