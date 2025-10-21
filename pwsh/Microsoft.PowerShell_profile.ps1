Push-Location "$HOME/env/scripts"
. ./init.ps1
Pop-Location

# https://matt.kotsenas.com/posts/pwsh-profiling-async-startup
[System.Collections.Queue] $asyncModules = @(
    {
        oh-my-posh --config "~/env/oh-my-posh/.adrianc.omp.json" init pwsh | Invoke-Expression
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
