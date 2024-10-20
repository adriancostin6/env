$ReadlineOpts = @{
    EditMode = 'Vi'
    ViModeIndicator = 'Cursor'
}

Set-PSReadLineOption @ReadlineOpts

# Light/Dark theme overrides based on Everforest pallete
# Because Light themes suck in powershell
function Update-EverforestReadlinePallete {
    param (
        [Parameter(Mandatory)][string] $Variant
    )

    $everforestPalettes = @{
        dark = @{
            fg          = 0xD3C6AA
            fgDim       = 0x9DA9A0
            bgAccent    = 0x3A515D
            red         = 0xE67E80
            orange      = 0xE69875
            yellow      = 0xDBBC7F
            green       = 0xA7C080
            aqua        = 0x83C092
            blue        = 0x7FBBB3
            purple      = 0xD699B6
            neutral     = 0x859289
        }
        light = @{
            fg          = 0x5C6A72
            fgDim       = 0x829181
            bgAccent    = 0xE6E2CC
            red         = 0xF85552
            orange      = 0xF57D26
            yellow      = 0xDFA000
            green       = 0x8DA101
            aqua        = 0x35A77C
            blue        = 0x3A94C5
            purple      = 0xDF69BA
            neutral     = 0x939F91
        }
    }

    $variant = $Variant
    if ($variant -notin @('dark', 'light')) {
        $appsUseLightTheme = (Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name AppsUseLightTheme -ErrorAction SilentlyContinue).AppsUseLightTheme
        $variant = if ($appsUseLightTheme -eq 1) { 'light' } else { 'dark' }
    }

    $ef = $everforestPalettes[$variant]

    $readlineTheme = @{
        Command                = $PSStyle.Foreground.FromRGB($ef.blue)
        Comment                = $PSStyle.Foreground.FromRGB($ef.green)
        ContinuationPrompt     = $PSStyle.Foreground.FromRGB($ef.aqua)
        Default                = $PSStyle.Foreground.FromRGB($ef.fg)
        Emphasis               = $PSStyle.Foreground.FromRGB($ef.yellow)
        Error                  = $PSStyle.Foreground.FromRGB($ef.red)
        InlinePrediction       = $PSStyle.Foreground.FromRGB($ef.fgDim)
        Keyword                = $PSStyle.Foreground.FromRGB($ef.purple)
        ListPrediction         = $PSStyle.Foreground.FromRGB($ef.aqua)
        Member                 = $PSStyle.Foreground.FromRGB($ef.fg)
        Number                 = $PSStyle.Foreground.FromRGB($ef.orange)
        Operator               = $PSStyle.Foreground.FromRGB($ef.neutral)
        Parameter              = $PSStyle.Foreground.FromRGB($ef.blue)
        String                 = $PSStyle.Foreground.FromRGB($ef.green)
        Type                   = $PSStyle.Foreground.FromRGB($ef.aqua)
        Variable               = $PSStyle.Foreground.FromRGB($ef.red)
        ListPredictionSelected = $PSStyle.Background.FromRGB($ef.bgAccent)
        Selection              = $PSStyle.Background.FromRGB($ef.bgAccent)
    }

    Set-PSReadLineOption -Colors $readlineTheme

    $PSStyle.Formatting.FormatAccent       = $PSStyle.Foreground.FromRGB($ef.green)
    $PSStyle.Formatting.TableHeader        = $PSStyle.Foreground.FromRGB($ef.blue)
    $PSStyle.Formatting.ErrorAccent        = $PSStyle.Foreground.FromRGB($ef.orange)
    $PSStyle.Formatting.Error              = $PSStyle.Foreground.FromRGB($ef.red)
    $PSStyle.Formatting.Warning            = $PSStyle.Foreground.FromRGB($ef.yellow)
    $PSStyle.Formatting.Verbose            = $PSStyle.Foreground.FromRGB($ef.blue)
    $PSStyle.Formatting.Debug              = $PSStyle.Foreground.FromRGB($ef.purple)
    $PSStyle.Progress.Style                = $PSStyle.Foreground.FromRGB($ef.yellow)
    $PSStyle.FileInfo.Directory            = $PSStyle.Background.FromRGB($ef.bgAccent) +
                                             $PSStyle.Foreground.FromRGB($ef.fg)
    $PSStyle.FileInfo.SymbolicLink         = $PSStyle.Foreground.FromRGB($ef.aqua)
    $PSStyle.FileInfo.Executable           = $PSStyle.Foreground.FromRGB($ef.orange)
    $PSStyle.FileInfo.Extension['.ps1']    = $PSStyle.Foreground.FromRGB($ef.blue)
    $PSStyle.FileInfo.Extension['.ps1xml'] = $PSStyle.Foreground.FromRGB($ef.blue)
    $PSStyle.FileInfo.Extension['.psd1']   = $PSStyle.Foreground.FromRGB($ef.blue)
    $PSStyle.FileInfo.Extension['.psm1']   = $PSStyle.Foreground.FromRGB($ef.blue)
}
Update-EverforestReadlinePallete -Variant light
