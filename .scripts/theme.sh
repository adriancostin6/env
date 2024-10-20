function theme_switch {
  declare -rA themes=(
    ["Catppuccin Latte"]="catppuccin-latte"
    ["Catppuccin Frappe"]="catppuccin-frappe"
  )

  local theme_list=""
  for theme in "${!themes[@]}"
  do
    theme_list="$theme_list$theme\n"
  done
  local selected=`echo -e $theme_list | fzf`

  export BAT_THEME="$selected"
  export ZELLIJ_THEME="${themes[${selected}]}"
}
