# general
cd() {
  command -v z &>/dev/null || builtin cd "$@" || return 
  z "$@"
}

psme() {
  local grepper=rg
  command -v $grepper &>/dev/null || grepper=grep
  ps -aux | $grepper $(whoami)
}

alias_or_warn ll eza -alh
alias_or_warn iv feh --fullscreen
alias_or_warn fbat fzf --bind "enter:execute(bat {})"

# zellij
alias_or_warn zt zellij options --theme $ZELLIJ_THEME
alias_or_warn za zt --attach-to-session true --session-name

# nvim
alias_or_warn v nvim
alias_or_warn vim nvim
alias_or_warn vi nvim --clean
alias_or_warn fv fzf --bind "enter:become(nvim {})"

# git
alias gs='git status'
alias gsu='git status -uno'
alias gl='git log'
alias glo='git log --oneline'
alias gll='git log -p'
alias gd='git diff'
alias gsw='git switch'
alias gwt='switch_worktree'
alias gwtr='remove_worktree'
alias gris='git_fuzzy_hash_cmd rebase --interactive --autosquash'
alias gri='git_fuzzy_hash_cmd rebase --interactive'
alias gadd='git_fuzzy_status_cmd add'
alias gress='git_fuzzy_status_cmd restore --staged'
alias gres='git_fuzzy_status_cmd restore'
alias gswd='git_fuzzy_hash_cmd switch -d '
alias gsh='git_fuzzy_hash_cmd show'
alias gfix='git_fuzzy_hash_cmd commit --fixup'
alias gfixr='git_fuzzy_hash_cmd commit --fixup=reword:'
