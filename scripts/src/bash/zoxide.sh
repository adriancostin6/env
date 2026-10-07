cd() {
  command -v z &>/dev/null || builtin cd "$@" || return k
  z "$@"
}

# These commands will be run last after triggering the USR2 signal
_init_zoxide_last() {
    exec_if zoxide init bash
    trap - USR2  # only once
}
add_trap '_init_zoxide_last' USR2
