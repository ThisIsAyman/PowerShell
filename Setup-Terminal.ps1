# ============================================================
#  Setup-Terminal.ps1 — Automated terminal environment setup
#
#  Usage:
#    .\Setup-Terminal.ps1              # Interactive menu
#    .\Setup-Terminal.ps1 -yolo        # Install everything, no prompts
#
#  ⚠ This script will request Administrator privileges once
#    at launch (required for winget, fonts, and PATH changes).
# ============================================================

param(
    [switch]$yolo
)

# ── Self-elevate to Admin ────────────────────────────────────
function Assert-Admin {
    $current = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    if (-not $current.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "`n⚡ This script requires Administrator privileges (winget, fonts, PATH)." -ForegroundColor Yellow
        Write-Host "   Relaunching as Administrator...`n" -ForegroundColor Yellow
        $params = @("-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "`"$PSCommandPath`"")
        if ($yolo) { $params += "-yolo" }
        Start-Process pwsh -ArgumentList $params -Verb RunAs
        exit
    }
}
Assert-Admin

# ── Helpers ──────────────────────────────────────────────────
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$LogFile   = Join-Path $ScriptDir "setup-log-$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"

function Log {
    param([string]$Message, [string]$Color = "White")
    $ts = Get-Date -Format "HH:mm:ss"
    $line = "[$ts] $Message"
    Write-Host $line -ForegroundColor $Color
    $line | Out-File -Append -FilePath $LogFile
}

function Run {
    param([string]$Label, [scriptblock]$Action)
    Log "▶ $Label" "Cyan"
    try {
        & $Action
        Log "  ✅ $Label" "Green"
    } catch {
        Log "  ❌ $Label — $($_.Exception.Message)" "Red"
    }
}

function Refresh-Path {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("Path", "User")
}

# ── Categories ───────────────────────────────────────────────
# Each category is a hashtable with a display name and an install scriptblock.

