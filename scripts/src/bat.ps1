if ($is_bat_configured) {
    return
}

if (-not (Get-Command -CommandType Application -ErrorAction SilentlyContinue bat)) {
    Write-Error "bat: command not found, please install it for pretty colors."
    return
}

$bat_config = bat --config-dir

if (-not (Test-Path -Path $bat_config)) {
    Write-Warning "bat: theme folder not found, creating."
    New-Item -Path $themes -ItemType Directory -Force
}

if (Test-Path -Path $bat_config\themes\*) {
    return
}
Write-Warning "bat: theme folder is empty, trying to download some themes."

$urls = @(
    "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme",
    "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme",
    "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme",
    "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme"
)

try {
    $i = 0;
    foreach ($url in $urls) {
        $progress = ($i / $urls.Count) * 100
        Write-Progress -Activity "Downloading themes..." -PercentComplete $progress -Status $url
        Invoke-WebRequest -ProgressAction SilentlyContinue -Uri $url -OutFile "${bat_config}/themes"
        $i = $i + 1
    }
} catch [System.Net.WebException] {
    Write-Error "bat: theme folder is empty and no themes could be downloaded, have a look if you want pretty colors."
    return
}

Write-Output "bat: pretty colors have been stored in ${bat_config}\themes. Please run 'bat cache --build.'"
