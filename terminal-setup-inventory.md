# 🖥️ Terminal Setup — Full Inventory

> Everything needed to recreate this terminal environment from scratch on a new Windows (ARM64) machine.
> Generated: March 2026

---

## 1. Core Tools via Winget

```powershell
# Shell & terminal
winget install --id Microsoft.PowerShell -e               # PowerShell 7.6
winget install --id Microsoft.WindowsTerminal -e           # Windows Terminal

# Version control & GitHub
winget install --id Git.Git -e --source winget             # Git 2.53
winget install --id GitHub.cli -e                          # GitHub CLI 2.89
winget install --id GitHub.Copilot -e                      # Copilot CLI

# Editors
winget install --id Microsoft.VisualStudioCode -e          # VS Code
winget install --id vim.vim -e                             # Vim 9.2

# Languages & runtimes
winget install --id OpenJS.NodeJS.LTS -e                   # Node.js 24 LTS
winget install --id Python.Python.3.12 -e                  # Python 3.12 (ARM64)

# Terminal enhancements
winget install --id JanDeDobbeleer.OhMyPosh -e             # Oh My Posh 29.x
winget install --id junegunn.fzf -e                        # fzf (fuzzy finder)
winget install --id sharkdp.bat -e                         # bat (better cat)
winget install --id jftuga.less -e                         # less (pager)
winget install --id GNU.MidnightCommander -e               # Midnight Commander (file manager)

# Other utilities
winget install --id Microsoft.Azure.StorageExplorer -e     # Azure Storage Explorer
winget install --id Google.QuickShare -e                   # Quick Share
winget install --id cjpais.Handy -e                        # Handy
```

---

## 2. Global npm Packages

```powershell
npm install -g @bradygaster/squad-cli                      # Squad CLI 0.9.1
```

---

## 3. Python Packages (pip)

```powershell
pip install fastapi uvicorn sqlalchemy alembic pydantic click colorama
```

Full list: `fastapi`, `uvicorn`, `SQLAlchemy`, `alembic`, `pydantic`, `click`, `colorama`, `anyio`, `h11`, `idna`, `Mako`, `MarkupSafe`, `annotated-types`, `typing_extensions`, `typing-inspection`, `starlette`, `pydantic_core`, `annotated-doc`

---

## 4. PowerShell Modules

```powershell
Install-Module posh-git       -Scope CurrentUser -Force    # Git status in prompt + tab completion
Install-Module Terminal-Icons  -Scope CurrentUser -Force    # File/folder icons in ls
Install-Module z               -Scope CurrentUser -Force    # Frecency-based dir jumping
Install-Module PSFzf           -Scope CurrentUser -Force    # Fuzzy finder integration (Ctrl+T, Ctrl+R)
Install-Module NerdFonts       -Scope CurrentUser -Force    # Nerd Font installer module
Install-Module Fonts           -Scope CurrentUser -Force    # Font management
Install-Module Admin           -Scope CurrentUser -Force    # Admin helpers
```

---

## 5. Nerd Fonts

Installed via the `NerdFonts` PowerShell module:

```powershell
Import-Module NerdFonts
Install-NerdFont -Name "Meslo"                             # MesloLG{L,M,S} + DZ variants
Install-NerdFont -Name "CaskaydiaCove"                     # CaskaydiaCove NF
```

Fonts currently installed:
- **CaskaydiaCove Nerd Font** (regular, Mono, NF) — used as Windows Terminal default font
- **MesloLGM Nerd Font** — used in the PowerShell 7 profile (size 8)
- MesloLGL, MesloLGS (+ Mono, Propo, DZ variants of each)

---

## 6. Windows Terminal Configuration

**Default profile:** PowerShell 7 (`pwsh.exe -NoLogo`)

**Key customizations:**
| Setting | Value |
|---|---|
| Default font | `CaskaydiaCove NF` |
| PowerShell 7 font | `MesloLGM Nerd Font` @ size 8 |
| Copy formatting | `none` |
| Copy on select | `false` |

