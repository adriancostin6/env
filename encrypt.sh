#!/bin/bash
set -e

function usage {
  printf "Encrypts directories in preparation for a git push.\n"
  printf "usage: ./encrypt.sh gpg-user-id\n"
}

if [ $# -ne 1 ]; then
  usage
  exit 1
fi

source scripts/gpg.sh

dirs=(
  "work"
)

for dir in "${dirs[@]}"
do
  encrypt_directory "$dir" "$1"
done
