---
name: weekly
description: Weekly review - meetings, outcomes, actions completed, next week preview
---

# /weekly - Weekly Review

Comprehensive review of the past week and preview of the week ahead.

## Usage

```
/weekly                # Review current week (Mon-Sun)
/weekly last           # Review previous week
/weekly 2026-01-13     # Review week containing this date
```

## Instructions

### Step 1: Determine Week Range

Calculate the week boundaries:
- **Current week:** Monday of current week through Sunday
- **Last week:** Previous Monday through Sunday
- **Specific date:** Find the Monday-Sunday containing that date

Use Rube MCP to get current date:
```
GOOGLECALENDAR_GET_CURRENT_DATE_TIME with timezone from CLAUDE.md
```

### Step 2: Gather Week's Data

#### Meetings
Fetch all calendar events for the week:
```
GOOGLECALENDAR_EVENTS_LIST with:
- calendarId: "primary"
- timeMin: [Monday 00:00]
- timeMax: [Sunday 23:59]
- singleEvents: true
- orderBy: "startTime"
```

#### Meeting Notes
Check for meeting files created this week:
```
kb/team/*/meetings/YYYY-MM-DD-*.md
kb/clients/*/meetings/YYYY-MM-DD-*.md
kb/suppliers/*/meetings/YYYY-MM-DD-*.md
kb/board/meetings/YYYY-MM-DD-*.md
```

#### Daily Notes
Read daily briefings for the week:
```
kb/daily/YYYY-MM-DD.md (for each day in the week)
```

#### Completed Actions
Search for completed tasks:
```bash
grep -r "\- \[x\]" kb/
```

#### New Actions Created
Check for new open tasks created this week by looking at file modification dates or meeting notes.

### Step 3: Gather Next Week Preview

Fetch next week's calendar:
```
GOOGLECALENDAR_EVENTS_LIST with:
- calendarId: "primary"
- timeMin: [Next Monday 00:00]
- timeMax: [Next Sunday 23:59]
- singleEvents: true
- orderBy: "startTime"
```

Check MEMORY.md for:
- Upcoming items
- Deadlines approaching
- Signals to watch

### Step 4: Generate Weekly Review

```markdown
# Weekly Review: [Date Range]

*Week of Monday, [Month Day] - Sunday, [Month Day], [Year]*

---

## Week at a Glance

| Metric | Count |
|--------|-------|
| Meetings held | X |
| Meeting notes captured | X |
| Actions completed | X |
| New actions created | X |

---

## Meetings This Week

### Monday, [Date]
| Time | Meeting | With | Outcome |
|------|---------|------|---------|
| HH:MM | [Meeting] | [Attendees] | [Brief outcome or "No notes"] |

### Tuesday, [Date]
...

*(Continue for each day)*

---

## Key Outcomes & Decisions

Significant things that happened this week:

1. **[Outcome/Decision]** - [Context and impact]
2. **[Outcome/Decision]** - [Context and impact]

---

## Actions Completed ✅

- [x] [Task completed] - [Date completed]

*Or: No completed actions tracked this week*

---

## Actions Created (Still Open)

- [ ] [New task] 📅 YYYY-MM-DD - from [meeting/context]

---

## Carried Forward (Still Open from Before)

- [ ] [Existing task] 📅 YYYY-MM-DD - [status/blocker if known]

---

## Patterns & Observations

[Observations about the week - what went well, what could improve, patterns noticed]

---

## Next Week Preview

### Monday, [Date]
| Time | Meeting | With | Prep Needed |
|------|---------|------|-------------|
| HH:MM | [Meeting] | [Attendees] | [Yes/No] |

*(Continue for each day with meetings)*

---

## Key Dates & Deadlines

| Date | Item | Notes |
|------|------|-------|
| [Date] | [Deadline/Event] | [Context] |

---

## Priorities for Next Week

Based on open actions, upcoming meetings, and patterns:

1. **[Priority 1]** - [Why it matters]
2. **[Priority 2]** - [Why it matters]
3. **[Priority 3]** - [Why it matters]

---

## Flags & Watchlist

- [Items from MEMORY.md Signals to Watch]
- [New concerns from this week]
```

### Step 5: Update Memory

After generating the review, update MEMORY.md:
- Move completed items out of "Open Loops"
- Add new commitments to appropriate sections
- Update "Recent Context" with week summary
- Refresh "Upcoming" with next week's key dates

### Step 6: Offer Options

```
Weekly review complete.

Options:
1. Save to kb/daily/weekly-YYYY-MM-DD.md
2. Update MEMORY.md with this week's learnings
3. Just use for reference

What would you like to do?
```

## Quick Summary Mode

For a fast overview:

```
Week of Jan 20-26:
- 12 meetings (8 with notes)
- 5 actions completed
- 3 new actions created
- 2 overdue items carried forward

Highlights:
- Closed deal with Acme Corp
- Pipeline looking strong
- Planning session scheduled

Next week:
- 8 meetings scheduled
- Board call on Wednesday
- Q1 planning deadline Friday
```