**Custom keybindings:**
| Keys | Action |
|---|---|
| `Alt+Shift+D` | Duplicate pane — auto split, same directory |
| `Alt+Shift+Minus` | Split horizontal (top/bottom), same directory |
| `Alt+Shift+Plus` | Split vertical (left/right), same directory |
| `Ctrl+Shift+T` | New tab, same directory |
| `Shift+Enter` | Send `Escape + Enter` (newline in Copilot CLI) |
| `Ctrl+C` | Copy to clipboard |
| `Ctrl+V` | Paste from clipboard |

> Split pane and new tab actions use `splitMode: "duplicate"` to inherit the current working directory.
> This requires the PowerShell profile to emit [OSC 9;9](https://github.com/microsoft/terminal/issues/8166) on each prompt.

**Settings file location:**
`%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`

<details>
<summary>Full settings.json</summary>

```json
{
    "$help": "https://aka.ms/terminal-documentation",
    "$schema": "https://aka.ms/terminal-profiles-schema",
    "actions": [
        {
            "command": { "action": "sendInput", "input": "\u001b\r" },
            "id": "User.sendInput.8F63D3A9"
        },
        {
            "command": { "action": "splitPane", "split": "horizontal", "splitMode": "duplicate" },
            "id": "User.splitPane.Horizontal"
        },
        {
            "command": { "action": "splitPane", "split": "vertical", "splitMode": "duplicate" },
            "id": "User.splitPane.Vertical"
        },
        {
            "command": { "action": "duplicateTab" },
            "id": "User.duplicateTab"
        }
    ],
    "copyFormatting": "none",
    "copyOnSelect": false,
    "defaultProfile": "{574e775e-4f2a-5b96-ac1e-a2962a402336}",
    "keybindings": [
        { "id": "Terminal.DuplicatePaneAuto", "keys": "alt+shift+d" },
        { "id": "User.splitPane.Horizontal", "keys": "alt+shift+minus" },
        { "id": "User.splitPane.Vertical", "keys": "alt+shift+plus" },
        { "id": "User.duplicateTab", "keys": "ctrl+shift+t" },
        { "id": "User.sendInput.8F63D3A9", "keys": "shift+enter" },
        { "id": "Terminal.CopyToClipboard", "keys": "ctrl+c" },
        { "id": "Terminal.PasteFromClipboard", "keys": "ctrl+v" }
    ],
    "newTabMenu": [{ "type": "remainingProfiles" }],
    "profiles": {
        "defaults": {
            "font": { "face": "CaskaydiaCove NF" }
        },
        "list": [
            {
                "commandline": "%SystemRoot%\\System32\\WindowsPowerShell\\v1.0\\powershell.exe",
                "guid": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
                "hidden": false,
                "name": "Windows PowerShell"
            },
            {
                "commandline": "%SystemRoot%\\System32\\cmd.exe",
                "guid": "{0caa0dad-35be-5f56-a8ff-afceeeaa6101}",
                "hidden": false,
                "name": "Command Prompt"
            },
            {
                "guid": "{b453ae62-4e3d-5e58-b989-0a998ec441b8}",
                "hidden": false,
                "name": "Azure Cloud Shell",
                "source": "Windows.Terminal.Azure"
            },
            {
                "commandline": "C:\\Program Files\\PowerShell\\7\\pwsh.exe -NoLogo",
                "font": { "face": "MesloLGM Nerd Font", "size": 8 },
                "guid": "{574e775e-4f2a-5b96-ac1e-a2962a402336}",
                "hidden": false,
                "name": "PowerShell",
                "source": "Windows.Terminal.PowershellCore"
            }
        ]
    },
    "schemes": [],
    "themes": []
}
```
</details>

---

## 7. Oh My Posh — Custom Theme

**Theme file:** `ayman.omp.json` stored alongside `$PROFILE`
**Location:** `C:\Users\<you>\OneDrive - Microsoft\Documents\PowerShell\ayman.omp.json`

**Prompt segments (left to right):**
1. 🪟 OS icon (Windows logo)
2. 👤 Username (with SSH indicator)
3. 📁 Path (agnoster_short, max 3 deep)
4. 🌿 Git status (green=clean, yellow=changed, red=behind, blue=ahead)
5. ⏱️ Execution time (>3s threshold)
6. ✅/❌ Exit status code
7. 🕐 Current time (HH:MM)

<details>
<summary>Full ayman.omp.json</summary>

```json
{
  "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
  "version": 4,
  "final_space": true,
  "console_title_template": "{{ .Shell }} in {{ .Folder }}",
  "palette": {
    "white": "#FFFFFF",
    "tan": "#CC3802",
    "teal": "#047E84",
    "plum": "#9A348E",
    "blush": "#DA627D",
    "salmon": "#FCA17D",
    "sky": "#86BBD8",
    "teal_blue": "#33658A",
    "dark_gray": "#17D7A0"
  },
  "blocks": [
    {
      "type": "prompt",
      "alignment": "left",
      "segments": [
        {
          "type": "os",
          "style": "diamond",
          "leading_diamond": "\ue0b6",
          "trailing_diamond": "\ue0b0",
          "foreground": "#ffffff",
          "background": "#444444",
          "template": " \uf17a "
        },
        {
          "type": "session",
          "style": "powerline",
          "powerline_symbol": "\ue0b0",
          "foreground": "#ffffff",
          "background": "#3a86ff",
          "template": " {{ if .SSHSession }}\uf817 {{ end }}{{ .UserName }} "
        },
        {
          "type": "path",
          "style": "powerline",
          "powerline_symbol": "\ue0b0",
          "foreground": "#ffffff",
          "background": "#C678DD",
          "properties": {
            "style": "agnoster_short",
            "max_depth": 3,
            "folder_separator_icon": " \ue0b1 "
          },
          "template": " \uf07c {{ .Path }} "
        },
        {
          "type": "git",
          "style": "powerline",
          "powerline_symbol": "\ue0b0",
          "foreground": "#ffffff",
          "background": "#06d6a0",
          "foreground_templates": [
            "{{ if or (.Working.Changed) (.Staging.Changed) }}#1a1a1a{{ end }}"
          ],
          "background_templates": [
            "{{ if or (.Working.Changed) (.Staging.Changed) }}#ffd166{{ end }}",
            "{{ if gt .Behind 0 }}#ef476f{{ end }}",
            "{{ if gt .Ahead 0 }}#3a86ff{{ end }}"
          ],
          "properties": {
            "fetch_status": true,
            "fetch_upstream_icon": true
          },
          "template": " {{ .UpstreamIcon }}{{ .HEAD }}{{ if .Working.Changed }} \uf044 {{ .Working.String }}{{ end }}{{ if and (.Working.Changed) (.Staging.Changed) }} |{{ end }}{{ if .Staging.Changed }} \uf046 {{ .Staging.String }}{{ end }}{{ if gt .StashCount 0 }} \ueb4b {{ .StashCount }}{{ end }} "
        },
        {
          "type": "executiontime",
          "style": "powerline",
          "powerline_symbol": "\ue0b0",
          "foreground": "#1a1a1a",
          "background": "#ffd166",
          "properties": {
            "threshold": 3000,
            "style": "austin",
            "always_enabled": false
          },
          "template": " \uf252 {{ .FormattedMs }} "
        },
        {
          "type": "status",
          "style": "diamond",
          "trailing_diamond": "\ue0b4",
          "foreground": "#ffffff",
          "background": "#007800",
          "background_templates": [
            "{{ if gt .Code 0 }}#ef476f{{ end }}"
          ],
          "properties": { "always_enabled": true },
          "template": " {{ if gt .Code 0 }}\uf00d {{ .Code }}{{ else }}\uf00c{{ end }} "
        },
        {
          "background": "p:teal_blue",
          "foreground": "p:white",
          "options": { "time_format": "15:04" },
          "style": "diamond",
          "template": " \u2665 {{ .CurrentDate | date .Format }} ",
          "trailing_diamond": "\ue0b0",
          "type": "time"
        }
      ]
    }
  ]
}
```
</details>

---

## 8. PowerShell Profile

**Location:** `C:\Users\<you>\OneDrive - Microsoft\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`

**What it does:**
- Loads Oh My Posh with custom theme (`$env:USERNAME.omp.json`, configurable via `$env:OMP_THEME_NAME`)
- Emits [OSC 9;9](https://github.com/microsoft/terminal/issues/8166) after each prompt so Windows Terminal knows the CWD (enables split pane / new tab in same directory)
- Imports modules: `posh-git`, `Terminal-Icons`, `z`, `PSFzf`
- Configures PSFzf: `Ctrl+T` = file picker, `Ctrl+R` = history search
- Configures PSReadLine:
  - Inline ghost-text predictions (HistoryAndPlugin)
  - Custom color scheme (Cyan commands, Yellow strings, Green variables, etc.)
  - `Up/Down` = history search, `Ctrl+Left/Right` = word navigation
  - Bell disabled, 100 max history, Windows edit mode
- Aliases: `ll`, `la` → `Get-ChildItem` | `g` → `git` | `touch` → `New-Item` | `vi` → `vim` | `cat` → `bat` | `ep` → edit profile | `rpr` → reload profile
- Adds to PATH: `C:\Program Files\Vim\vim92\`, `C:\Program Files\Midnight Commander\`
- Sets `$ErrorView = 'ConciseView'`

<details>
<summary>Full profile script</summary>

```powershell
# ============================================================
# Microsoft.PowerShell_profile.ps1
# ============================================================

# Oh My Posh theme — uses $env:USERNAME (e.g. ayman.omp.json)
# Override with $env:OMP_THEME_NAME if your theme file has a different name.
$ompThemeName = if ($env:OMP_THEME_NAME) { $env:OMP_THEME_NAME } else { $env:USERNAME }
$omp = Join-Path (Get-Item $PROFILE).DirectoryName "$ompThemeName.omp.json"

# Oh My Posh
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --config "$omp" | Invoke-Expression
} else {
    Write-Warning "oh-my-posh not found. Install with: winget install JanDeDobbeleer.OhMyPosh"
}

# OSC 9;9 — Tell Windows Terminal the current working directory
# so new tabs, panes, and splits open in the same folder.
# Per: https://github.com/microsoft/terminal/issues/8166
if ($env:WT_SESSION) {
    $__ompPrompt = $function:prompt
    function prompt {
        $result = & $__ompPrompt
        $converted_path = Convert-Path (Get-Location)
        Write-Host "$([char]27)]9;9;$converted_path$([char]27)\" -NoNewline
        return $result
    }
}

# Modules
if (Get-Module -ListAvailable -Name posh-git)      { Import-Module posh-git }
if (Get-Module -ListAvailable -Name Terminal-Icons) { Import-Module Terminal-Icons }
if (Get-Module -ListAvailable -Name z)              { Import-Module z }
if (Get-Module -ListAvailable -Name PSFzf) {
    Import-Module PSFzf
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t'
    Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'
}

# PSReadLine
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
    Set-PSReadLineOption -PredictionViewStyle InlineView
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
    Set-PSReadLineKeyHandler -Key UpArrow         -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow       -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Key Ctrl+LeftArrow  -Function BackwardWord
    Set-PSReadLineKeyHandler -Key Ctrl+RightArrow -Function ForwardWord
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    Set-PSReadLineOption -MaximumHistoryCount 100
    Set-PSReadLineOption -BellStyle None
    Set-PSReadLineOption -EditMode Windows
}

