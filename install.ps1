Remove-Item -Force -Path "$PROFILE"
Remove-Item -Force -Recurse -Path "$env:LOCALAPPDATA/nvim"
Remove-Item -Force -Recurse -Path "$HOME/.config/git"
Remove-Item -Force -Recurse -Path "$HOME/.config/wezterm"

New-Item -ItemType SymbolicLink -Path "$PROFILE" -Target "$HOME/env/pwsh/Microsoft.PowerShell_profile.ps1"
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA/nvim" -Target "$HOME/env/nvim"
New-Item -ItemType SymbolicLink -Path "$HOME/.config/git" -Target "$HOME/env/git"
New-Item -ItemType SymbolicLink -Path "$HOME/.config/wezterm" -Target "$HOME/env/wezterm"