$Categories = [ordered]@{

    "Core Tools (winget)" = {
        $wingetPkgs = @(
            @{ Id = "Microsoft.PowerShell";            Name = "PowerShell 7" },
            @{ Id = "Microsoft.WindowsTerminal";       Name = "Windows Terminal" },
            @{ Id = "Git.Git";                         Name = "Git" },
            @{ Id = "GitHub.cli";                      Name = "GitHub CLI" },
            @{ Id = "GitHub.Copilot";                  Name = "Copilot CLI" },
            @{ Id = "Microsoft.VisualStudioCode";      Name = "VS Code" },
            @{ Id = "vim.vim";                         Name = "Vim" },
            @{ Id = "OpenJS.NodeJS.LTS";               Name = "Node.js LTS" },
            @{ Id = "Python.Python.3.12";              Name = "Python 3.12" },
            @{ Id = "JanDeDobbeleer.OhMyPosh";         Name = "Oh My Posh" },
            @{ Id = "junegunn.fzf";                    Name = "fzf" },
            @{ Id = "sharkdp.bat";                     Name = "bat" },
            @{ Id = "jftuga.less";                     Name = "less" },
            @{ Id = "GNU.MidnightCommander";           Name = "Midnight Commander" },
            @{ Id = "Microsoft.Azure.StorageExplorer"; Name = "Azure Storage Explorer" },
            #@{ Id = "Google.QuickShare";               Name = "Quick Share" },
            @{ Id = "cjpais.Handy";                    Name = "Handy" }
        )
        foreach ($pkg in $wingetPkgs) {
            Run "winget: $($pkg.Name)" {
                winget install --id $pkg.Id -e --accept-source-agreements --accept-package-agreements --silent 2>&1 | Out-Null
            }
        }
        Refresh-Path
    }

    "Nerd Fonts" = {
        Run "Install NerdFonts module" {
            if (-not (Get-Module -ListAvailable -Name NerdFonts)) {
                Install-Module NerdFonts -Scope CurrentUser -Force
            }
            Import-Module NerdFonts
        }
        Run "Install Meslo Nerd Font" {
            Install-NerdFont -Name "Meslo" -Confirm:$false
        }
        Run "Install CaskaydiaCove Nerd Font" {
            Install-NerdFont -Name "CaskaydiaCove" -Confirm:$false
        }
    }

    "PowerShell Modules" = {
        $modules = @("posh-git", "Terminal-Icons", "z", "PSFzf", "Fonts", "Admin")
        foreach ($mod in $modules) {
            Run "Module: $mod" {
                if (-not (Get-Module -ListAvailable -Name $mod)) {
                    Install-Module $mod -Scope CurrentUser -Force -AllowClobber
                } else {
                    Log "    Already installed" "DarkGray"
                }
            }
        }
    }

    "npm Global Packages" = {
        Run "Verify Node.js" { node --version | Out-Null }
        Refresh-Path
        Run "npm: @bradygaster/squad-cli" {
            npm install -g @bradygaster/squad-cli 2>&1 | Out-Null
        }
    }

    "Python Packages" = {
        Run "Verify Python" { py --version | Out-Null }
        Refresh-Path
        Run "pip: FastAPI stack" {
            pip install fastapi uvicorn sqlalchemy alembic pydantic click colorama 2>&1 | Out-Null
        }
    }

    "PowerShell Profile & Oh My Posh Theme" = {
        $profileDir = Split-Path $PROFILE -Parent

        Run "Create profile directory" {
            if (-not (Test-Path $profileDir)) { New-Item -ItemType Directory -Path $profileDir -Force | Out-Null }
        }
        Run "Copy PowerShell profile" {
            $src = Join-Path $ScriptDir "configs\Microsoft.PowerShell_profile.ps1"
            if (Test-Path $src) {
                if (Test-Path $PROFILE) {
                    $backup = "$PROFILE.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
                    Copy-Item $PROFILE $backup
                    Log "    Backed up existing profile → $backup" "DarkGray"
                }
                Copy-Item $src $PROFILE -Force
            } else {
                Log "    Source not found: $src — skipping (copy manually)" "Yellow"
            }
        }
        Run "Copy Oh My Posh theme" {
            $src = Join-Path $ScriptDir "configs\example.omp.json"
            $themeName = "$env:USERNAME.omp.json"
            $dst = Join-Path $profileDir $themeName
            if (Test-Path $src) {
                Copy-Item $src $dst -Force
                Log "    Theme saved as $themeName (matches `$env:USERNAME)" "DarkGray"
            } else {
                Log "    Source not found: $src — skipping (copy manually)" "Yellow"
            }
        }
    }

    "Windows Terminal Settings" = {
        Run "Copy Windows Terminal settings" {
            $src = Join-Path $ScriptDir "configs\windows-terminal-settings.json"
            $dst = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
            if (-not (Test-Path $src)) {
                Log "    Source not found: $src — skipping (copy manually)" "Yellow"
                return
            }
            if (-not (Test-Path (Split-Path $dst -Parent))) {
                Log "    Windows Terminal not installed yet — skipping" "Yellow"
                return
            }
            if (Test-Path $dst) {
                $backup = "$dst.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
                Copy-Item $dst $backup
                Log "    Backed up existing settings → $backup" "DarkGray"
            }
            Copy-Item $src $dst -Force
        }
    }

    "MCP Servers" = {
        Run "Copy Copilot CLI MCP config" {
            $src = Join-Path $ScriptDir "configs\mcp-config.json"
            $dst = Join-Path $env:USERPROFILE ".copilot\mcp-config.json"
            if (-not (Test-Path $src)) {
                Log "    Source not found: $src — skipping (copy manually)" "Yellow"
                return
            }
            $dstDir = Split-Path $dst -Parent
            if (-not (Test-Path $dstDir)) { New-Item -ItemType Directory -Path $dstDir -Force | Out-Null }
            Copy-Item $src $dst -Force
        }
        Run "Install VS Code extensions" {
            Refresh-Path
            code --install-extension github.copilot-chat         2>&1 | Out-Null
            code --install-extension ms-playwright.playwright    2>&1 | Out-Null
        }
    }

    "Copilot CLI Setup (manual steps)" = {
        Log ""
        Log "═══════════════════════════════════════════════════════════" "Magenta"
        Log "  The following steps must be done manually inside Copilot CLI:" "Magenta"
        Log ""
        Log "  1. Open a new PowerShell 7 terminal"
        Log "  2. Run:  copilot"
        Log "  3. Run:  /login"
        Log "     → Select option 2: GitHub Enterprise Cloud (*ghe.com)"
        Log "     → Enter URL: https://github.com"
        Log "  4. Run:  /plugin marketplace add github/copilot-plugins"
        Log "  5. Run:  /plugin install workiq@copilot-plugins"
        Log "  6. Accept the EULA, then restart PowerShell"
        Log "═══════════════════════════════════════════════════════════" "Magenta"
        Log ""
    }
}

