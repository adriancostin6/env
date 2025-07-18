# +---------+
# | Helpers |
# +---------+------------------------------------------------------------------
function Git-FuzzyStatus {
    $repo_root = git rev-parse --show-toplevel
    $git_status = git status --porcelain | fzf --multi

    $files = [System.Collections.ArrayList]@()
    foreach($line in $git_status) {
        $tokens = $line -split " "
        $file = $tokens[-1]
        [void]$files.add("$repo_root/$file")
    }

    return $files
}

# +---------+
# | Aliases |
# +---------+------------------------------------------------------------------
function gadd {
    $files = Git-FuzzyStatus

    foreach($file in $files) {
        git add $file
    }
}

function gblame {
    fzf --bind "enter:become(git blame {})"
}

function gs {
    git status
}

function gsu {
    git status -uno
}

function glo {
    git log --oneline
}

function gll {
    git log -p
}
