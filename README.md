# Executive Assistant

A personal AI-powered executive assistant built on [Claude Code](https://claude.ai/code). It manages your calendar, email, meetings, tasks, and knowledge base — all from the command line.

Your knowledge base is stored as markdown files (compatible with [Obsidian](https://obsidian.md)), so everything Claude knows about your work is in plain text files you own and control.

## What It Does

- **Daily briefings** — Calendar, email triage, meeting prep, action items
- **Meeting preparation** — Full context from past meetings, open actions, suggested agenda
- **Inbox processing** — Transcripts, notes, and imports routed to the right place
- **Task management** — Central todo list with delegation, priorities, and tracking
- **Action tracking** — Open items grouped by person, project, and due date
- **Weekly reviews** — Rollup of outcomes, completed work, and next week preview
- **People & company profiles** — Context that builds up over time, so Claude remembers who's who
- **Written overviews** — Proactively suggests drafting docs before important meetings

---

## Installation

### What You'll Need

1. **An Anthropic account with Claude Code access**
   - Sign up at [claude.ai](https://claude.ai) if you don't have one
   - Claude Code requires a Max plan ($100/month) or an API key

2. **Claude Code installed on your machine**
   - Follow the install guide at [claude.ai/code](https://claude.ai/code)
   - On Windows: download the installer or use `winget install Anthropic.Claude-Code`
   - On Mac: `brew install claude-code` or download from the site
   - Verify it works by opening a terminal and typing `claude --version`

3. **Git installed and authenticated with GitHub**
   - Download from [git-scm.com](https://git-scm.com/) if not already installed
   - Verify with `git --version` in your terminal
   - You need to be able to push to GitHub (either via SSH key or HTTPS with a credential manager)

4. **A Google Workspace or Gmail account** (for calendar and email integration)

### Step 1: Create Your Repo

On this repo's GitHub page, click the green **"Use this template"** button → **"Create a new repository"**.

- **Owner:** Your personal account or your organisation
- **Name:** Something like `ea-yourname` (e.g., `ea-jane`)
- **Visibility:** Private (recommended — this will contain your personal work data)

### Step 2: Clone It

Open a terminal (PowerShell on Windows, Terminal on Mac) and clone your new repo:

```powershell
# Replace with your actual repo URL
git clone https://github.com/YOUR-USERNAME/ea-yourname.git

# Go into the folder
cd ea-yourname
```

### Step 3: Run the Setup Script

The setup script personalises your assistant. It asks a few questions and configures everything.

**On Windows (PowerShell):**
```powershell
.\setup.ps1
```

> **If you get a script execution error**, run this first:
> ```powershell
> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
> ```
> Then try `.\setup.ps1` again.

**On Mac/Linux:**
The setup script is PowerShell-based. You can either:
- Install PowerShell: `brew install powershell` then `pwsh setup.ps1`
- Or skip the script and manually edit `CLAUDE.md` — replace the `[YOUR_NAME]`, `[YOUR_EMAIL]`, `[YOUR_TITLE]`, and `[YOUR_TIMEZONE]` placeholders with your details

The setup script will:
- Ask for your name, email, job title, and timezone
- Ask for your direct reports (people you have regular 1:1s with)
- Create profile folders for each person
- Personalise your `CLAUDE.md` configuration file
- Commit and push everything
- Create a desktop shortcut to open your EA folder
- Remove itself from the repo (it's a one-time setup)

### Step 4: Connect Google Calendar and Gmail

This is where Claude gets access to your calendar and email. Open Claude Code in your EA directory:

```
claude
```

Once Claude starts, tell it:

> "Connect my Google Calendar and Gmail"

Claude will guide you through connecting via **Rube MCP** (an integration layer). You'll:
1. Click a link to authorise your Google account
2. Grant read access to your calendar and email
3. Claude confirms the connection is active

**What gets connected:**
- **Google Calendar** — Claude reads your events to prepare briefings and meeting prep
- **Gmail** — Claude scans for important unread emails to surface in briefings

**Privacy note:** Claude reads your calendar and email during sessions to help you. Your data isn't stored anywhere except your local knowledge base files.

### Step 5: Start Using It

You're ready. Here are the key commands:

```
/startup    — Runs automatically when you start a session. Checks inbox, calendar, and overdue tasks.
/morning    — Generates a full daily briefing with meeting prep and priorities.
/process    — Processes items in your inbox folders (transcripts, notes, imports).
/prep Jane  — Deep preparation for your next meeting with Jane.
/debrief    — Quick capture after a meeting (when you don't have a transcript).
/actions    — Overview of all open action items.
/weekly     — Weekly review and next week preview.
```

### Step 6 (Optional): Set Up Obsidian

Your knowledge base (`kb/` folder) is a standard Obsidian vault. If you want to browse and edit it visually:

1. Download [Obsidian](https://obsidian.md/) (free for personal use)
2. Open it and choose "Open folder as vault"
3. Select the `kb/` folder inside your EA directory
4. Install the **Tasks** plugin (Settings → Community plugins → Browse → search "Tasks")

This gives you a nice visual interface for your notes, tasks, and profiles. It's entirely optional — Claude works with the files directly either way.

---

## How It Works

Your EA has a few key files:

| File | What it is | Who edits it |
|------|-----------|--------------|
| `CLAUDE.md` | Your personal config (name, email, timezone, direct reports) | You |
| `ea-core.md` | System instructions that tell Claude how to be an EA | Auto-updated (don't edit) |
| `MEMORY.md` | Claude's working memory — what it remembers between sessions | Claude |
| `kb/` | Your knowledge base — people, projects, meetings, tasks | You + Claude |
| `kb/todos.md` | Central task list (compatible with Obsidian Tasks plugin) | You + Claude |

### The Knowledge Base (`kb/`)

```
kb/
├── inbox/            ← Drop files here for Claude to process
│   ├── transcripts/  ← Meeting transcripts (e.g., from Otter.ai)
│   ├── notes/        ← Quick capture notes
│   └── imports/      ← Files to process (xlsx, pdf, etc.)
├── team/             ← One folder per person you work with
│   └── jane-smith/
│       ├── _profile.md    ← Who they are, working style, context
│       ├── _topics.md     ← Queue of things to discuss in your next 1:1
│       └── meetings/      ← Meeting notes by date
├── clients/          ← Client company profiles and meeting notes
├── suppliers/        ← Supplier profiles and meeting notes
├── projects/         ← Project files and notes
├── board/            ← Board meeting materials
├── daily/            ← Daily briefings (generated by /morning)
├── personal/         ← Personal items (health, shopping, etc.)
├── reference/        ← Processed reference materials
├── scrapes/          ← Web scraping output
└── todos.md          ← Central task list
```

### How Sessions Work

1. You open a terminal in your EA folder and type `claude`
2. Claude automatically runs `/startup` — checks your inbox, calendar, and tasks
3. You interact naturally: "What's on today?", "Prep me for my 2pm", "Add a task to follow up with Jane"
4. Claude updates your knowledge base as you go — profiles, meeting notes, tasks, memory
5. When you close the session, everything is saved in your files (and auto-pushed to git)

### Task Format

Tasks use [Obsidian Tasks](https://publish.obsidian.md/tasks/) format:

```markdown
- [ ] Review Q1 forecast 🔺 | [[Planning]] | from [[Jane]] | 📅 2026-01-30
- [ ] Book dentist appointment | - | - | 📅 2026-02-01
- [ ] Research competitor pricing | @Claude | 📅 2026-02-01
```

Add `@Claude` to any task to delegate it. Run `/my-tasks` to have Claude work through its assignments.

---

## Skills Reference

| Skill | Description |
|-------|-------------|
| `/startup` | Session start — checks inbox, calendar, overdue actions (runs automatically) |
| `/morning` | Daily briefing with meeting prep, email triage, and priorities |
| `/process` | Route inbox items (transcripts, notes, imports) to the right place in KB |
| `/prep [name]` | Deep meeting preparation with full context, open items, suggested agenda |
| `/debrief` | Quick post-meeting capture when you don't have a transcript |
| `/actions` | All open action items grouped by person, project, and due date |
| `/status [name]` | Quick summary of a person, company, or project |
| `/weekly` | Weekly review — meetings, outcomes, next week preview |
| `/my-tasks` | Review and execute tasks delegated to Claude |
| `/ea-sync` | Sync system updates and push your changes to git |

---

## Customisation

**Add team profiles:** Create `kb/team/firstname-lastname/_profile.md` with their role, working style, and context. Claude builds on these over time as you have meetings.

**Queue 1:1 topics:** Create `kb/team/firstname-lastname/_topics.md`. When you mention wanting to discuss something with someone, Claude adds it to their queue. `/prep` pulls from it.

**Add a tone guide:** Create `kb/reference/tone-guide.md` describing how you write. Claude will match your style when drafting emails and documents.

**Create custom skills:** Add a `SKILL.md` file in `.claude/skills/yourskill/` to teach Claude new workflows specific to your role.

**Personal config:** Edit `CLAUDE.md` to update your details, add custom skills, or change preferences.

---

## Upgrades

System updates are shipped via `ea-core.md` in this template repo. When you run `/ea-sync` (or `/startup`), it automatically fetches the latest version. Your personal config in `CLAUDE.md` is never overwritten.

---

## Troubleshooting

**"claude" command not found**
Claude Code isn't installed or isn't in your PATH. Reinstall from [claude.ai/code](https://claude.ai/code) and restart your terminal.

**Setup script won't run (Windows)**
Run `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser` in PowerShell first.

**Google Calendar/Gmail not connecting**
Make sure you're telling Claude to connect via "Rube MCP". If it fails, try: "Connect my Google account using the Rube MCP server."

**Git push fails**
Check that you have write access to your repo. Try `git push` manually to see the error. You may need to set up a [personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) or SSH key.

**Claude doesn't know who I am**
Check that `CLAUDE.md` has your details filled in (not the `[YOUR_NAME]` placeholders). If you skipped the setup script, edit it manually.
