if (Test-Path -Path $HOME/.pwsh/config/init.ps1)
{
    . $HOME/.pwsh/config/init.ps1
}

Push-Location "$HOME/env/scripts"
. ./init.ps1
Pop-Location

posh-windows-amd64 --config "~/env/configurations/oh-my-posh/.adrianc.omp.json" init pwsh | Invoke-Expression
