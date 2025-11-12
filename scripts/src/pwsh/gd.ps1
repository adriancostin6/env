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
    "" | Out-File -Path $gdPathsFile
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
        [ValidateSet('Find', 'History', 'fd', 'old')]
        [string] $Type,

        [switch] $Exec
    )

    if (-not $Type) {
        return
    }

    switch -regex ($Type) {
        '^(Find|fd)$' { Invoke-FuzzyFindAndCd }
        '^(History|old)$' { Invoke-FuzzyGdPathChangeDirectory }
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

function Get-GdStatus {
    $gdPaths = Get-Content -Raw -Path $gdPathsFile
    $gdCmd = Get-Content -Raw -Path $gdExecFile

    $msg =  @(
        'Currently stored paths are',
        "---------------------------",
        "${gdPaths}",
        "Currently stored command is",
        "---------------------------"
        $gdCmd
    ) -join "`n"
    Write-Output $msg
}

function Update-GdCommand {
    param (
        [string] $Command,
        [switch] $Wipe
    )

    if ($Wipe) {
        "" | Out-File -Path $gdExecFile
        return
    }

    if (-not $Command) {
        return
    }
    $Command | Out-File -Path $gdExecFile
}

function Update-GdCache {
    param (
        [ValidateSet(
            'List', 'Add', 'Remove', 'Pop', 'Clear',
            'list', 'add', 'remove', 'pop', 'clear',
            'ls', 'rm',
            'Command',
            'command',
            'cmd'
        )]
        [string] $Action,
        [string] $Extra
    )

    if (-not $Action) {
        return
    }

    $mapping = @{
        'Add'               = 'Add-GdPath'
        'Remove'            = 'Remove-CwdGdPath'
        'Clear'             = 'Clear-GdPaths'
        'Pop'               = 'Remove-OldestGdPath'

        'rm'                = 'Remove-CwdGdPath'
        'Command'           = 'Update-GdCommand'
        'cmd'               = 'Update-GdCommand'

        'List'              = "Get-GdStatus"
        'ls'                = "Get-GdStatus"
    }
    $cmd = $mapping[$Action]
    $cmd
    switch -regex ($Action) {
        '^(Command|command|cmd)$' {
            if ($Extra) {
                Invoke-Expression -Command "${cmd} -Command ${Extra}"
            } else {
                Invoke-Expression -Command "${cmd} -Wipe"
            }
        }
        default { Invoke-Expression -Command $mapping[$Action] }
    }
}

# +---------+
# | Wrapper |
# +---------+------------------------------------------------------------------

<#
.SYNOPSIS
    Change working directory based on user-specified method.
.DESCRIPTION
    Fuzzy wrapper for gd command. See Get-Help gd.

    Helps manage a history of directories manually added by the user, which can
    be used for navigation. Otherwise, uses an external program to find all
    directories from cwd and navigate to the selected one.

    Options
        cache
            path
                list
                    Used to print information about the state of the gd tool.
                    Here, the user can view the list of stored directories and the last
                    cached command that will run on 'cd' when using the execute mode.
                add
                    Used to add the current working directory to the 'gd' cache.
                remove
                    Used to remove the current working directory from the 'gd' cache.
                pop
                    Used to pop the oldest directory from the 'gd' cache.
                clear
                    Used to clear the gd cache, removing all stored directories.

            command
                add
                    Used to add the specified command to the cache.
                remove
                    Used to remove the current command from the cache.
        find
            Used to navigate by finding all directories from cwd.
        history
            Used to navigate to a remembered directory.
#>
function Invoke-FuzzyGd {
    param (
        [switch] $Execute
    )

    $opt = @(
        'cache',
        'find',
        'history'
    ) | fzf
    if (-not $opt) { 
        return
    }

    switch ($opt) {
        'cache' {
            $cache_opt =  @(
                'list',
                'path',
                'command'
            ) | fzf
            if (-not $cache_opt) { 
                return
            }

            switch ($cache_opt) {
                'path' {
                    $path_cache_opt = @(
                        'add',
                        'pop',
                        'remove',
                        'clear'
                    ) | fzf
                    if (-not $path_cache_opt) { 
                        return
                    }

                    $mapping = @{
                        'add'               = 'Add-GdPath'
                        'pop'               = 'Remove-OldestGdPath'
                        'remove'            = 'Remove-CwdGdPath'
                        'clear'             = 'Clear-GdPaths'
                    }
                    Invoke-Expression -Command $mapping[$path_cache_opt]
                }
                'command' {
                    $command_cache_opt = @(
                        'add',
                        'remove'
                    ) | fzf
                    if (-not $command_cache_opt) { 
                        return
                    }
                    switch ($command_cache_opt) {
                        'add' {
                            $cmd = Read-Host -Prompt "Enter command to run when entering directories"
                            Update-GdCommand -Command $cmd
                        }
                        'remove'  { Update-GdCommand -Wipe }
                    }
                }
                'list' { Get-GdStatus }
                default {}
            }

        }
        default {
            $mapping = @{
                'find'              = 'Invoke-FuzzyCd -Type Find'
                'history'           = 'Invoke-FuzzyCd -Type History'
            }

            $cmd = Get-Content -Path $gdExecFile
            $run_command = $false
            if ($cmd) {
                if ($Execute) {
                    $confirm = Read-Host -Prompt "Execute '${cmd}' when entering directory? (Y/n)"
                    $run_command = ($confirm -notmatch "^(n|N)$")
                }
            }

            $runnable = $mapping[$opt]
            if ($run_command) {
                $runnable = "$runnable -Exec"
            }
            Invoke-Expression -Command "${runnable}"
        }
    }
}

<#
.SYNOPSIS
    Change working directory based on user-specified method.
.DESCRIPTION
    Helps manage a history of directories manually added by the user, which can
    be used for navigation. Otherwise, uses an external program to find all
    directories from cwd and navigate to the selected one.
.PARAMETER Action
    This parameter tells gd which action can be executed
        History | history | old
            Used to navigate to a remembered directory.
        Find | find | fd
            Used to navigate by finding all directories from cwd.
        List | list | ls
            Used to print information about the state of the gd tool.
            Here, the user can view the list of stored directories and the last
            cached command that will run on 'cd' when using the execute mode.
        Add | add
            Used to add the current working directory to the 'gd' cache.
        Remove | remove | rm
            Used to remove the current working directory from the 'gd' cache.
        Pop | pop
            Used to pop the oldest directory from the 'gd' cache.
        Pop | pop
            Used to pop the oldest directory from the 'gd' cache.
        Clear | clear
            Used to clear the gd cache, removing all stored directories.
        Command | command | cmd
            Used to update or remove the current gd command. If no parameter is
            supplied, the default behavior is to wipe the most recent command
            from cache.
.PARAMETER Extra
    Optional parameter to send extra input data to some of the commands in the
    gd chain.
.PARAMETER Execute
    Switch that tells gd if it should execute a command upon changing directory.
    Command is cached on the filesystem, can be viewed with 'gd {list | ls}'.
#>
function Invoke-GdWrapper {
    param (
        [ValidateSet(
            'History', 'Find',
            'old', 'fd',

            'List', 'Add', 'Remove', 'Pop', 'Clear',
            'ls', 'add', 'rm', 'pop', 'clear',

            'Command',
            'cmd'
        )]
        [string] $Action,
        [string] $Extra,
        [switch] $Execute
    )

    if (-not $Action){
        if ($Execute) {
            Invoke-FuzzyGd -Execute
        } else {
            Invoke-FuzzyGd
        }
        return
    }

    $cdRegex = [string]::Format(
        "^({0})$",
        @(
            'History|history|old'
            'Find|find|fd'
        ) -join '|'
    )
    $cacheRegex = [string]::Format(
        "^({0})$",
        @(
            'Add|add',
            'List|list|ls',
            'Remove|remove|rm',
            'Pop|pop',
            'Clear|clear',
            'Command|command|cmd'
        ) -join '|' 
    )
    switch -regex ($Action) {
        $cdRegex {
            if ($Execute) {
                Invoke-FuzzyCd -Type $Action -Exec
            } else {
                Invoke-FuzzyCd -Type $Action
            }
        }

        $cacheRegex {
            if ($Extra) {
                Update-GdCache -Action $Action -Extra $Extra
            } else {
                Update-GdCache -Action $Action
            }
        }
    }

}

function Invoke-GdWrapperEx {
    if ($args) {
        Invoke-GdWrapper -Action $args[0] -Execute
    } else {
        Invoke-GdWrapper -Execute
    }
}
