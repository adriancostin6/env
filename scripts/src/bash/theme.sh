THEMES=(
    "Rose Pine Dawn"
    "Rose Pine"
    "Rose Pine Moon"
    "Catppuccin Latte"
    "Catppuccin Frappe"
    "Catppuccin Machiato"
    "Catppuccin Mocha"
)

unset BAT_THEME
export ZELLIJ_THEME="rose-pine-dawn"
unset DELTA_FEATURES

# zellij
alias zt="zellij options --theme $ZELLIJ_THEME"
alias za='zt --attach-to-session true --session-name'

function set_theme_env_vars {
    local base=$1
    local lower=$2

    export ZELLIJ_THEME="$lower"

    [[ "$base" == *"Rose"* ]] && return

    export BAT_THEME="$base"
    export DELTA_FEATURES="$lower"
}

function theme {
    local base="$(printf "%s\n" "${THEMES[@]}" | fzf)"
    local dashes="${base// /-}"
    local lower="${dashes,,}"

    printf "Setting theme $base.\n"
    set_theme_env_vars "$base" "$lower"
}
