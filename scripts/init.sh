function source_rglob {
    for script in "$@"; do
        local script_dir=$(dirname "$script")
        if [ "$script" = "init.sh" ]; then
            continue
        fi
        source "./$script"
    done
}

pushd personal
source ./init.sh
popd

if [ -d work ]; then
    pushd work
    source ./init.sh
    popd
fi

