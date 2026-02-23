---
name: startup
description: Proactive session start check - inbox, upcoming meetings, overdue actions, and flags
proactive: true
---

# /startup - Session Start Check

Quick proactive check at the start of each session to surface anything needing attention.

**Run this automatically when starting a new session.**

## Instructions

### Step 0: Sync

Run `/ea-sync` to push personal changes and update system. Keep output minimal:
- **No changes:** Don't mention sync at all in the startup summary
- **Changes:** Add one line to the summary, e.g., "Synced: ea-core updated"
- **Errors:** Surface prominently before other checks

### Step 1: Check Inbox for New Items

Scan these folders for unprocessed items:

```
kb/inbox/transcripts/
kb/inbox/notes/
kb/inbox/imports/
```

Count items in each folder. If any items exist, note them for processing.

### Step 2: Check Calendar for Imminent Meetings

Use Rube MCP to get current time and check for meetings in the next 2 hours.

**IMPORTANT:** Only query the user's primary calendar. Do NOT use `EVENTS_LIST_ALL_CALENDARS`.

Read the user's timezone from CLAUDE.md and use it:

```
GOOGLECALENDAR_GET_CURRENT_DATE_TIME with timezone from CLAUDE.md
GOOGLECALENDAR_EVENTS_LIST with:
- calendarId: "primary"
- timeMin: now
- timeMax: now + 2 hours
- singleEvents: true
- orderBy: "startTime"
```

For any meetings found:
- Check if meeting has a profile in KB (attendee lookup)
- Check if there's recent meeting context
- Flag if prep might be needed

### Step 3: Check for Overdue Actions

Grep the KB for open tasks with past due dates:

```bash
grep -r "\- \[ \]" kb/
```

Parse any tasks with `📅 YYYY-MM-DD` format and check if date is before today.

Categorize:
- **Overdue** - past due date
- **Due today** - due date is today

### Step 4: Check Memory Signals

Read `MEMORY.md` quickly for:
- Any "Follow-ups needed" items
- Any "Signals to Watch" that might need checking
- Any "Upcoming" items in the next day or two

### Step 4a: Check Delegated Tasks

Read `kb/todos.md` and check the "Delegated to Claude" section for any pending tasks assigned to Claude. Surface these in the startup summary.

### Step 4b: Check for Document Needs (3-4 Day Lookahead)

Quick scan of calendar for next 3-4 days to identify meetings where overview docs may be needed:

```
GOOGLECALENDAR_EVENTS_LIST with:
- calendarId: "primary"
- timeMin: now
- timeMax: now + 4 days
- singleEvents: true
```

For each meeting, quickly assess:
- Is the user introducing something new?
- Is this a project kickoff, proposal, or strategy discussion?
- Does a written overview need to be drafted or sent?

Flag any meetings needing doc prep in the summary.

### Step 5: Output Summary

Provide a concise startup summary:

```
Good [morning/afternoon/evening].

INBOX: [X transcripts, Y notes, Z imports to process | Empty]

NEXT 2 HOURS:
- [Meeting at HH:MM with Person - prep available/needed]
- [No meetings]

OVERDUE: [N tasks | None]

DOCS NEEDED (next 3-4 days):
- [Meeting on DATE: Need to draft/send overview for TOPIC]
- [None needed]

DELEGATED TO CLAUDE: [N pending tasks | None]
- [Task description - due DATE]

FLAGS:
- [Any signals or follow-ups worth noting]

Suggested: [What to do first - e.g., "Run /process" or "Run /prep for 10:00 meeting"]
```

## Quick Check Mode

If the inbox is empty, no imminent meetings, and no overdue tasks, just say:

```
All clear. No inbox items, no meetings in the next 2 hours, no overdue tasks.
```

## Time-of-Day Awareness

Adjust greeting and suggestions based on time:
- **Before 9am**: "Good morning" - suggest /morning if not run today
- **9am-12pm**: "Good morning" - focus on today's priorities
- **12pm-5pm**: "Good afternoon" - check what's left for the day
- **After 5pm**: "Good evening" - lighter check, prep for tomorrow

## Proactive Triggers

If any of these are found, prompt immediately:

| Finding | Prompt |
|---------|--------|
| Unprocessed transcripts | "You have X transcript(s) to process. Run /process?" |
| Meeting in <30 min without prep | "Meeting with [Person] in [X] minutes. Run /prep [person]?" |
| 3+ overdue tasks | "You have X overdue tasks. Run /actions to review?" |
| Important email flags in memory | Surface the flag with context |
| Meeting in 2-4 days needs overview doc | "You have [Meeting] on [Date] - looks like it needs an overview doc. Want to draft it now?" |

## Integration with Other Skills

After /startup, suggest appropriate next actions:
- If inbox items → `/process`
- If meeting soon → `/prep [meeting/person]`
- If overdue tasks → `/actions`
- If morning and no briefing today → `/morning`
