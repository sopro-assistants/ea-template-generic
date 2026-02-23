---
name: morning
description: Generate daily briefing with calendar, meeting prep, emails, and action items
---

# /morning - Daily Briefing

Generate a comprehensive daily briefing to start the day informed and prepared.

## Instructions

### Step 1: Get Current Date/Time

Use Rube MCP to get current date and time using the timezone from CLAUDE.md:
```
GOOGLECALENDAR_GET_CURRENT_DATE_TIME with timezone from CLAUDE.md
```

Store the date for file naming: `YYYY-MM-DD`

### Step 2: Fetch Calendar Events

Fetch today's events AND 3-4 day lookahead for document preparation needs.

**IMPORTANT:** Only query the user's primary calendar. Do NOT use `EVENTS_LIST_ALL_CALENDARS`.

```
GOOGLECALENDAR_EVENTS_LIST with:
- calendarId: "primary"
- timeMin: today 00:00:00 in RFC3339 format with timezone
- timeMax: today + 4 days 00:00:00 in RFC3339 format
- singleEvents: true
- orderBy: "startTime"
```

### Step 3: Build Meeting Briefs

For each meeting TODAY with external attendees or direct reports:

1. **Identify attendees** - extract email addresses
2. **Look up profiles** - check if we have KB profiles:
   - Team: `kb/team/[firstname-lastname]/_profile.md`
   - Clients: `kb/clients/[company]/_profile.md`
   - Suppliers: `kb/suppliers/[company]/_profile.md`
3. **Pull recent meetings** - check for meeting files in last 30 days
4. **Check open actions** - grep for `- [ ]` tasks mentioning this person/company
5. **Summarize context** for each meeting:
   - Who they are (role, company, relationship)
   - Last interaction (date, key points)
   - Open items between us
   - What to watch for

For recurring internal meetings (1:1s, team meetings), note any overdue actions.

### Step 4: Check Important Emails

Use Rube MCP to check Gmail for priority items:

```
GMAIL_FETCH_EMAILS with:
- user_id: "me"
- q: "is:unread is:important newer_than:1d"
- max_results: 20
```

Categorize emails:
- **Needs response** - direct questions, requests
- **FYI** - updates, newsletters, notifications
- **Delegatable** - things someone else should handle

Flag any emails from:
- Board members
- Direct reports with "urgent" language
- External contacts with active deals/projects

### Step 5: Surface Action Items

Grep the KB for open tasks:

```bash
# Find all open tasks
grep -r "\- \[ \]" kb/

# Find overdue tasks (tasks with dates before today)
# Parse dates in format 📅 YYYY-MM-DD
```

Categorize:
- **Overdue** - past due date (highlight these!)
- **Due today** - due date is today
- **Due this week** - coming up soon
- **Waiting on** - tasks assigned to others

### Step 6: Check Memory Signals

Read `MEMORY.md` and check:
- Any "Signals to Watch" that might be relevant today
- Any "Follow-ups needed" that are due
- Cross-reference with today's meetings

### Step 6b: Check Document Needs (3-4 Day Lookahead)

For meetings in the next 3-4 days, identify document preparation needs:

1. **Scan upcoming meetings for new concept introductions:**
   - Project kickoffs
   - Strategy discussions
   - Client proposals
   - Board presentations
   - Any meeting where the user is presenting something new

2. **For each meeting needing docs:**
   - Check if relevant docs exist in KB (`kb/projects/`, `kb/reference/`)
   - Check if docs have been sent already

3. **If docs are needed but don't exist:**
   - Add to "Documents Needed" section
   - Create todo: "Draft overview for [topic] | [[Project]] | - | 📅 [day before meeting]"
   - Offer to draft immediately if time permits

4. **If docs exist but haven't been sent:**
   - Note in "Documents to Send" section
   - Remind to attach to calendar invite or email ahead

### Step 7: Generate Daily Note

Create the daily note at `kb/daily/YYYY-MM-DD.md`:

```markdown
---
type: daily
date: YYYY-MM-DD
---

# Daily Briefing - [Day of Week], [Month] [Day], [Year]

## Today's Schedule

| Time | Event | With | Prep |
|------|-------|------|------|
| HH:MM | Meeting Name | Attendees | Quick context or "see brief below" |

## Meeting Briefs

### [Meeting Name] (HH:MM)

**With:** [Names and roles]
**Context:** [What this is about]
**Last interaction:** [Date - key points]
**Open items:**
- Item 1
- Item 2
**Watch for:** [Anything to keep in mind]

---

## Priority Actions

### Overdue
- [ ] Task 1 📅 YYYY-MM-DD - [person/project]

### Due Today
- [ ] Task 2 📅 YYYY-MM-DD - [person/project]

### This Week
- [ ] Task 3 📅 YYYY-MM-DD - [person/project]

---

## Email Triage

### Needs Response
- **From:** Subject - [brief context]

### FYI
- **From:** Subject

---

## Tomorrow Preview

| Time | Event | Notes |
|------|-------|-------|
| HH:MM | Meeting | Brief context |

---

## Documents Needed (Next 3-4 Days)

*Preference: Share written overviews in advance for new concepts/projects.*

### Upcoming Meetings Needing Docs

| Date | Meeting | Topic | Doc Status |
|------|---------|-------|------------|
| YYYY-MM-DD | Meeting name | What's being introduced | ✅ Ready / 📝 To draft / 📤 To send |

### Action Items
- [ ] Draft overview for [topic] 📅 YYYY-MM-DD (day before meeting)
- [ ] Send [doc] to [person] ahead of [meeting]

*Offer: "Want me to draft the [topic] overview now?"*

---

## Flags & Signals

- [Any signals from MEMORY.md that are relevant]
- [Any patterns noticed]

```

### Step 8: Output Summary

After generating the daily note, provide a verbal summary:

```
Morning briefing ready: kb/daily/YYYY-MM-DD.md

TODAY:
- X meetings (Y need prep)
- Z overdue actions
- N emails need response

TOP PRIORITIES:
1. [Most important thing]
2. [Second thing]
3. [Third thing]

HEADS UP:
- [Any warnings or things to watch]
```

## Handling Missing Data

- If no profile exists for a meeting attendee: note "No profile on file - consider adding after meeting"
- If calendar API fails: fall back to manual schedule input
- If Gmail API fails: skip email section, note it's unavailable

## Email Query Tips

Useful Gmail search operators:
- `is:unread` - unread messages
- `is:important` - marked important
- `is:starred` - starred messages
- `from:(@domain.com)` - from specific domain
- `newer_than:1d` - last 24 hours
- `subject:(urgent OR asap)` - urgent subjects
- `has:attachment` - has attachments

## Profile Lookup Pattern

To find a person's profile:
1. Extract name from email (e.g., `jane.smith@company.com` → Jane Smith)
2. Convert to folder path: `kb/team/jane-smith/_profile.md`
3. If not found in team, check clients/suppliers by company domain
4. If external with no profile, note as "new contact"

## Time Handling

- Use the timezone from CLAUDE.md for all times
- Use 24-hour format for clarity
- Note if events span timezones (international calls)
- Flag very early (<8am) or late (>6pm) meetings
