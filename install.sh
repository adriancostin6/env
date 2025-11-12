#!/usr/bin/env bash

install_home="$PWD"
if [ "$install_home" != "$HOME" ]; then
    printf "Cannot install outside of $HOME directory currently.\n"
    exit 1
fi

needs=(
    stow
)
failed=0
for pkg in "${needs[@]}"
do
  command -v $pkg &>/dev/null || { printf "Missing required dependency: %s\n" $pkg; let failed++;continue; }
done
if [ $failed -gt 0 ]; then
    exit 1
fi

wants=(
    bat
    delta
    dmenu
    dwm
    eza
    fd
    fzf
    nvim
    oh-my-posh
    rg
    st
    yazi
    zoxide
)
for pkg in "${wants[@]}"
do
  command -v $pkg &>/dev/null || { printf "Missing wanted package: %s\nConsider installing for better experience.\n" $pkg; continue; }
done

printf "Cloning env repo.\n"
git clone https://www.github.com/adriancostin6/env.git

set -e

cd env

declare -rA stows=(
  ["bat"]="$HOME/.config/bat"
  ["git"]="$HOME/.config/git"
  ["zellij"]="$HOME/.config/zellij"
  ["nvim"]="$HOME/.config/nvim"
  ["oh-my-posh"]="$HOME/.config/oh-my-posh"
  ["wezterm"]="$HOME/.config/wezterm"
)
source "scripts/src/bash/stow.sh"
printf "Stowing configurations...\n"
for pkg in "${!stows[@]}"
do
    target="${stows[$pkg]}"
    if [ -n "$target" ] ; then
        if [ ! -d "$target" ]; then
            printf "$target does not exist, creating.\n"
            mkdir -p $target
        fi
        printf "Stowing %s to %s.\n" "$pkg" "$target"
        stow_pkg "$pkg" "$target"
    fi
done

printf "Adding user shell configuation files to $HOME/.bashrc.$(whoami).\n"
printf "Remember to source this in your $HOME/.bashrc.\n"
printf "echo \"source ./bashrc.$(whoami)\" >> "$HOME/.bashrc"\n"

echo "pushd \"$HOME/env/bash\" > /dev/null" >> "$HOME/.bashrc.$(whoami)"
echo "source ./.bashrc.$(whoami)" >> "$HOME/.bashrc.$(whoami)"
echo "popd" >> "$HOME/.bashrc.$(whoami)"
