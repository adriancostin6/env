THEMES=(
    "Catppuccin Latte"
    "Catppuccin Frappe"
    "Catppuccin Machiato"
    "Catppuccin Mocha"
)

function set_theme_env_vars {
    local base=$1
    local lower=$2

    export BAT_THEME="$base"
    export ZELLIJ_THEME="$lower"
    export DELTA_FEATURES="$lower"
}

function set_initial_theme {
    if [ -n "$__INITIAL_SET_THEME" ]; then
        return 0
    fi
    export __INITIAL_SET_THEME="yes"

    local base="${THEMES[0]}"
    local dashes="${base/ /-}"
    local lower="${dashes,,}"

    set_theme_env_vars "$base" "$lower"
}
set_initial_theme

function theme {
    local base="$(printf "%s\n" "${THEMES[@]}" | fzf)"
    local dashes="${base/ /-}"
    local lower="${dashes,,}"

    printf "Setting theme $base.\n"
    set_theme_env_vars "$base" "$lower"
}
