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

function Do-GitAddFuzzy {
    $files = Git-FuzzyStatus

    foreach($file in $files) {
        git add $file
    }
}

function Do-GitBlame {
    fzf --bind "enter:become(git blame {})"
}

function Do-GitStatus {
    git status
}

function Do-GitStatusUntracked {
    git status -uno
}

function Do-GitLogOneline {
    git log --oneline
}

function Do-GitLog {
    git log
}

function Do-GitLogFull {
    git log -p
}
