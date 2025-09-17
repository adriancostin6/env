$Global:GitState = @{
    LastHash = $null
}

$env:GitPs1Cache = "${env:PWSH_CFG_CACHE_DIR}/git"
New-Item -Force -ItemType Directory -Path $env:GitPs1Cache | Out-Null

[string] $hashFile = "${env:GitPs1Cache}/hash"
if (Test-Path -Path $hashFile) {
    $Global:GitState.LastHash = Get-Content -Path $hashFile
}

function Get-FuzzyGitStatusFiles {
    [OutputType([System.Collections.ArrayList])]

    [string] $repoRoot = git rev-parse --show-toplevel
    [string] $gitStatus = git status --porcelain | fzf --multi

    $files = [System.Collections.ArrayList]@()
    foreach($line in $gitStatus) {
        [string[]] $tokens = $line -split " "
        [string] $file = $tokens[-1]
        [void] $files.add("$repoRoot/$file")
    }

    return $files
}

function Get-FuzzyGitHash {
    [OutputType([string])]

    [string] $log_line = git log --oneline | fzf --ansi
    [string[]] $split= $log_line -split " "
    [string] $hash = $split[0]

    return $hash
}

function Get-OwnedGitBranches {
    [OutputType([string[]])]

    param (
        [Parameter(Mandatory)][string] $Name
    )

    [string[]] $git_args = @(
        "--sort=committerdate",
        "--format='%(committerdate) %09 %(authorname) %09 %(refname)'",
        "refs/remotes"
    )
    [string[]] $refs = git for-each-ref @git_args
    [string] $dont_match = "[S-Z]-[0-9][0-9][0-9][0-9]\.[0-9][0-9]"
    [string[]] $non_matching_refs = $refs | Select-String -NotMatch "$dont_match"
    [string[]] $origin_refs = $non_matching_refs | Select-String "refs/remotes/origin/"
    [string[]] $my_refs = $origin_refs | Select-String "$Name"
    [string[]] $exclude_head = $my_refs | Select-String -NotMatch "refs/remotes/origin/HEAD"

    return $exclude_head
}

function Invoke-GitStatus {
    git status
}

function Invoke-GitStatusModified {
    git status -uno
}

function Invoke-GitLog {
    git log
}

function Invoke-GitLogOneline {
    git log --oneline
}

function Invoke-GitLogFull {
    git log -p
}

function Invoke-GitCloneWorktree {
    param (
        [Parameter(Mandatory)][string] $Url
    )
    [string[]] $split_url = $Url -split "/"
    [string] $repo_name = $split_url[-1] -replace ".git", ""

    New-Item -Name "$repo_name" -Type Directory
    Push-Location "$repo_name"

    git clone --bare "$Url" .bare
    "gitdir: ./.bare" | Out-File ".git"

    git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    git fetch origin

    Pop-Location
}

function Invoke-GitFixup {
    param (
        [string] $Type
    )
    if (!$Global:GitState.LastHash) {
        Invoke-FuzzyGitFixup -DryRun
    }
    [string] $hash = $Global:GitState.LastHash

    if ($Type) {
        git commit --fixup="${Type}:${hash}"
    } else {
        git commit --fixup "$hash"
    }
}

function Invoke-GitFixupReword {
    Invoke-GitFixup -Type reword
}

function Invoke-GitFixupAmend {
    Invoke-GitFixup -Type amend
}

# +-------------+
# | Fuzzy calls |
# +-------------+--------------------------------------------------------------
function Invoke-FuzzyGitFixup {
    param (
        [switch] $DryRun,
        [string] $Type
    )
    $Global:GitState.LastHash = Get-FuzzyGitHash
    $Global:GitState.LastHash | Out-File -FilePath "${env:GitPs1Cache}/hash"

    if ($DryRun) {
        return
    }

    if ($Type) {
        git commit --fixup="${Type}:${Global:GitState.LastHash}"
    } else {
        git commit --fixup "$Global:GitState.LastHash"
    }
}

function Invoke-FuzzyGitFixupReword {
    Invoke-FuzzyGitFixup -Type reword
}

function Invoke-FuzzyGitFixupAend {
    Invoke-FuzzyGitFixup -Type amend
}

function Invoke-FuzzyGitRebaseInteractive {
    param (
        [switch] $Squash
    )
    [string] $hash = Get-FuzzyGitHash

    if ($Squash) {
        git rebase --interactive --autosquash $hash
    } else {
        git rebase --interactive $hash
    }
}

function Invoke-FuzzyGitAdd {
    [string[]] $files = Get-FuzzyGitStatusFiles

    foreach($file in $files) {
        git add $file
    }
}

function Invoke-FuzzyGitBlame {
    fzf --bind "enter:become(git blame {})"
}
