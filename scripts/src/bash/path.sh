path_remove_script_dir() {
    local script_dir
    script_dir="$(dirname "$(realpath "$0")")"
    echo "${PATH//$script_dir:/}"
}
export -f path_remove_script_dir

path_append() {
    [ "$#" -ne 1 ] && { return 1; }
    local in="${1%/}" # remove trailing slashes

    [[ ":$PATH:" == *":$in:"* ]] && { return 1; } # if not in path already
    PATH="$PATH:$in"
}

path_prepend() {
    [ "$#" -ne 1 ] && { return 1; }
    local in="${1%/}" # remove trailing slashes

    [[ ":$PATH:" == *":$in:"* ]] && { return 1; } # if not in path already
    PATH="$in:$PATH"
}
