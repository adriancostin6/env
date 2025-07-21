# +---------+
# | Getters |
# +---------+------------------------------------------------------------------
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
function Get-FuzzyGitHash {
    $log_line = git log --oneline | fzf --ansi
    $split= $log_line -split " "
    $hash = $split[0]
    return $hash
}
function Get-OwnedGitBranches {
    param (
        [Parameter(Mandatory)][string] $Name
    )

    $args = @(
        "--sort=committerdate",
        "--format='%(committerdate) %09 %(authorname) %09 %(refname)'",
        "refs/remotes"
    )
    $refs = git for-each-ref @args
    $dont_match = "[S-Z]-[0-9][0-9][0-9][0-9]\.[0-9][0-9]"
    $non_matching_refs = $refs | Select-String -NotMatch "$dont_match"
    $origin_refs = $non_matching_refs | Select-String "refs/remotes/origin/"
    $my_refs = $origin_refs | Select-String "$Name"
    $exclude_head = $my_refs | Select-String -NotMatch "refs/remotes/origin/HEAD"
    return $exclude_head
}

# +---------------+
# | General calls |
# +---------------+------------------------------------------------------------
function Call-GitStatus {
    git status
}
function Call-GitStatusModified {
    git status -uno
}
function Call-GitLog {
    git log
}
function Call-GitLogOneline {
    git log --oneline
}
function Call-GitLogFull {
    git log -p
}

# +-------------+
# | Fuzzy calls |
# +-------------+--------------------------------------------------------------
function Call-FuzzyGitRebaseInteractive {
    param (
        [switch] $Squash
    )
    $hash = Get-FuzzyGitHash

    if ($Squash) {
        git rebase --interactive --autosquash $hash
    } else {
        git rebase --interactive $hash
    }
}

function Call-FuzzyGitAdd {
    $files = Get-FuzzyGitStatusFiles

    foreach($file in $files) {
        git add $file
    }
}

function Call-FuzzyGitBlame {
    fzf --bind "enter:become(git blame {})"
}

