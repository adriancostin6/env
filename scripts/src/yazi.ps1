if (-not (Get-Command -CommandType Application -ErrorAction SilentlyContinue yazi)) {
    Write-Error "yazi: command not found. make sure it is installed and in path"
    return
}

# defined in the per-machine config file, leave undefined if not on Windows
# points to the ${Git for Windows}/usr/bin/file.exe for mime type detection
# see https://yazi-rs.github.io/docs/installation#windows
$env:YAZI_FILE_ONE=$Global:YaziWindowsFileExecutable

ya pkg add Mintass/rose-pine-dawn
ya pkg add Mintass/rose-pine
ya pkg add Mintass/rose-pine-moon
