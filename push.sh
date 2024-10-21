#!/bin/bash
# Wrapper over git push, that does encryption.

set -e

./encrypt.sh "adriancostin6@gmail.com"
git push "$@"
