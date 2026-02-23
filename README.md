# Executive Assistant

A personal AI-powered executive assistant built on [Claude Code](https://claude.ai/code). Uses a structured knowledge base (compatible with [Obsidian](https://obsidian.md)) and Claude's capabilities to manage your daily workflow.

## What It Does

- **Daily briefings** — Calendar, email triage, meeting prep, action items
- **Meeting preparation** — Full context from past meetings, open actions, suggested agenda
- **Inbox processing** — Transcripts, notes, and imports routed to the right place
- **Task management** — Central todo list with delegation, priorities, and tracking
- **Action tracking** — Open items grouped by person, project, and due date
- **Weekly reviews** — Rollup of outcomes, completed work, and next week preview

## Setup

### Prerequisites

- [Claude Code](https://claude.ai/code) installed
- [Git](https://git-scm.com/) installed and authenticated with GitHub

### 1. Create your repo

Click **"Use this template"** on this repo's GitHub page to create your own copy (e.g., `ea-yourname`). Make it **private**.

### 2. Clone and run setup

```powershell
git clone https://github.com/YOUR-ORG/ea-yourname.git
cd ea-yourname
.\setup.ps1
```

The setup script will:
- Ask for your name, email, timezone, and direct reports
- Personalise your configuration
- Create team member folders for your 1:1s
- Commit and push everything

### 3. Connect your Google account

Open Claude Code in your EA directory and connect your Google account:

```
claude
```

Tell Claude to connect your Google Calendar and Gmail via Rube MCP.

### 4. Start using it

```
/startup    — Proactive check of inbox, calendar, and actions (runs automatically)
/morning    — Generate your daily briefing
/process    — Process items in your inbox
/prep       — Prepare for a meeting or 1:1
```

## How It Works

| File | What it is | Edit it? |
|------|-----------|----------|
| `ea-core.md` | System instructions (shared, auto-updated) | No — updated by `/ea-sync` |
| `CLAUDE.md` | Your personal config (name, email, timezone) | Yes — it's yours |
| `MEMORY.md` | Claude's working memory for your context | Managed by Claude |
| `kb/` | Your knowledge base (people, projects, meetings) | Yes — it's yours |

## Skills

| Skill | Description |
|-------|-------------|
| `/startup` | Session start — checks inbox, calendar, overdue actions |
| `/morning` | Daily briefing with meeting prep and priorities |
| `/process` | Route inbox items (transcripts, notes, imports) to KB |
| `/prep [meeting]` | Deep meeting preparation with full context |
| `/debrief` | Quick post-meeting capture |
| `/actions` | All open action items grouped and prioritised |
| `/status [entity]` | Quick summary of a person, company, or project |
| `/weekly` | Weekly review and next week preview |
| `/my-tasks` | Review and execute Claude's delegated tasks |
| `/ea-sync` | Sync system updates and push your changes |

## Customisation

- **Add team profiles:** Create `kb/team/firstname-lastname/_profile.md`
- **Add 1:1 topics:** Create `kb/team/firstname-lastname/_topics.md`
- **Create custom skills:** Add to `.claude/skills/yourskill/SKILL.md`
- **Add personal skills:** Document them in the "Additional Skills" section of your `CLAUDE.md`
- **Add a tone guide:** Create `kb/reference/tone-guide.md` with your writing style preferences

## Upgrades

System updates are shipped via `ea-core.md` in this template repo. When you run `/ea-sync` (or `/startup`), it automatically fetches the latest version. Your personal config in `CLAUDE.md` is never overwritten.
