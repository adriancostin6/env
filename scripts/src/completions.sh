# order is important. bash before fzf ^(.)^
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

# https://github.com/junegunn/fzf?tab=readme-ov-file#key-bindings-for-command-line 
eval "$(fzf --bash)"
