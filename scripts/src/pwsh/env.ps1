function Source-BatchFile {
    param (
        [Parameter(Mandatory)][string] $Batch
    )

    $lines = cmd /c "call $Batch && set"
    foreach ($line in $lines) {
      if ($line -match '^[^=]+=') {
        $name, $value = $line -split '=', 2
        Set-Item -Path "Env:$name" -Value $value
      }
    }
}
