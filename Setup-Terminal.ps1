# ============================================================
#  Setup-Terminal.ps1 — Bootstrap launcher (PowerShell 5.1+)
#
#  This script ensures PowerShell 7 is installed, then launches
#  Setup-Terminal-Main.ps1 under pwsh. Safe to run from either
#  PowerShell 5.1 (powershell.exe) or PowerShell 7 (pwsh.exe).
#
#  Usage:
#    .\Setup-Terminal.ps1              # Interactive menu
#    .\Setup-Terminal.ps1 -yolo        # Install everything, no prompts
# ============================================================

param(
    [switch]$yolo
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$MainScript = Join-Path $ScriptDir "Setup-Terminal-Main.ps1"

# ── Find pwsh ────────────────────────────────────────────────
function Find-Pwsh {
    # Try PATH first
    $cmd = Get-Command pwsh -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }

    # Probe known install locations
    $knownPaths = @(
        "$env:ProgramFiles\PowerShell\7\pwsh.exe",
        "${env:ProgramFiles(x86)}\PowerShell\7\pwsh.exe",
        "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe"
    )
    foreach ($p in $knownPaths) {
        if (Test-Path $p) { return $p }
    }
    return $null
}

# ── Already on PS7+? Go straight to Main ─────────────────────
if ($PSVersionTable.PSVersion.Major -ge 7) {
    Write-Host "  PowerShell 7 detected — launching setup..." -ForegroundColor Green
    $mainArgs = @("-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "`"$MainScript`"")
    if ($yolo) { $mainArgs += "-yolo" }

    # Re-exec via pwsh so Assert-Admin in Main relaunches correctly
    $pwshPath = Find-Pwsh
    if ($pwshPath) {
        & $pwshPath $mainArgs
    } else {
        # We're already in PS7 somehow but can't find pwsh — just dot-source
        if ($yolo) {
            & $MainScript -yolo
        } else {
            & $MainScript
        }
    }
    exit $LASTEXITCODE
}

# ── PS5 path — need to install PS7 first ─────────────────────
Write-Host ""
Write-Host "  ==============================================" -ForegroundColor Cyan
Write-Host "    PowerShell 5.1 detected (version $($PSVersionTable.PSVersion))" -ForegroundColor Cyan
Write-Host "    PowerShell 7 is required for the full setup." -ForegroundColor Cyan
Write-Host "  ==============================================" -ForegroundColor Cyan
Write-Host ""

# Check if pwsh is already installed but user just launched with wrong shell
$pwshPath = Find-Pwsh
if ($pwshPath) {
    Write-Host "  PowerShell 7 is already installed at: $pwshPath" -ForegroundColor Green
    Write-Host "  Relaunching setup with pwsh..." -ForegroundColor Green
    Write-Host ""
    $mainArgs = @("-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "`"$MainScript`"")
    if ($yolo) { $mainArgs += "-yolo" }
    & $pwshPath $mainArgs
    exit $LASTEXITCODE
}

# Need to install PS7 — check for winget
$wingetCmd = Get-Command winget -ErrorAction SilentlyContinue
if (-not $wingetCmd) {
    Write-Host "  ERROR: winget is not available on this system." -ForegroundColor Red
    Write-Host ""
    Write-Host "  Please install PowerShell 7 manually:" -ForegroundColor Yellow
    Write-Host "    Download: https://github.com/PowerShell/PowerShell/releases/latest" -ForegroundColor Yellow
    Write-Host "    Install the MSI for Windows x64, then re-run this script." -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

# Install PS7 via winget
Write-Host "  Installing PowerShell 7 via winget..." -ForegroundColor Yellow
Write-Host ""
winget install --id Microsoft.PowerShell -e --accept-source-agreements --accept-package-agreements --silent

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "  ERROR: winget install failed (exit code $LASTEXITCODE)." -ForegroundColor Red
    Write-Host ""
    Write-Host "  Please install PowerShell 7 manually:" -ForegroundColor Yellow
    Write-Host "    Download: https://github.com/PowerShell/PowerShell/releases/latest" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

# Refresh PATH and locate pwsh
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("Path", "User")

$pwshPath = Find-Pwsh
if (-not $pwshPath) {
    Write-Host ""
    Write-Host "  PowerShell 7 was installed but pwsh could not be found." -ForegroundColor Red
    Write-Host "  Please close all terminals, open a new one, and re-run:" -ForegroundColor Yellow
    Write-Host "    pwsh -NoProfile -File `"$($MyInvocation.MyCommand.Definition)`"" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "  PowerShell 7 installed successfully!" -ForegroundColor Green
Write-Host "  Relaunching setup with pwsh..." -ForegroundColor Green
Write-Host ""

$mainArgs = @("-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "`"$MainScript`"")
if ($yolo) { $mainArgs += "-yolo" }
& $pwshPath $mainArgs
exit $LASTEXITCODE
