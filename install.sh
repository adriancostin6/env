#!/usr/bin/env bash

# Pathetic attempt at an install script.
# Do not expect this to work, but rather to scream at you to install the
# dependencies you are missing in order to get the most out of this env.


needs=(
  gpg
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

set -e

INSTALL_HOME="$PWD"

function cleanup_done {
  rm -f "$INSTALL_HOME/conf-secret"
}

function cleanup_fail {
  EXIT_CODE=$?
  set +e
  rm -f "$INSTALL_HOME/conf-secret"
  rm -rf "$INSTALL_HOME/env"
  exit $EXIT_CODE
}
trap cleanup_fail EXIT


printf "Cloning env repo.\n"
git clone https://www.github.com/adriancostin6/env.git
cd env

source "scripts/gpg.sh"
gpg-connect-agent updatestatruptty /bye
setup_keys "$INSTALL_HOME/conf-secret" "$INSTALL_HOME/env/env.gpg"
./decrypt.sh

cd "$INSTALL_HOME"

bash
