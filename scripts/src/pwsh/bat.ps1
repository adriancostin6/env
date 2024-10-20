if (-not (Get-Command -CommandType Application -ErrorAction SilentlyContinue bat)) {
    Write-Error "bat: command not found, please install it for pretty colors."
    return
}
