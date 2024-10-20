Import-Module PSFzf

Set-PsFzfOption `
    -PsReadlineChordProvider 'Ctrl-t' `
    -PsReadlineChordReverseHistory 'Ctrl-r' `
    -EnableFd

Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
Set-PsFzfOption -TabExpansion

$env:FZF_ALT_C_COMMAND='fd --type d'

