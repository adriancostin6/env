if (Test-Path -Path $HOME/.pwsh/config/init.ps1)
{
    . $HOME/.pwsh/config/init.ps1
}

Push-Location "$HOME/env/scripts"
. ./init.ps1
Pop-Location

# https://matt.kotsenas.com/posts/pwsh-profiling-async-startup
[System.Collections.Queue] $asyncModules = @(
    {
        posh-windows-amd64 --config "~/env/configurations/oh-my-posh/.adrianc.omp.json" init pwsh | Invoke-Expression
        $env:OhMyPoshPs1Loaded = $true
    }
)
Register-EngineEvent -SourceIdentifier PowerShell.OnIdle -SupportEvent -Action {
    if ($asyncModules.Count -gt 0) {
        & $asyncModules.Dequeue()
    } else {
        Unregister-Event -SubscriptionId $EventSubscriber.SubscriptionId -Force
        Remove-Variable -Name 'asyncModules' -Scope Global -Force
        [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
    }
}
