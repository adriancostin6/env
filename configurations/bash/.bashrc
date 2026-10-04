set -o vi 
shopt -s globstar

# Environment variables
export VISUAL="nvim --clean"
export EDITOR="$VISUAL"

export IDEA_PROPERTIES="$ENV_REPO_DIR/configurations/idea/idea.properties"
export ENV_APP_HOME="$HOME/apps"
export ENV_REPO_HOME="$HOME/repos"

# PATH
[[ ":$PATH:" == "*:$HOME/.local/bin:*" ]] || PATH="$HOME/.local/bin:$PATH"
PATH="$PWD/scripts/bin:$PATH"

# +-----------------------------+
# | My Bash configuration stack |
# +-----------------------------+----------------------------------------------
ENV_CACHE_DIR="$HOME/.local/share/env"
. "$ENV_CACHE_DIR/repodir"

. "$ENV_REPO_DIR/scripts/src/bash/dirs.sh"
pushd "$ENV_REPO_DIR"

# Has to be first
. scripts/src/bash/exec.sh  # already sourced in main bashrc

# Order matters here
. scripts/src/bash/posh.sh  # messes with PROMPT_COMMAND, so has to be first
. scripts/src/bash/history.sh

# Order does not matter here
. scripts/src/bash/aliases.sh
. scripts/src/bash/brightness.sh
. scripts/src/bash/dirs.sh
. scripts/src/bash/gpg.sh
. scripts/src/bash/log.sh
. scripts/src/bash/nvm.sh
. scripts/src/bash/path.sh
. scripts/src/bash/process.sh
. scripts/src/bash/stow.sh
. scripts/src/bash/theme.sh
. scripts/src/bash/xdg.sh
. scripts/src/bash/yazi.sh
. scripts/src/bash/zoxide.sh

# let's leave this last ^(.)^
. scripts/src/bash/completions.sh
. scripts/src/bash/binds.sh

popd