# ── Interactive Menu ─────────────────────────────────────────
function Show-Menu {
    $keys = @($Categories.Keys)
    $selected = @{}
    foreach ($i in 0..($keys.Count - 1)) { $selected[$i] = $true }
    $cursor = 0

    while ($true) {
        Clear-Host
        Write-Host ""
        Write-Host "  ╔══════════════════════════════════════════════════╗" -ForegroundColor Cyan
        Write-Host "  ║     🖥️  Terminal Setup — Select Categories      ║" -ForegroundColor Cyan
        Write-Host "  ╚══════════════════════════════════════════════════╝" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "    ↑/↓  Navigate   │   Space  Toggle   │   Enter  Go" -ForegroundColor DarkGray
        Write-Host "    A    Select All  │   N      None     │   Q      Quit" -ForegroundColor DarkGray
        Write-Host ""

        for ($i = 0; $i -lt $keys.Count; $i++) {
            $check  = if ($selected[$i]) { "✅" } else { "⬜" }
            $prefix = if ($i -eq $cursor) { " ▶ " } else { "   " }
            $color  = if ($i -eq $cursor) { "Yellow" } else { "White" }
            Write-Host "$prefix$check  $($keys[$i])" -ForegroundColor $color
        }

        Write-Host ""
        $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode

        switch ($key) {
            38 { $cursor = [Math]::Max(0, $cursor - 1) }                          # Up
            40 { $cursor = [Math]::Min($keys.Count - 1, $cursor + 1) }            # Down
            32 { $selected[$cursor] = -not $selected[$cursor] }                    # Space
            65 { foreach ($i in 0..($keys.Count - 1)) { $selected[$i] = $true } } # A
            78 { foreach ($i in 0..($keys.Count - 1)) { $selected[$i] = $false } }# N
            81 { Write-Host "`n  Cancelled.`n"; exit 0 }                           # Q
            13 {                                                                    # Enter
                $chosen = @()
                for ($i = 0; $i -lt $keys.Count; $i++) {
                    if ($selected[$i]) { $chosen += $keys[$i] }
                }
                return $chosen
            }
        }
    }
}

# ── Main ─────────────────────────────────────────────────────
Clear-Host
Write-Host ""
Write-Host "  ╔══════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "  ║        🖥️  Terminal Environment Setup            ║" -ForegroundColor Cyan
Write-Host "  ║        Running as Administrator ✅               ║" -ForegroundColor Cyan
Write-Host "  ╚══════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Log "Log file: $LogFile"
Log "Script dir: $ScriptDir"
Write-Host ""

if ($yolo) {
    Log "🚀 YOLO mode — installing everything" "Yellow"
    $selectedCategories = @($Categories.Keys)
} else {
    $selectedCategories = Show-Menu
}

if ($selectedCategories.Count -eq 0) {
    Log "Nothing selected. Exiting." "Yellow"
    exit 0
}

Log "Installing $($selectedCategories.Count) categories..." "Cyan"
Write-Host ""

$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

foreach ($cat in $selectedCategories) {
    Write-Host ""
    Log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Cyan"
    Log "  📦  $cat" "Cyan"
    Log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Cyan"
    & $Categories[$cat]
}

$stopwatch.Stop()
Write-Host ""
Log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Green"
Log "  🎉  Setup complete!  ($([math]::Round($stopwatch.Elapsed.TotalMinutes, 1)) minutes)" "Green"
Log "  📄  Log saved to: $LogFile" "Green"
Log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Green"
Write-Host ""
Log "Next steps:" "Yellow"
Log "  1. Close ALL terminals and open a fresh PowerShell 7" "Yellow"
Log "  2. Complete the Copilot CLI manual steps (see above)" "Yellow"
Write-Host ""
