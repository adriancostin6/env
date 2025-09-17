$env:PWSH_CFG_CACHE_DIR = "${HOME}/.pwsh_cfg/cache"
New-Item -Force -Type Directory -Path $env:PWSH_CFG_CACHE_DIR | Out-Null
