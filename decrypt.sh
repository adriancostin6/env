#!/usr/bin/env bash
set -e

source scripts/gpg.sh

dirs=(
  "work"
)

for dir in "${dirs[@]}"
do
  printf "Decrypting $dir.\n"
  decrypt_directory "$PWD/$dir"
done
