New-Item -ItemType SymbolicLink -Path "$PROFILE" -Target "$HOME/env/pwsh/Microsoft.PowerShell_profile.ps1"
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA/nvim" -Target "$HOME/env/nvim"
New-Item -ItemType SymbolicLink -Path "$HOME/.config/git" -Target "$HOME/env/git"
New-Item -ItemType SymbolicLink -Path "$HOME/.config/wezterm" -Target "$HOME/env/wezterm"
