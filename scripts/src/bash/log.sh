log() {
    local caller=$(basename "${BASH_SOURCE[-1]:-$0}")

    local msg="$1"
    local severity="INFO"
    if [ "$#" -eq 2 ]; then
        case "$1" in 
            INFO|WARN|ERROR)
                severity="$1"
                ;;
            *) ;;
        esac
        msg="$2"
    fi

    printf "[$caller] $severity $msg\n"
}

inf() {
    [ "$#" -lt 1 ] && { return; } # do nothing when no args are passed
    log "$1"
}

wrn() {
    [ "$#" -lt 1 ] && { return; } # do nothing when no args are passed
    log WARN "$1"
}

die() {
    if [ "$#" -eq 1 ];then
        log ERROR "$1"
    fi

    exit 1
}