# Aliases
Set-Alias -Name ll    -Value Get-ChildItem
Set-Alias -Name la    -Value Get-ChildItem
Set-Alias -Name g     -Value git
Set-Alias -Name touch -Value New-Item
Set-Alias -Name vi    -Value vim
Set-Alias -Name cat   -Value bat
function Edit-Profile  { & $env:EDITOR $PROFILE }
Set-Alias -Name ep  -Value Edit-Profile
function Reload-Profile { . $PROFILE }
Set-Alias -Name rpr -Value Reload-Profile

$ErrorView = 'ConciseView'

$env:PATH += ";C:\Program Files\Vim\vim92\"
$env:PATH += ";C:\Program Files\Midnight Commander\"
```
</details>

---

## 9. GitHub Copilot CLI

**Login:** EMU account (`youralias_microsoft`) on `https://github.com`

**Settings:**
- Alt-screen mode: enabled
- Trusted folders: `C:\dev`, `C:\Users\<you>\source\*`

**Plugins installed:**
- **WorkIQ** (from `github/copilot-plugins` marketplace)

```powershell
# After installing Copilot CLI, run inside copilot:
/login                                                     # Login with EMU account (option 2 → https://github.com)
/plugin marketplace add github/copilot-plugins             # Add plugin marketplace
/plugin install workiq@copilot-plugins                     # Install WorkIQ
```

