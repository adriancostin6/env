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

alias ll="eza --group-directories-first -alh"
alias iv='feh --fullscreen'
alias fbat="fzf --bind 'enter:execute(bat {})'"


# nvim
alias v='nvim'
alias vim='nvim'
alias vi='nvim --clean'
alias fv="fzf --bind 'enter:become(nvim {})'"

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
