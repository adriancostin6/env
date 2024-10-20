APPS="/u/adrianc/apps"
MAVEN="$APPS/apache-maven-3.9.6/bin"
BAT="$APPS/bat-v0.24.0-x86_64-unknown-linux-musl"
DELTA="$APPS/delta-0.17.0-x86_64-unknown-linux-musl"
FD="$APPS/fd-v8.7.1-x86_64-unknown-linux-musl"
NVIM="$APPS/nvim-linux64/bin"
OMP="$APPS/omp"
RG="$APPS/ripgrep-13.0.0-x86_64-unknown-linux-musl"
ZOXIDE="$APPS/zoxide-0.9.4"

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
