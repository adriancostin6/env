$env:PWSH_CFG_LOCAL_DIR = "${HOME}/.pwsh/config"
New-Item -Force -Type Directory -Path $env:PWSH_CFG_LOCAL_DIR | Out-Null

[string] $init = "${env:PWSH_CFG_LOCAL_DIR}/init.ps1"
if (-not (Test-Path -Path $init)) {
    "# Local machine configuration" | Out-File -FilePath $init
}

. "${HOME}/.pwsh/config/init.ps1" #  machine specific config