---

## 10. MCP Servers

### Global — Copilot CLI

**Config file:** `~\.copilot\mcp-config.json`

This config is loaded by the Copilot CLI for all sessions regardless of project.

```json
{
  "mcpServers": {
    "playwright": {
      "type": "local",
      "command": "npx",
      "tools": ["*"],
      "args": ["@playwright/mcp@latest"]
    }
  }
}
```

**Active MCP servers:**

| Server | Package | Purpose |
|---|---|---|
| **Playwright** | `@playwright/mcp@latest` | Browser automation — page snapshots, clicks, form fills, screenshots, navigation |

> Playwright MCP is launched on-demand via `npx` — no pre-install needed beyond Node.js.

### Per-Project MCP Configs

These are committed to individual repos and activate when Copilot CLI runs in that project:

**`decision_dashboard/.github/mcp.json`** — Playwright with Edge browser:
```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest", "--browser", "msedge"]
    }
  }
}
```

**`productivity_system/.copilot/mcp-config.json`** — GitHub MCP (example/template):
```json
{
  "mcpServers": {
    "EXAMPLE-github": {
      "command": "npx",
      "args": ["-y", "@anthropic/github-mcp-server"],
      "env": { "GITHUB_TOKEN": "${GITHUB_TOKEN}" }
    }
  }
}
```

