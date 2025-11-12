if (-not (Get-Command -CommandType Application -ErrorAction SilentlyContinue yazi)) {
    Write-Error "yazi: command not found. make sure it is installed and in path"
    return
}

function Invoke-YaziRememberCwd {
    $tmp = (New-TemporaryFile).FullName
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp -Encoding UTF8
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
    }
    Remove-Item -Path $tmp
}

# defined in the per-machine config file, leave undefined if not on Windows
# points to the ${Git for Windows}/usr/bin/file.exe for mime type detection
# see https://yazi-rs.github.io/docs/installation#windows
$env:YAZI_FILE_ONE=$Global:YaziWindowsFileExecutable

if (-not (Test-Path -Path "${env:APPDATA}\yazi\config\package.toml")) {
    ya pkg add Mintass/rose-pine-dawn
    ya pkg add Mintass/rose-pine
    ya pkg add Mintass/rose-pine-moon
}
