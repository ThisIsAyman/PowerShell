# 🚀 GitHub Copilot CLI — QuickStart Guide

> **Step-by-step setup instructions** for getting GitHub Copilot CLI up and running.
>
> ⏱️ **Estimated time:** ~10 minutes &nbsp;|&nbsp; 📅 **Last updated:** March 2026

---

## 📑 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Step 1 — GitHub EMU Account Setup](#step-1--github-emu-account-setup)
3. [Step 2 — Install GitHub Copilot CLI](#step-2--install-github-copilot-cli)
4. [Step 3 — GitHub Copilot CLI Login](#step-3--github-copilot-cli-login)
5. [Step 4 — Intro to CLIs for Beginners](#step-4--intro-to-clis-for-beginners)
6. [Step 5 — Explore GitHub Copilot CLI](#step-5--explore-github-copilot-cli)
7. [Step 6 — Install MCP + WorkIQ](#step-6--install-mcp--workiq)
8. [Step 7 — GitHub Copilot Skills](#step-7--github-copilot-skills)
9. [Step 8 — Create Custom Agents](#step-8--create-custom-agents)
10. [Bonus — Build a Personal Wins Tracker](#bonus--build-a-personal-wins-tracker)
11. [Troubleshooting](#troubleshooting)
12. [Resources](#resources)

---

## Prerequisites

| Requirement | Why it's needed |
|---|---|
| 🔑 **GitHub EMU account** | Enables access to Copilot models by logging in with your Microsoft-managed GitHub identity |
| 🔀 **Git** | Version control — Copilot CLI uses it to understand files, versions, and context |
| 🖥️ **PowerShell 7** (Windows) | Copilot CLI relies on modern PowerShell features (Windows ships with PS 5 by default — too old) |
| 💻 **Command-line access** | Terminal, PowerShell, or equivalent shell |

---

## Step 1 — GitHub EMU Account Setup

Your GitHub **Enterprise Managed User (EMU)** account is your Microsoft-managed GitHub identity. It is different from a personal GitHub account.

### Get your EMU account

1. Go to **<https://aka.ms/copilot>**
2. Verify you see your username — it will look like `youralias_microsoft`
3. If you **don't** see your username, your account may not be provisioned yet

> ⚠️ This is **not** your personal GitHub account. Your EMU account is tied to your Microsoft corporate identity.

### For Vendor Staff

If you go to <https://aka.ms/copilot> and see a blocked screen:

1. Contact your organization's GitHub administrator for Copilot seat access
2. **Request Membership** — this may require your manager's approval

> ⏳ There may be a delay in getting your Copilot seat license. Plan ahead.

### 💡 Tip: Use Edge Profiles

Use [Microsoft Edge profiles](https://www.microsoft.com/en-us/edge/features/profiles) to separate your work vs. personal GitHub accounts. This prevents accidental sign-ins with the wrong identity.

### Explore the installer script

This repo's `Setup-Terminal.ps1` script automates the installation of all required and optional tools. See [Step 2](#step-2--install-github-copilot-cli) below.

---

## Step 2 — Install GitHub Copilot CLI

There are two install paths: **automated** (recommended) or **manual**.

### Option A — Automated Script (Recommended)

The bootstrap script detects what's already installed, installs what's missing, and upgrades what's outdated.

1. Clone or download this repo
2. Open the folder
3. **Extract** the ZIP file (right-click → Extract All)
4. Open the extracted folder
5. **Double-click** `Install-CopilotCLI-Prereqs.bat`
6. The script will prompt you to install required & optional items — answer **Y/N** as appropriate
   - ✅ **Required:** PowerShell 7, Git, GitHub Copilot CLI
   - 📦 **Optional:** Node.js, Python, Azure CLI
7. When complete, the terminal will close
8. **Open PowerShell 7** (search "PowerShell" in the taskbar — select the one with the **black icon**)
9. Type `copilot` and press Enter
10. Copilot should start up! 🎉
11. Select **"Yes"** when asked about trusting files in the folder

> 📝 A full session log is saved as `bootstrap-log-YYYYMMDD-HHMMSS.txt` in the script folder.

### Option B — Manual Install (Fallback)

If the automated script doesn't work, install each tool manually:

#### 1. Git

- **Download:** <https://git-scm.com/download/win>
- Install with default options
- **Verify:** `git --version`

#### 2. PowerShell 7

1. Open existing PowerShell **as Administrator**
2. Run:
   ```powershell
   winget install --id Microsoft.PowerShell
   ```
3. Close and reopen — confirm you're in PowerShell **7.x** (black icon)

#### 3. GitHub Copilot CLI

**Using winget (recommended):**
```powershell
winget install --id GitHub.Copilot -e --accept-source-agreements --accept-package-agreements --source winget
```

**Using npm (alternative — requires Node.js):**
```powershell
npm install -g @githubnext/github-copilot-cli
```

- **Verify:** `copilot version`

#### 4. Node.js (Optional)

- **Download:** <https://nodejs.org/en/download>
- Install the **LTS** version
- **Verify:** `node -v` and `npm -v`

#### 5. Python (Optional)

- **Download:** <https://www.python.org/downloads/windows/>
- **Verify:** `python --version`

#### 6. Azure CLI (Optional)

- **Install docs:** <https://learn.microsoft.com/cli/azure/install-azure-cli-windows>
- **Verify:** `az --version`
- **Sign in:** `az login`

### macOS Users

| Tool | Install Command |
|---|---|
| Git | `xcode-select --install` (pre-installed on most Macs) |
| Copilot CLI | `brew install gh && gh extension install github/gh-copilot` |
| Node.js | `brew install node@22` |
| Python | `brew install python@3.12` |
| Azure CLI | `brew install azure-cli` |

> ⚠️ **Important:** After installing anything, close **all** terminals and open a fresh one so PATH updates take effect.

---

## Step 3 — GitHub Copilot CLI Login

1. Start the Copilot CLI:
   ```
   copilot
   ```
2. Type `/login`
3. Select **option 2:** `GitHub Enterprise Cloud with data residency (*ghe.com)`
4. Enter the URL: `https://github.com`
5. A **device code** will appear and a URL — press any key
6. A browser will open — **paste** the device code (it's auto-copied to your clipboard)
7. Click **"Authorize"** on any prompts
8. Return to the terminal — you should see a logged-in confirmation ✅

> 💡 If the browser doesn't open automatically, navigate to the URL shown in the terminal manually.

---

## Step 4 — Intro to CLIs for Beginners

If you're new to the command line, here are the essential navigation commands:

| Command | What it does |
|---|---|
| `cd <folder>` | Change into a directory |
| `cd ..` | Go up one directory |
| `ls` or `dir` | List files and folders in current directory |
| `pwd` | Print the current working directory |
| `cat <file>` or `Get-Content <file>` | Display the contents of a file |
| `mkdir <name>` | Create a new directory |
| `cls` or `clear` | Clear the terminal screen |

> 💡 You don't need to memorize these — once Copilot CLI is running, you can ask it to help you navigate!

---

## Step 5 — Explore GitHub Copilot CLI

Once logged in, explore Copilot CLI's core features:

### Key Features

| Feature | How to use | Description |
|---|---|---|
| **Chat mode** | Just type naturally | Ask questions, generate code, get explanations |
| **Slash commands** | `/help`, `/login`, `/clear`, etc. | Built-in commands for common actions |
| **Model switching** | `/model` | Switch between available AI models |
| **Resume sessions** | `/sessions` | Pick up where you left off in a previous session |
| **Custom instructions** | `.github/copilot-instructions.md` | Provide repo-level context and coding standards |

### Your First 10 Things to Try

| # | What to try | Example prompt |
|---|---|---|
| 1 | Navigate your project | `show me the folder structure of this repo` |
| 2 | Search for code | `find all files that import AuthService` |
| 3 | Explain something | `explain what this Dockerfile does` |
| 4 | Generate a file | `create a .gitignore for a Node.js project` |
| 5 | Fix an error | `I'm getting error CS1061 in Program.cs — help me fix it` |
| 6 | Work with Git | `write a commit message for my staged changes` |
| 7 | Create a script | `write a PowerShell script that finds large files in a directory` |
| 8 | Analyze logs | `summarize the errors in this log file` |
| 9 | Scaffold boilerplate | `create a basic Express.js API with health check endpoint` |
| 10 | Ask anything | `what's the difference between rebase and merge?` |

### Custom Instructions

| Type | Location | Purpose |
|---|---|---|
| **Custom Instructions** | `.github/copilot-instructions.md` | Project-wide context and coding standards applied to every conversation |
| **Reusable Prompts** | `.github/prompts/*.prompt.md` | Saved prompt templates you can invoke by name (like macros) |
| **Agent Instructions** | `.github/agents/*.md` | Specialized agents with specific tools and behaviors for a domain |

> 📚 Learn more: [GitHub Copilot CLI docs](https://docs.github.com/en/copilot/github-copilot-in-the-cli) · [Customizing Copilot](https://docs.github.com/en/copilot/customizing-copilot)

---

## Step 6 — Install MCP + WorkIQ

**WorkIQ** connects GitHub Copilot CLI to **Microsoft 365 Copilot**, giving you access to emails, meetings, documents, and Teams messages right from your terminal.

### Install WorkIQ Plugin

1. Start the Copilot CLI:
   ```
   copilot
   ```
2. Add the plugin marketplace:
   ```
   /plugin marketplace add github/copilot-plugins
   ```
3. Install WorkIQ:
   ```
   /plugin install workiq@copilot-plugins
   ```
4. **Accept the EULA** when prompted
5. **Restart PowerShell**, then launch Copilot again:
   ```
   copilot
   ```
6. Test it:
   ```
   tell me about my meetings this week
   ```

### What Can WorkIQ Do?

| Capability | Example prompt |
|---|---|
| 📅 **Meetings** | `tell me about my meetings this week` |
| 📧 **Emails** | `summarize my unread emails from today` |
| 📄 **Documents** | `find the latest design doc shared with me` |
| 💬 **Teams** | `what did my team discuss in the standup channel?` |
| 👤 **People** | `who is the PM for Project Alpha?` |

### WorkIQ MCP (for VS Code & other tools)

WorkIQ is also available as an **MCP server** for use in VS Code's Copilot chat, coding agents, and any MCP-compatible client.

- **WorkIQ MCP repo:** <https://github.com/microsoft/work-iq-mcp>
- **MCP documentation:** <https://modelcontextprotocol.io>

### Finding More MCPs

| Resource | Link |
|---|---|
| MCP specification | <https://modelcontextprotocol.io> |
| Microsoft MCP servers | <https://github.com/microsoft/mcp> |
| Azure MCP server | <https://github.com/Azure/azure-mcp> |
| Awesome MCP servers list | <https://github.com/punkpeye/awesome-mcp-servers> |

---

## Step 7 — GitHub Copilot Skills

**Skills** are reusable `.prompt.md` files that automate repeatable engineering tasks. Think of them as saved macros that your whole team can use.

### Creating a Skill

1. Create a file in your repo at `.github/prompts/your-skill-name.prompt.md`
2. Write your prompt template with clear instructions
3. Invoke it by name in the Copilot CLI

### Example Skill

```markdown
<!-- .github/prompts/create-unit-test.prompt.md -->
Generate a comprehensive unit test for the specified file using xUnit.
Include:
- Happy path tests
- Edge case tests
- Error handling tests
Follow our team's naming convention: MethodName_Scenario_ExpectedResult
```

> 📚 Explore community skills and patterns: [awesome-copilot](https://github.com/github/awesome-copilot)

### Tips

- Turn **repeating prompts** into skills so they're reusable
- Share skills across your team by committing them to the repo
- Be specific — include language, framework, and conventions in your skill

---

## Step 8 — Create Custom Agents

**Custom agents** are specialized Copilot assistants with specific tools, behaviors, and instructions tailored to a particular domain or workflow.

### Creating a Custom Agent

1. Create a markdown file in your repo at `.github/agents/your-agent-name.md`
2. Define the agent's role, tools, and behavior
3. The agent will be available in your Copilot CLI sessions for that repo

### Example Agent

```markdown
<!-- .github/agents/docs-agent.md -->
You are a documentation specialist. Your job is to:
- Write and update documentation files
- Follow our team's doc style guide
- Generate API documentation from code comments
- Never modify source code — only documentation files
```

### Agent Ideas

| Agent | Purpose |
|---|---|
| **Docs Agent** | Writes and updates documentation only |
| **Test Agent** | Generates unit and integration tests |
| **Code Review Agent** | Reviews code changes for bugs and best practices |
| **DevOps Agent** | Helps with CI/CD pipelines, Docker, and deployment |

> 📚 Learn more: [Customizing Copilot](https://docs.github.com/en/copilot/customizing-copilot)

---

## Bonus — Build a Personal Wins Tracker

Put your new Copilot CLI skills to the test with this hands-on exercise:

> **Build a Personal Wins Tracker** — a web app that captures your achievements, kudos, and impact highlights, then deploy it to GitHub Pages.

👉 **<https://aka.ms/garage/skillupai/wins-tracker>**

---

## Troubleshooting

| Symptom | Fix |
|---|---|
| Command not recognized after install | Close **all** terminals and open a fresh one |
| Still not recognized after reopening | Reboot and re-test |
| WinGet operations fail | Share the script log `bootstrap-log-*.txt` with IT |
| `copilot` not found but `gh` is installed | Run `gh copilot` instead, or: `gh extension install github/gh-copilot` |
| Permission denied (macOS/Linux) | Prefix commands with `sudo` |
| npm install fails globally | `sudo npm install -g ...` (Mac/Linux) or run as Administrator (Windows) |

---

## Resources

| Resource | Link |
|---|---|
| 📦 Installer script | `Setup-Terminal.ps1` in this repo |
| 🔑 Get your EMU account | <https://aka.ms/copilot> |
| 📚 Copilot CLI docs | <https://docs.github.com/en/copilot/github-copilot-in-the-cli> |
| 🎨 Customizing Copilot | <https://docs.github.com/en/copilot/customizing-copilot> |
| ⭐ Awesome Copilot (skills & patterns) | <https://github.com/github/awesome-copilot> |
| 🔮 WorkIQ MCP repo | <https://github.com/microsoft/work-iq-mcp> |
| 🌐 MCP documentation | <https://modelcontextprotocol.io> |
| 🏆 Wins Tracker exercise | <https://aka.ms/garage/skillupai/wins-tracker> |
| 🍎 PowerShell 7 download | <https://github.com/PowerShell/PowerShell/releases/latest> |
| 🔀 Git download | <https://git-scm.com/download/win> |
| 📦 Node.js download | <https://nodejs.org/en/download> |
| 🐍 Python download | <https://www.python.org/downloads/windows/> |
| ☁️ Azure CLI install | <https://learn.microsoft.com/cli/azure/install-azure-cli-windows> |

---

🎉 **You're all set!** Open PowerShell 7, type `copilot`, and start building.
