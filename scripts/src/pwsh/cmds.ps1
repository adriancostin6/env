function Invoke-CmdWithConfirmation {
    param (
        [Parameter (Mandatory)][string] $Command
    )
    $confirm = Read-Host "Running command:`n$cmd`nPlease confirm(y/N)"
    if ($confirm -eq 'y') {
        Invoke-Expression -Command $Command
    }
}
