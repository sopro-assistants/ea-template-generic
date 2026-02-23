---
name: debrief
description: Post-meeting quick capture - decisions, actions, notes (when no transcript)
---

# /debrief - Post-Meeting Capture

Quick capture after a meeting when there's no transcript. Creates a meeting file and updates relevant profiles.

## Usage

```
/debrief                    # Prompts for meeting details
/debrief Jane 1:1           # Debrief for specific meeting
```

## Instructions

### Step 1: Identify the Meeting

If not specified, check calendar for recently ended meetings:
```
GOOGLECALENDAR_EVENTS_LIST with:
- calendarId: "primary"
- timeMin: now - 3 hours
- timeMax: now
- singleEvents: true
- orderBy: "startTime"
```

Ask to confirm which meeting to debrief, or prompt for details:
- Who was it with?
- What type of meeting? (1:1, client call, team meeting, etc.)

### Step 2: Capture Key Information

Prompt for:

1. **What happened?** (1-3 sentences)
   - Main topics discussed
   - Overall tone/outcome

2. **Decisions made?**
   - Any commitments or agreements
   - Changes to plans or strategy

3. **Action items?**
   - Tasks for the user
   - Tasks for others
   - Due dates if discussed

4. **Anything else to note?**
   - Follow-ups needed
   - Context for next time
   - Red flags or concerns

### Step 3: Create Meeting File

Determine the correct location:

| Meeting Type | Location |
|--------------|----------|
| Team 1:1 | `kb/team/[person]/meetings/YYYY-MM-DD-1on1.md` |
| Team meeting | `kb/team/meetings/YYYY-MM-DD-[topic].md` |
| Client meeting | `kb/clients/[company]/meetings/YYYY-MM-DD-[topic].md` |
| Supplier meeting | `kb/suppliers/[company]/meetings/YYYY-MM-DD-[topic].md` |
| Board meeting | `kb/board/meetings/YYYY-MM-DD-[topic].md` |
| Other | Ask where to file |

Create the meeting file:

```markdown
---
type: meeting
date: YYYY-MM-DD
attendees: ["[[Person 1]]", "[[Person 2]]"]
related: ["[[Project Name]]"]
summary: "One-line summary"
---

# [Meeting Title] - YYYY-MM-DD

## Summary

[What happened - 1-3 sentences]

## Discussion Points

- [Key topic 1]
- [Key topic 2]
- [Key topic 3]

## Decisions

- [Decision 1]
- [Decision 2]

## Action Items

- [ ] [Action for user] 📅 YYYY-MM-DD
- [ ] [Action for Person] - assigned to [[Person]] 📅 YYYY-MM-DD

## Notes

[Any additional context, follow-ups, or things to remember]
```

### Step 4: Update Profiles

For each attendee with a profile, add to their "Recent Activity" section:

```markdown
## Recent Activity

- **YYYY-MM-DD** - [Meeting type]: [1-line summary]. [Key outcome or action].
```

Keep Recent Activity to last 5-10 entries (prune old ones if needed).

### Step 5: Update Memory (if significant)

If the meeting involved:
- New commitments → Add to "Committed to" in MEMORY.md
- Waiting on someone → Add to "Waiting on" in MEMORY.md
- Important context → Add to "Recent Context"
- Signals worth watching → Add to "Signals to Watch"

### Step 6: Confirm and Summarize

Output:
```
Meeting captured: kb/[path]/YYYY-MM-DD-[topic].md

Updated profiles:
- [[Person 1]] - Recent Activity
- [[Person 2]] - Recent Activity

Action items created:
- [ ] [Task 1] 📅 YYYY-MM-DD
- [ ] [Task 2] 📅 YYYY-MM-DD

Memory updated: [Yes/No - what was added]
```

## Quick Debrief Mode

For very quick captures, accept minimal input:

```
/debrief Jane - discussed pipeline, she'll send forecast by Friday
```

Parse this to:
- Meeting with Jane
- Topic: pipeline discussion
- Action: Jane to send forecast by Friday

Create abbreviated meeting file and update profile.

## Handling Edge Cases

- **No profile for attendee:** Create the meeting file anyway, note "Profile needed for [Person]"
- **Unclear meeting type:** Ask where to file it
- **No actions:** That's fine - still capture the summary
- **Sensitive content:** Note it but keep details minimal if indicated
