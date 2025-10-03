# +-------+
# | State |
# +-------+--------------------------------------------------------------------
$env:GdPs1Cache = "${env:PWSH_CFG_CACHE_DIR}/gd"
New-Item -Force -ItemType Directory -Path $env:GdPs1Cache | Out-Null

$GdPaths = [System.Collections.ArrayList]::new()
[string] $GdExec = $null

[string] $gdPathsFile = "${env:GdPs1Cache}/paths"
if (Test-Path -Path $gdPathsFile) {
    $paths = Get-Content -Path $gdPathsFile
    if ($paths) {
        $GdPaths.Add($paths) | Out-Null
    }
}
# Make an array list from it, so we can pop and push new items

[string] $gdExecFile = "${env:GdPs1Cache}/exec"
if (Test-Path -Path $gdExecFile) {
    $GdExec = Get-Content -Path $gdExecFile
}

# +---------+
# | Helpers |
# +---------+------------------------------------------------------------------
function Add-GdPath {
    $current = (Get-Location).Path
    if (-not ($GdPaths -contains $current)) {
        [void]$GdPaths.Add($current) | Out-Null
        $current | Add-Content -Path $gdPathsFile
    }
}

function Remove-OldestGdPath {
    $GdPaths.RemoveAt(0)
    $GdPaths | Out-File -Path $gdPathsFile

}

function Remove-CwdGdPath {
    $current = (Get-Location).Path
    $GdPaths.Remove($current)
    $GdPaths | Out-File -Path $gdPathsFile
}

function Clear-GdPaths {
    $GdPaths.Clear()
    Remove-Item -Path $gdPathsFile -Force
}

# +---------+
# | Invokes |
# +---------+------------------------------------------------------------------
function Invoke-FuzzyGdPathChangeDirectory {
    $dir = $GdPaths | fzf
    if ($dir) {
        Set-Location -Path "$dir"
    }
}
function Invoke-FuzzyFindAndCd {
    $dir = fd --type d | fzf
    if ($dir) {
        Set-Location -Path "$dir"
    }
}

function Invoke-FuzzyCd {
    param (
        [switch] $FindDirsFromCwd,
        [switch] $FindDirsFromGdHistory,
        [switch] $Exec
    )

    if ($FindDirsFromCwd) {
        Invoke-FuzzyFindAndCd
        return
    }

    if ($FindDirsFromGdHistory) {
        Invoke-FuzzyGdPathChangeDirectory
    }

    if (-not $Exec) {
        return
    }

    if ($GdExec) {
        Invoke-Expression -Command "$GdExec"
        return
    }

    $cmd = Read-Host "Enter command you want to run after switching dirs"
    if (-not $cmd) {
        Write-Warning "Please enter a valid command."
        return
    }
    $cmd | Out-File -Path "$gdExecFile"
    $GdExec = $cmd
    Invoke-Expression -Command "$cmd"
}

# +---------+
# | Wrapper |
# +---------+------------------------------------------------------------------
function Invoke-FuzzyGdWrapper {
    $opts = @(
        'history',
        'find',
        'history + exec',
        'find + exec',
        'add',
        'pop',
        'remove',
        'clear'
    )
    $mapping = @{
        'history'           = 'Invoke-FuzzyCd -FindDirsFromGdHistory'
        'find'              = 'Invoke-FuzzyCd -FindDirsFromCwd'
        'history + exec'    = 'Invoke-FuzzyCd -FindDirsFromGdHistory -Exec'
        'find + exec'       = 'Invoke-FuzzyCd -FindDirsFromCwd -Exec'
        'add'               = 'Add-GdPath'
        'pop'               = 'Remove-OldestGdPath'
        'remove'            = 'Remove-CwdGdPath'
        'clear'             = 'Clear-GdPaths'
    }

    $opt = $opts | fzf
    if (-not $opt) { 
        return
    }
    Invoke-Expression -Command $mapping[$opt]
}
