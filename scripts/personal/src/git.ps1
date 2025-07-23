# +-------+
# | State |
# +-------+--------------------------------------------------------------------
$Global:GitState = @{
    LastHash = $null
}

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

# +-------+
# | Calls |
# +-------+--------------------------------------------------------------------
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

function Call-GitCloneWorktree {
    param (
        [Parameter(Mandatory)][string] $Url
    )
    $split_url = $Url -split "/"
    $repo_name = $split_url[-1] -replace ".git", ""

    New-Item -Name "$repo_name" -Type Directory
    Push-Location "$repo_name"

    git clone --bare "$Url" .bare
    "gitdir: ./.bare" | Out-File ".git"

    git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    git fetch origin

    Pop-Location
}

function Call-GitFixup {
    param (
        [string] $Type
    )
    if (!$Global:GitState.LastHash) {
        Call-FuzzyGitFixup -DryRun
    }
    $hash = $Global:GitState.LastHash

    if ($Type) {
        git commit --fixup="${Type}:${hash}"
    } else {
        git commit --fixup "$hash"
    }
}

# +-------------+
# | Fuzzy calls |
# +-------------+--------------------------------------------------------------
function Call-FuzzyGitFixup {
    param (
        [switch] $DryRun,
        [string] $Type
    )
    $Global:GitState.LastHash = Get-FuzzyGitHash

    if ($DryRun) {
        return
    }

    if ($Type) {
        git commit --fixup="${Type}:${Global:GitState.LastHash}"
    } else {
        git commit --fixup "$Global:GitState.LastHash"
    }
}

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
