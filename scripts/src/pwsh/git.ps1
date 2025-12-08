# +-------+
# | State |
# +-------+--------------------------------------------------------------------
$Global:GitState = @{
    LastHash = $null
}

$env:GitPs1Cache = "${env:PWSH_CFG_CACHE_DIR}/git"
New-Item -Force -ItemType Directory -Path $env:GitPs1Cache | Out-Null

[string] $hashFile = "${env:GitPs1Cache}/hash"
if (Test-Path -Path $hashFile) {
    $Global:GitState.LastHash = Get-Content -Path $hashFile
}

# +---------+
# | Helpers |
# +---------+------------------------------------------------------------------
function Get-FuzzyGitStatusFiles {
    [OutputType([System.Collections.ArrayList])]

    [string] $repoRoot = git rev-parse --show-toplevel
    [string[]] $gitStatus = git status --porcelain | fzf --multi

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

function Get-FuzzyGitWorktree {
    [OutputType([string])]

    $out = git worktree list --porcelain | rg worktree | fzf
    $split = $out -split ' ' # don't care about multiple spaces for now
    return $split[1]
}

function Get-GitBranchName {
    [OutputType([string])]

    $name = git rev-parse --abbrev-ref HEAD
    return $name
}

function Test-GitIsInsideWorktree {
    if (-not (git rev-parse --is-inside-work-tree)) {
        return $false
    }
    return $true
}
function Get-GitCurrentWorktree {
    if (-not (Test-GitIsInsideWorktree)) {
        return $null
    }
    $current = git rev-parse --show-toplevel
    return  $current
}

# +---------+
# | Invokes |
# +---------+------------------------------------------------------------------
function Invoke-GitAddInteractive {
    git add --interactive
}

function Invoke-GitStatus {
    git status
}

function Invoke-GitStatusModified {
    git status -uno
}

function Invoke-GitLog {
    git log $args
}

function Invoke-GitLogOneline {
    git log --oneline $args
}

function Invoke-GitLogFull {
    git log -p $args
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

function Invoke-GhCloneWorktree {
    param (
        [Parameter(Mandatory)][string] $Url
    )
    [string[]] $split_url = $Url -split "/"
    [string] $repo_name = $split_url[-1] -replace ".git", ""

    New-Item -Name "$repo_name" -Type Directory
    Push-Location "$repo_name"

    gh repo clone "$Url" .bare -- --bare
    "gitdir: ./.bare" | Out-File ".git"

    git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    git fetch origin

    Pop-Location
}

function Invoke-GitFixup {
    param (
        [string] $Type
    )

    if (-not $Global:GitState.LastHash) {
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

function Invoke-FuzzyGitFixup {
    param (
        [switch] $DryRun,
        [string] $Type
    )

    [string] $hash = Get-FuzzyGitHash
    if (-not $hash) {
        return
    }
    $Global:GitState.LastHash = $hash
    $Global:GitState.LastHash | Out-File -FilePath "${env:GitPs1Cache}/hash"

    if ($DryRun) {
        return
    }

    if ($Type) {
        git commit --fixup="${Type}:$($Global:GitState.LastHash)"
    } else {
        git commit --fixup $Global:GitState.LastHash
    }
}

function Invoke-GitSwitchWorktree {
    $worktree = Get-FuzzyGitWorktree
    if (-not $worktree) {
        return
    }
    Set-Location -Path $worktree
}

function Invoke-GitRemoveWorktree {
    $worktree = Get-FuzzyGitWorktree
    git worktree remove --force $worktree
}

function Invoke-GitCreateWorktree {
    param (
        [Parameter(Mandatory)][string] $Name,
        [Parameter(Mandatory)][string] $Branch
    )
    git worktree add $Name $Branch
}

function Invoke-FuzzyGitFixupReword {
    Invoke-FuzzyGitFixup -Type reword
}

function Invoke-FuzzyGitFixupAmend {
    Invoke-FuzzyGitFixup -Type amend
}

function Invoke-FuzzyGitRebaseInteractive {
    param (
        [switch] $Squash
    )

    [string] $hash = Get-FuzzyGitHash
    if (-not $hash) {
        return
    }

    if ($Squash) {
        git rebase --interactive --autosquash $hash
    } else {
        git rebase --interactive $hash
    }
}

function Invoke-FuzzyGitRebaseInteractiveSquash {
    Invoke-FuzzyGitRebaseInteractive -Squash
}

function Invoke-FuzzyGitAdd {
    param (
        [switch] $Patch
    )

    [string[]] $files = Get-FuzzyGitStatusFiles
    if (-not $files) {
        return
    }

    foreach($file in $files) {
        if ($Patch) {
            git add --patch $file
        } else {
            git add $file
        }
    }
}
function Invoke-FuzzyGitAddPatch {
    Invoke-FuzzyGitAdd -Patch
}

function Invoke-FuzzyGitRestore {
    param(
        [switch] $Staged
    )

    [string[]] $files = Get-FuzzyGitStatusFiles
    if (-not $files) {
        return
    }


    foreach($file in $files) {
        if ($Staged) {
            git restore --staged $file
        } else {
            git restore $file
        }
    }
}

function Invoke-FuzzyGitRestoreStaged {
    Invoke-FuzzyGitRestore -Staged
}

function Invoke-FuzzyGitBlame {
    fzf --bind "enter:become(git blame {})"
}

function Invoke-GitPush {
    # problem here is that we have to specify these two first, or else we push
    # to random bogus. fix it by saying these will be last. how I do not know
    param (
        [Parameter(Mandatory=$false)][string] $Remote,
        [Parameter(Mandatory=$false)][string] $Branch
    )

    $what = $Branch
    if (-not $what) {
        $branch = Get-GitBranchName
        if (-not $branch) {
            Write-Error "git: cannot push, branch name not found."
            return
        }

        $risky = @('master', 'main')
        if ($branch -in $risky) {
            $confirm = Read-Host "Are you sure you want to push to ${branch}? (y/N)"
            if (-not $confirm -eq 'y') {
                return
            }
        }

        $what = $branch
    }


    # gpush --force ssh works for pushing to master
    # gpush ssh master --force does not
    #Invoke-GitPush: A positional parameter cannot be found that accepts argument '--force'.
    if (-not $Remote) {
        git push $args origin $what
        return
    }
    git push $args $Remote $what
}

function Invoke-GitPushSimple {
    param (
        [Parameter(Mandatory)][string] $Remote,
        [Parameter(Mandatory)][string] $Branch
    )
    Invoke-GitPush $Remote $Branch
}

function Invoke-GitCleanInFolder {
    param (
        [Parameter (Mandatory)] $FolderPath
    )

    Set-Location -Path $FolderPath && git clean -fdx && Set-Location -Path -
}

function Invoke-FuzzyGitEditCommitFiles {
    $hash = Get-FuzzyGitHash
    if (-not $hash) {
        return
    }
    $files = git diff-tree --no-commit-id --name-only $hash -r 
    $files | fzf --multi --bind 'enter:become(nvim {+})'
}

# +---------+
# | Wrapper |
# +---------+------------------------------------------------------------------
function Invoke-GitWrapper {
    $cmds = @{
        'status'                            = 'Invoke-GitStatus'
        'status (modified)'                 = 'Invoke-GitStatusModified'
        'log'                               = 'Invoke-GitLog'
        'log (patch)'                       = 'Invoke-GitLogFull'
        'log (oneline)'                     = 'Invoke-GitLogOneline'
        'rebase (interactive)'              = 'Invoke-FuzzyGitRebaseInteractive'
        'rebase (interactive, autosquash)'  = 'Invoke-FuzzyGitRebaseInteractiveSquash'
        'add'                               = 'Invoke-FuzzyGitAdd'
        'add (patch)'                       = 'Invoke-FuzzyGitAddPatch'
        'add (interactive)'                 = 'Invoke-GitAddInteractive'
        'restore'                           = 'Invoke-FuzzyGitRestore'
        'restore (staged)'                  = 'Invoke-FuzzyGitRestoreStaged'
        'blame'                             = 'Invoke-FuzzyGitBlame'
        'fixup'                             = 'Invoke-FuzzyGitFixup'
        'fixup (reword)'                    = 'Invoke-FuzzyGitFixupReword'
        'fixup (amend)'                     = 'Invoke-FuzzyGitFixupAmend'
        'push'                              = 'Invoke-GitPushSimple'
        'worktree (clone)'                  = 'Invoke-GitCloneWorktree'
        'worktree (clone gh cli)'           = 'Invoke-GhCloneWorktree'
        'worktree (switch)'                 = 'Invoke-GitSwitchWorktree'
        'worktree (create)'                 = 'Invoke-GitCreateWorktree'
        'worktree (remove)'                 = 'Invoke-GitRemoveWorktree'
        'edit commit files'                 = 'Invoke-FuzzyGitEditCommitFiles'
    }

    $cmd = $cmds.Keys | fzf
    if ($cmd) {
        Invoke-Expression -Command $cmds[$cmd]
    }
}

# +-------+
# | Setup |
# +-------+------------------------------------------------------------------

if (-not (Test-Path -Path "${HOME}/.gitconfig-local")) {
    $localGitConfigLines = @(
        '#[includeIf "gitdir:/path/we/include/for/"]',
        "#`tpath = ~/.gitconfig-includeIf",
        '#[includeIf "gitdir:C:/Windows/path/we/include/for/"]',
        "#`tpath = ~/.gitconfig-includeIf"
    )
    $localGitConfig = $localGitConfigLines -join "`n"
    $localGitConfig | Out-File -NoNewline -FilePath "${HOME}/.gitconfig-local"

    if (-not (Test-Path -Path "${HOME}/.gitconfig-includeIf")) {
        $includeIfGitConfigLines = @(
            '#[user]',
            "#`temail = adrianc@work.com"
        )
        $includIfGitConfig = $includeIfGitConfigLines -join "`n"
        $includIfGitConfig | Out-File -NoNewline -FilePath "${HOME}/.gitconfig-includeIf"
    }
}

