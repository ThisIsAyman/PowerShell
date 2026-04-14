# Copilot Instructions

## About This Repo

This repository contains **terminal environment setup** files and the **GitHub Copilot CLI QuickStart Guide** for Microsoft employees and vendors. It includes PowerShell profiles, Windows Terminal settings, Oh My Posh themes, MCP configs, and an automated setup script. There is no application code, build system, or test suite.

## Architecture

**Setup & Configs:**
- `Setup-Terminal.ps1` — Automated installer with interactive menu (or `-yolo` mode)
- `configs/Microsoft.PowerShell_profile.ps1` — PowerShell 7 profile (Oh My Posh, modules, OSC 9;9, aliases)
- `configs/windows-terminal-settings.json` — Windows Terminal keybindings and profiles
- `configs/example.omp.json` — Oh My Posh theme template
- `configs/mcp-config.json` — Copilot CLI MCP server config (Playwright)
- `terminal-setup-inventory.md` — Full inventory of all installed tools, configs, and settings

**QuickStart Guide** follows a sequential setup flow (Steps 1–8 + Bonus):

1. **EMU account** → 2. **Install CLI** → 3. **Login** → 4. **CLI basics** → 5. **Explore features** → 6. **MCP/WorkIQ** → 7. **Skills** → 8. **Custom Agents**

## Formatting Conventions

- **Section headings** use emoji prefixes (e.g., `## 📑 Table of Contents`)
- **Structured information** is presented in Markdown tables, not bullet lists
- **Step-by-step instructions** use numbered lists with inline code for commands
- **Callouts** use blockquotes with emoji markers: `💡` tips, `⚠️` warnings, `📝` notes, `⏳` timing, `📚` further reading
- **Links to internal Microsoft resources** use `aka.ms` short URLs or SharePoint links
- **External tools** always include a verification command (e.g., `git --version`)

## Content Guidelines

- The audience is Microsoft employees and vendors who may be new to CLI tools — keep language approachable
- Always provide both automated and manual install paths where applicable
- Include Windows (PowerShell 7) as the primary platform with macOS alternatives where relevant
- Keep the Table of Contents in sync when adding or reordering sections
