personal_home="$PWD"

export $PATH=$PWD/shell:$PATH

cd "$PWD/shell"
source "init.sh"
cd "$personal_home"
