#Requires -RunAsAdministrator

# Wipe existing configs
Remove-Item -Force -Path "$PROFILE"
Remove-Item -Force -Recurse -Path "$env:APPDATA/yazi/config"
Remove-Item -Force -Recurse -Path "$env:LOCALAPPDATA/nvim"
Remove-Item -Force -Recurse -Path "$HOME/.config/git"
Remove-Item -Force -Recurse -Path "$HOME/.config/wezterm"
Remove-Item -Force -Recurse -Path "$HOME/.pwsh"

# Install stuff
Install-Module -Name PSFzf

# Link configs
New-Item -ItemType SymbolicLink -Force -Path "$PROFILE" -Target "$PSScriptRoot/configurations/pwsh/Microsoft.PowerShell_profile.ps1"
New-Item -ItemType SymbolicLink -Force -Path "$env:LOCALAPPDATA/nvim" -Target "$PSScriptRoot/configurations/nvim"
New-Item -ItemType SymbolicLink -Force -Path "$HOME/.config/git" -Target "$PSScriptRoot/configurations/git"
New-Item -ItemType SymbolicLink -Force -Path "$HOME/.config/wezterm" -Target "$PSScriptRoot/configurations/wezterm"
New-Item -ItemType SymbolicLink -Force -Path "$env:APPDATA/yazi/config" -Target "$PSScriptRoot/configurations/yazi"

# Setup cache and config directories
New-Item -Force -Type Directory -Path "${HOME}/.pwsh/config"| Out-Null
New-Item -Force -Type Directory -Path "${HOME}/.pwsh/cache"| Out-Null

[string] $init = "${HOME}/.pwsh/config/init.ps1"
if (-not (Test-Path -Path $init)) {
    "# Local machine configuration" | Out-File -FilePath $init
}

# FIXME: we want to make sure the tools are installed, right?
if (Get-Command -CommandType Application -ErrorAction SilentlyContinue ya) {
    if (-not (Test-Path -Path "${env:APPDATA}\yazi\config\package.toml")) {
        ya pkg add Mintass/rose-pine-dawn
        ya pkg add Mintass/rose-pine
        ya pkg add Mintass/rose-pine-moon
        ya pkg add Chromium-3-Oxide/everforest-medium
    }
}
