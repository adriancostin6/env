if (-not (Get-Command -CommandType Application -ErrorAction SilentlyContinue bat)) {
    Write-Error "bat: command not found, please install it for pretty colors."
    return
}

$env:BatPs1Cache = "${env:PWSH_CFG_CACHE_DIR}/bat"
New-Item -Force -ItemType Directory -Path $env:BatPs1Cache | Out-Null

$Global:BatThemes = @(
    'Catppuccin Latte',
    'Catppuccin Frappe',
    'Catppuccin Macchiato',
    'Catppuccin Mocha'
)

function Get-DefaultBatTheme {
    [OutputType([string])]

    [string] $themeFile = "${env:BatPs1Cache}/theme"
    if (Test-Path -Path $themeFile) {
        [string] $theme = Get-Content -Path $themeFile
        return $theme
    }
    return 'ansi'
}

function Update-BatTheme {
    param (
        [switch] $BuildBatCache
    )

    if ($BuildBatCache) {
        bat cache --build
    }

    [string] $theme = $Global:BatThemes | fzf
    $env:BAT_THEME=$theme

    $env:BAT_THEME | Out-File -FilePath "${env:BatPs1Cache}/theme"
    Write-Output "bat: default theme set to $env:BAT_THEME."
}


$env:BAT_THEME=Get-DefaultBatTheme

[bool] $isSetupDone = $env:BAT_THEME -ne 'ansi'
if ($isSetupDone) { # we already did the setup
    return
}

[string] $batCfg = bat --config-dir
New-Item -Force -Path "${batCfg}/themes" -ItemType Directory | Out-Null

if (-not (Test-Path -Path $batCfg\themes\*)) {
    Write-Warning "bat: theme folder is empty, trying to download some themes."

    [string[]] $urls = @(
        "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme",
        "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme",
        "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme",
        "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme"
    )

    try {
        [int] $i = 0;
        foreach ($url in $urls) {
            [int] $progress = ($i / $urls.Count) * 100
            Write-Progress -Activity "Downloading themes..." -PercentComplete $progress -Status $url
            Invoke-WebRequest -ProgressAction SilentlyContinue -Uri $url -OutFile "${batCfg}/themes"
            $i = $i + 1
        }
    } catch [System.Net.WebException] {
        Write-Error "bat: theme folder is empty and no themes could be downloaded, have a look if you want pretty colors."
        return
    }
}

Update-BatTheme -BuildBatCache
