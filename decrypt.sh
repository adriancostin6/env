#!/usr/bin/env bash
set -e

source scripts/gpg.sh

dirs=(
  "work"
)

if [ $# -ne 1 ]; then
  printf "usage: ./decrypt.sh password-file\n"
  exit 1
fi

if [ ! -f "$PWD/$1" ]; then
  printf "Password file $1 not found.\n"
  exit 1
fi

for dir in "${dirs[@]}"
do
  printf "Decrypting $dir.\n"
  decrypt_directory "$PWD/$dir" "$PWD/$1"
done
