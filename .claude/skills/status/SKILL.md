---
name: status
description: Quick status summary of a person, company, or project
args: "[entity name]"
---

# /status - Entity Status

Quick summary of a person, company, or project - recent activity, open actions, upcoming meetings, and health indicators.

## Usage

```
/status Jane           # Status on Jane Smith
/status Acme Corp      # Status on client company
/status "New Platform" # Status on project
```

## Instructions

### Step 1: Identify the Entity

Parse the argument to determine type:
- **Person:** Check `kb/team/`, then client/supplier contacts
- **Company:** Check `kb/clients/`, then `kb/suppliers/`
- **Project:** Check `kb/projects/`

If ambiguous, check both and clarify if needed.

### Step 2: Gather Information

#### For a Person

1. **Read profile:** `kb/team/[name]/_profile.md` or find in client/supplier
2. **Recent meetings:** Last 3-5 from their meetings folder
3. **Open actions:** Grep for `- [ ]` mentioning their name
4. **Upcoming meetings:** Check calendar for next 14 days
5. **Memory context:** Check MEMORY.md for mentions

#### For a Company

1. **Read profile:** `kb/clients/[company]/_profile.md`
2. **Relationship status:** From frontmatter (active, prospect, churned)
3. **Key contacts:** Listed in profile
4. **Recent meetings:** Last 3-5 from meetings folder
5. **Open actions:** Related tasks
6. **Related projects:** Check `kb/projects/` for company mentions

#### For a Project

1. **Read project file:** `kb/projects/[project].md`
2. **Status:** From frontmatter (active, on-hold, completed)
3. **Owner & stakeholders:** From frontmatter
4. **Recent activity:** Updates in the file
5. **Open actions:** Tasks in the project file
6. **Related meetings:** Grep for project name in meeting files

### Step 3: Output Status

```markdown
# Status: [Entity Name]

## Overview
[One paragraph summary - who/what, current state, key context]

## Quick Facts
| Attribute | Value |
|-----------|-------|
| Type | [Person/Company/Project] |
| Role/Relationship | [Their role or relationship type] |
| Status | [Active/On-hold/etc.] |
| Last Contact | [Date - topic] |
| Next Meeting | [Date - topic] or "None scheduled" |

## Recent Activity
| Date | Event | Summary |
|------|-------|---------|
| YYYY-MM-DD | [Type] | [Brief summary] |

## Open Items
- [ ] [Task 1] 📅 YYYY-MM-DD
- [ ] [Task 2] 📅 YYYY-MM-DD

*Or: No open items*

## Health/Flags
[Any concerns, signals to watch, or positive indicators]

## Related
- [[Related Entity 1]] - [relationship]
- [[Related Entity 2]] - [relationship]
```

### Status Indicators

Use these to quickly convey health:

| Indicator | Meaning |
|-----------|---------|
| ✅ Healthy | No concerns, relationship strong |
| ⚠️ Watch | Minor concerns or needs attention soon |
| 🔴 Alert | Significant issue requiring action |
| ⏸️ On Hold | Paused or inactive |
| 🆕 New | Recent addition, building relationship |

## Quick Status Mode

For rapid checks, output a condensed version:

```
Jane Smith (VP Sales) ✅
Last: 2026-01-16 (1:1 - pipeline review)
Next: 2026-01-24 10:00 (1:1)
Open: 2 items (1 overdue)
Flag: Very busy with demos this week
```

## Handling Missing Data

- **No profile exists:** "No profile on file for [name]. Would you like me to create one?"
- **No recent activity:** "No recent meetings or activity tracked."
- **No open items:** "No open action items."
- **Entity not found:** "I couldn't find [name]. Did you mean [suggestion]? Or should I search more broadly?"
