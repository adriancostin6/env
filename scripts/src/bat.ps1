$bat_theme=Get-DefaultBatTheme
if ($bat_theme == 'ansi') {
    return
}
$env:BAT_THEME=$bat_theme

if (-not (Get-Command -CommandType Application -ErrorAction SilentlyContinue bat)) {
    Write-Error "bat: command not found, please install it for pretty colors."
    return
}

$bat_config = bat --config-dir

if (-not (Test-Path -Path $bat_config)) {
    Write-Warning "bat: theme folder not found, creating."
    New-Item -Path $themes -ItemType Directory -Force
}

$Global:BatThemes = @(
    'Catppuccin Latte',
    'Catppuccin Frappe',
    'Catppuccin Macchiato',
    'Catppuccin Mocha'
)
function Update-BatTheme {
    param (
        [switch] $BuildCache
    )

    if ($BuildCache) {
        bat cache --build
        Clear-Host
    }

    $theme = $Global:BatThemes | fzf
    $env:BAT_THEME=$theme
}

function Get-DefaultBatTheme {
    if (Test-Path -Path "${HOME}/.bat") {
        $theme = Get-Content -Path "${HOME}/.bat"
        return $theme
    }
    return 'ansi'
}

if (-not (Test-Path -Path $bat_config\themes\*)) {
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

    Update-BatTheme -BuildCache
    $env:BAT_THEME | Out-File -FilePath "${HOME}/.bat"
    Clear-Host
    Write-Output "bat: default theme set to $env:BAT_THEME."
}
