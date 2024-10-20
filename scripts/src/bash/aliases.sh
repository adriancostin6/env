# general
alias fbat="fzf --bind 'enter:execute(bat {})'"
alias iv='feh --fullscreen'
alias ll="eza --group-directories-first -alh"

# nvim
alias v='nvim'
alias vi='nvim --clean'
alias vim='nvim'

# git
alias gadd='git_fuzzy_status_cmd add'
alias gd='git diff'
alias gfix='git_fuzzy_hash_cmd commit --fixup'
alias gfixr='git_fuzzy_hash_cmd commit --fixup=reword:'
alias gl='git log'
alias gll='git log -p'
alias glo='git log --oneline'
alias gp='git_push_current'
alias gpf='git_push_current_force'
alias gres='git_fuzzy_status_cmd restore'
alias gress='git_fuzzy_status_cmd restore --staged'
alias gri='git_fuzzy_hash_cmd rebase --interactive'
alias gris='git_fuzzy_hash_cmd rebase --interactive --autosquash'
alias gs='git status'
alias gsh='git_fuzzy_hash_cmd show'
alias gsu='git status -uno'
alias gsw='git switch'
alias gswd='git_fuzzy_hash_cmd switch -d '
alias gup='git_update_current_branch'
alias gwt='switch_worktree'
alias gwtr='remove_worktree'
alias gg='git_graph'

function _zellij_opt {
    zellij options --theme $ZELLIJ_THEME $*
}
alias za='_zellij_opt --attach-to-session true --session-name'
