set -e

scripts_home="$PWD"

function source_rglob {
    for script in "$@"; do
        local base="$PWD"
        local script_dir=$(dirname "$script")
        if [ "$script" = "$script_dir/init.sh" ]; then
            continue
        fi
        cd "$script_dir"
        source "$script"
        cd "$base"
    done
}

cd "$PWD/personal"
source "init.sh"
cd "$scripts_home"

if [ -d "$PWD/work" ]; then
    cd "$PWD/work"
    source "init.sh"
    cd "$scripts_home"
fi

