#!/usr/bin/env bash

# Pathetic attempt at an install script.
# Do not expect this to work, but rather to scream at you to install the
# dependencies you are missing in order to get the most out of this env.

needs=(
	bat
	delta
	eza
	fd
	fzf
	nvim
  rg
)

for cmd in "${needs[@]}"
do
	command -v $cmd &>/dev/null || printf "Missing required dependency: %s\n" $cmd
done

#git clone https://www.github.com/adriancostin6/env.git
