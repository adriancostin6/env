Get-ChildItem ./ -Recurse -Filter "*.ps1" | ForEach {
    . $_
}
