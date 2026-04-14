# ============================================================
# Microsoft.PowerShell_profile.ps1
# Drop this at: $PROFILE  (usually)
#   C:\Users\<you>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
#
# One-time installs (run these manually once per machine):
#   winget install JanDeDobbeleer.OhMyPosh
#   winget install --id=GNU.MidnightCommander -e
#   Install-Module posh-git       -Scope CurrentUser -Force
#   Install-Module Terminal-Icons -Scope CurrentUser -Force
#   Install-Module z              -Scope CurrentUser -Force
#   Install-Module PSFzf          -Scope CurrentUser -Force
# ============================================================

# Oh My Posh theme — uses your Windows username (e.g. ayman.omp.json)
# To use a different theme, set $env:OMP_THEME_NAME or rename your theme file.
$ompThemeName = if ($env:OMP_THEME_NAME) { $env:OMP_THEME_NAME } else { $env:USERNAME }
$omp = Join-Path (Get-Item $PROFILE).DirectoryName "$ompThemeName.omp.json"

# ------------------------------------------------------------
# Oh My Posh — jandedobbeleer theme
# ------------------------------------------------------------
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    #oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\jandedobbeleer.omp.json" | Invoke-Expression
    oh-my-posh init pwsh --config "$omp" | Invoke-Expression
} else {
    Write-Warning "oh-my-posh not found. Install with: winget install JanDeDobbeleer.OhMyPosh"
}

# ------------------------------------------------------------
# OSC 9;9 — Tell Windows Terminal the current working directory
# so new tabs, panes, and splits (Alt+Shift+D) open in the
# same folder. Per: https://github.com/microsoft/terminal/issues/8166
# ------------------------------------------------------------
if ($env:WT_SESSION) {
    $__ompPrompt = $function:prompt
    function prompt {
        $result = & $__ompPrompt
        $converted_path = Convert-Path (Get-Location)
        Write-Host "$([char]27)]9;9;$converted_path$([char]27)\" -NoNewline
        return $result
    }
}

# ------------------------------------------------------------
# Modules
# ------------------------------------------------------------

# posh-git — git status in prompt + tab completion for git
if (Get-Module -ListAvailable -Name posh-git) {
    Import-Module posh-git
} else {
    Write-Warning "posh-git not found. Run: Install-Module posh-git -Scope CurrentUser -Force"
}

# Terminal-Icons — file/folder icons in ls output
if (Get-Module -ListAvailable -Name Terminal-Icons) {
    Import-Module Terminal-Icons
} else {
    Write-Warning "Terminal-Icons not found. Run: Install-Module Terminal-Icons -Scope CurrentUser -Force"
}

# z — frecency-based directory jumping (e.g. `z projects`)
if (Get-Module -ListAvailable -Name z) {
    Import-Module z
} else {
    Write-Warning "z not found. Run: Install-Module z -Scope CurrentUser -Force"
}

# PSFzf — fuzzy finder; Ctrl+T = files, Ctrl+R = history
if (Get-Module -ListAvailable -Name PSFzf) {
    Import-Module PSFzf
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t'
    Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'
} else {
    Write-Warning "PSFzf not found. Run: Install-Module PSFzf -Scope CurrentUser -Force"
}


# ------------------------------------------------------------
# PSReadLine — inline ghost-text predictions + better UX
# ------------------------------------------------------------
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine

    # Inline ghost text (grey suggestion as you type, Right arrow to accept)
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
    Set-PSReadLineOption -PredictionViewStyle InlineView

    # Colours
    Set-PSReadLineOption -Colors @{
        InlinePrediction = [ConsoleColor]::DarkGray
        Command          = [ConsoleColor]::Cyan
        Parameter        = [ConsoleColor]::DarkCyan
        String           = [ConsoleColor]::Yellow
        Operator         = [ConsoleColor]::DarkYellow
        Variable         = [ConsoleColor]::Green
        Comment          = [ConsoleColor]::DarkGreen
        Error            = [ConsoleColor]::Red
    }

    # Key bindings
    #Set-PSReadLineKeyHandler -Key Tab            -Function MenuComplete       # Tab = cycle completions
    Set-PSReadLineKeyHandler -Key UpArrow        -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow      -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Key Ctrl+LeftArrow -Function BackwardWord
    Set-PSReadLineKeyHandler -Key Ctrl+RightArrow -Function ForwardWord

    # Misc behaviour
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    Set-PSReadLineOption -MaximumHistoryCount 100
    Set-PSReadLineOption -BellStyle None
    Set-PSReadLineOption -EditMode Windows

   #Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
   #Set-PSReadLineKeyHandler -Key Shift+Tab -Function ReverseMenuComplete
   #Set-PSReadLineOption -ShowToolTips
   #Set-PSReadLineOption -CompletionQueryItems 100
   #Set-PSReadlineKeyHandler -Key Tab -Function Complete
}


# ------------------------------------------------------------
# Handy aliases
# ------------------------------------------------------------
Set-Alias -Name ll  -Value Get-ChildItem
Set-Alias -Name la  -Value Get-ChildItem   # use: la -Force for hidden files
Set-Alias -Name g   -Value git
Set-Alias -Name touch -Value New-Item

# Open profile quickly in your default editor
function Edit-Profile { & $env:EDITOR $PROFILE }
Set-Alias -Name ep -Value Edit-Profile

# Reload profile without restarting terminal
function Reload-Profile { . $PROFILE }
Set-Alias -Name rpr -Value Reload-Profile
Set-Alias -Name vi -Value vim
Set-Alias -Name cat -Value bat


# Quick shortcut to jump to common dirs — customise as needed
# function dev { Set-Location "C:\dev" }


# ------------------------------------------------------------
# Misc
# ------------------------------------------------------------

# Suppress the PowerShell startup banner (alternative to -NoLogo flag)
#$host.UI.RawUI.WindowTitle = "PowerShell 7"

# Show all errors in a readable way
$ErrorView = 'ConciseView'

# Paths:
#[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Program Files\Vim\vim92\", "Machine")
#[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Program Files\Midnight Commander\", "Machine")
#[System.Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Program Files\Midnight Commander\", "User")


#Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
#Set-PSReadLineKeyHandler -Key Shift+Tab -Function ReverseMenuComplete
#Set-PSReadLineOption -ShowToolTips
#Set-PSReadLineOption -CompletionQueryItems 100
#Set-PSReadlineKeyHandler -Key Tab -Function Complete

#copilot --resume --alt-screen --yolo


#C:\Program Files\Midnight Commander
#Install-PSResource -Name NerdFonts
#Import-Module -Name NerdFonts
#winget install --id Git.Git -e --source winget
# Install-NerdFont -Name "Meslo"
# winget install --id=junegunn.fzf -e
# winget install -e --id Microsoft.VisualStudioCode
# winget install GNU.MidnightCommander


#/plugin markplace add imcrosoft/skills-for-fabric

$env:PATH += ";C:\Program Files\Vim\vim92\"
$env:PATH += ";C:\Program Files\Midnight Commander\"

#winget install OpenJS.NodeJS.LTS
#/plugin marketplace add github/copilot-plugins​
#/plugin install workiq@copilot-plugins​
#winget install -e --id OpenJS.NodeJS
