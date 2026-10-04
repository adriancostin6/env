# persist history between multiple bash sessions
mkdir -p "$XDG_STATE_HOME/bash"

export HISTCONTROL='ignoreboth:erasedups' # no spaces, no duplicates
export HISTFILE="$XDG_STATE_HOME/bash/history"
export HISTFILESIZE=10000
export HISTSIZE=10000
export PROMPT_COMMAND="history -a;$PROMPT_COMMAND" # update history on each prompt

shopt -s histappend
set -o history
