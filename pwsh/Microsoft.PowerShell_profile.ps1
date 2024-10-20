Push-Location "$HOME/env/scripts"
. ./init.ps1
Pop-Location

oh-my-posh --config "~/env/oh-my-posh/.adrianc.omp.json" init pwsh | Invoke-Expression
