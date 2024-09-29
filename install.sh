#!/usr/bin/env bash
set -e

# Pathetic attempt at an install script.
# Do not expect this to work, but rather to scream at you to install the
# dependencies you are missing in order to get the most out of this env.

declare -a needs=(
	"stow"
)

declare -a wants=(
	"bat"
	"delta"
	"eza"
	"fd"
	"fzf"
	"nvim"
)

function fail {
	local msg="$1"

	printf "%s\n" "$msg"
	return 1
}

function warn {
	local msg="$1"

	printf "%s\n" "$msg"
	return 0
}

function has {
	local cmd=$1
	if ! command -v "$cmd" 2>&1 >/dev/null
	then
		printf "%s not found in PATH\n" "$cmd"
		return 1
	else
		printf "found %s.\n" "$cmd"
		return 0
	fi
}

function sanity {
	local logger=$1
	local -n required=$2

	for cmd in "${required[@]}"
	do
		has $cmd || "$logger" "install $cmd before proceeding." || return 1
	done
}


# TODO: figure out why this does not work
read -d '' -r MSG <<'EOF'
	+----------------------------------------------+
	| checking that required commands are installed|
	+----------------------------------------------+
EOF
printf "%s" "$MSG"
sanity fail needs

#read -r -d "" MSG << "EOF"
#	+----------------------+
#	| checking wanted cmds |
#	+----------------------+
#EOF
#printf "%s\n" "$MSG"
sanity warn wants 


#git clone https://www.github.com/adriancostin6/env.git

