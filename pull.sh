#!/bin/bash
# Wrapper over git pull, that does decryption.

set -e

git pull "$@"
./decrypt.sh
