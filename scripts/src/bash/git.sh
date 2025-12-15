function owned_branches {
    echo "Enter owner name (First, Last):"
    read name

    git for-each-ref \
        --sort=committerdate                                            \
        --format='%(committerdate) %09 %(authorname) %09 %(refname)'    \
        refs/remotes | grep -v "[S-Z]-[0-9][0-9][0-9][0-9]\.[0-9][0-9]" \
    | grep refs/remotes/origin/                                         \
    | grep "$name"
}
function fuzzy_git_status {
    local repo_root="$(git rev-parse --show-toplevel)/"
    echo $(git status --porcelain | fzf --multi | awk -v root=$repo_root '{print root $2}')
}
function git_fuzzy_status_cmd {
    git "$@" $(fuzzy_git_status)
}
function fuzzy_hash {
    local hash=$(git log --oneline | fzf --ansi | awk '{print $1}')
    echo $hash
}
function git_fuzzy_hash_cmd {
    local hash=$(fuzzy_hash)
    if [ ! -v $hash ];then
        git "$@" $hash
    fi
}
function is_repo {
    git rev-parse --is-inside-work-tree > /dev/null 2>&1
}
function git_clone_wt {
    # get repo name from url
    local url="${@: -1}"
    IFS='/' read -ra split_url <<< "$url"
    local repo_name="${split_url[-1]/.git/}" # strip .git if present

    mkdir "$repo_name"
    cd "$repo_name"

    # place bare repo contents in hidden folder to hide them
    git clone --bare $* .bare
    printf "gitdir: ./.bare" > .git

    # make git bare repo fetch remote branches properly
    git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    git fetch origin

    cd -
}
function select_worktree {
    local worktree="$(git worktree list --porcelain | rg worktree | fzf | awk '{print $2}')"
    echo $worktree
}
function remove_worktree {
    is_repo || return

    if [ $# -gt 1 ];then
        echo "Invalid number of arguments"
    fi

    if [ $# -eq 0 ];then
        local worktree=$(select_worktree)
        if [ -z "$worktree" ];then
            echo "Selection is empty. Cannot remove worktree."
            return
        fi

        git worktree remove $worktree
    else
        git worktree remove $1
    fi
}
function switch_worktree {
    is_repo || return

    if [ $# -gt 1 ];then
        echo "Invalid number of arguments"
    fi

    if [ $# -eq 0 ];then
        local worktree=$(select_worktree)
        if [ -z "$worktree" ];then
            echo "Selection is empty. Cannot switch worktree."
            return
        fi

        cd $worktree
    else
        cd $1
    fi
}

function git_update_current_branch {
    git pull origin $(git rev-parse --abbrev-ref HEAD)
}

function git_push_current_force {
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    local cmd="git push origin --force $current_branch"

    read -r -p "Execute: $cmd ?(y/N)" confirm
    local lower=${confirm,,}

    if [ "$lower" = "y" ]; then
        eval "$cmd"
    fi
}
