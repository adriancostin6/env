function Get-FuzzyGitStatusFiles {
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

function Git-FuzzyHash {
    $log_line = git log --oneline | fzf --ansi
    $split= $log_line -split " "
    $hash = $split[0]
    return $hash
}

function Call-FuzzyGitRebaseInteractive {
    param (
        [switch] $Squash
    )
    $hash = Git-FuzzyHash

    if ($Squash) {
        Write-Output "Present"
        git rebase --interactive --autosquash $hash
    } else {
        Write-Output "Not present"
        git rebase --interactive $hash
    }
}

function Do-GitAddFuzzy {
    $files = Get-FuzzyGitStatusFiles

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
