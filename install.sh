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
)

git clone https://www.github.com/adriancostin6/env.git