### VS Code Extensions (MCP-related)

| Extension | ID |
|---|---|
| **GitHub Copilot Chat** | `github.copilot-chat` |
| **Playwright Test** | `ms-playwright.playwright` |

### Copilot CLI Plugins (non-MCP)

| Plugin | Marketplace | Purpose |
|---|---|---|
| **WorkIQ** | `github/copilot-plugins` | Microsoft 365 integration — emails, meetings, docs, Teams |

---

## 11. Summary — Install Order

For a clean machine, install in this order:

1. **PowerShell 7** → reopen terminal
2. **Git** → verify: `git --version`
3. **Windows Terminal** → configure settings.json
4. **Nerd Fonts** (CaskaydiaCove, Meslo) → needed before Oh My Posh renders correctly
5. **Oh My Posh** → copy `ayman.omp.json` to `$PROFILE` directory
6. **PowerShell modules** (posh-git, Terminal-Icons, z, PSFzf, NerdFonts, Fonts, Admin)
7. **Copy PowerShell profile** to `$PROFILE` path
8. **Node.js** → then `npm install -g @bradygaster/squad-cli`
9. **Python 3.12** → then `pip install fastapi uvicorn sqlalchemy alembic pydantic click colorama`
10. **CLI tools** (fzf, bat, vim, Midnight Commander, VS Code)
11. **GitHub CLI** + **Copilot CLI** → login, install WorkIQ plugin
12. **MCP servers** → copy `~\.copilot\mcp-config.json` (Playwright), install VS Code extensions
13. **Other** (Azure Storage Explorer, Quick Share, Handy)

---

## 12. Useful Commands

```powershell
# Refresh PATH without restarting the terminal (picks up winget/installer changes)
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

# Reload PowerShell profile (aliases, modules, Oh My Posh, etc.)
. $PROFILE                    # or use the alias: rpr
```
