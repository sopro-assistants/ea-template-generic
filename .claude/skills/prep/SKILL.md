---
name: prep
description: Deep meeting preparation - pulls history, context, open actions, and suggests agenda
args: "[meeting or person name]"
---

# /prep - Meeting Preparation

Deep preparation for an upcoming meeting or conversation with a person.

## Usage

```
/prep Jane            # Prep for next meeting with Jane
/prep Acme Corp       # Prep for Acme-related meeting
/prep "Board call"    # Prep for specific meeting by name
```

## Instructions

### Step 1: Identify the Target

Parse the argument to determine:
- Is it a **person name**? → Find their profile and upcoming meeting
- Is it a **meeting name**? → Find the calendar event and attendees
- Is it a **company name**? → Find company profile and relevant meeting

If ambiguous, ask for clarification.

### Step 2: Gather Context

#### For a Person

1. **Find their profile:**
   - Team: `kb/team/[firstname-lastname]/_profile.md`
   - Client contact: `kb/clients/[company]/_profile.md` (check contacts in frontmatter)
   - Supplier: `kb/suppliers/[company]/_profile.md`

2. **Pull recent meetings** (last 90 days):
   ```
   kb/team/[person]/meetings/*.md
   kb/clients/[company]/meetings/*.md
   ```
   Read the most recent 3-5 meeting files.

3. **Find open actions:**
   ```bash
   grep -r "\- \[ \]" kb/ | grep -i "[person name]"
   ```
   Also check their profile for any noted commitments.

4. **Check 1:1 topics queue (direct reports only):**
   If the person is a direct report, check for queued discussion topics:
   ```
   kb/team/[firstname-lastname]/_topics.md
   ```
   Pull any items in the "To Discuss" section - these are topics the user wanted to cover.

5. **Check calendar for upcoming meeting:**
   ```
   GOOGLECALENDAR_EVENTS_LIST with:
   - calendarId: "primary"
   - timeMin: now
   - timeMax: now + 7 days
   - q: "[person name]"
   - singleEvents: true
   ```

#### For a Company/Client

1. **Find company profile:** `kb/clients/[company]/_profile.md`
2. **Pull recent meetings** from `kb/clients/[company]/meetings/`
3. **Check relationship status** in frontmatter
4. **Find all contacts** and their context
5. **Check for related projects** in `kb/projects/`

#### For a Specific Meeting

1. **Find the calendar event** by name or time
2. **Identify all attendees**
3. **Look up each attendee's profile**
4. **Gather context for the meeting topic**

### Step 4: Check Recent Emails

Fetch recent email correspondence with the attendee(s):

```
GMAIL_FETCH_EMAILS with:
- user_id: "me"
- query: "from:[email] OR to:[email]"
- max_results: 10
- include_payload: true
```

**Evaluate relevance:**
- Is the email about an upcoming meeting, project, or shared topic?
- Does it contain context needed for the meeting?
- Does it have attachments that might be discussed?
- Is it just scheduling/logistics? (skip if so)

**For relevant emails, capture:**
- Subject and date
- Key points from the content
- Any attachments (note filename and what it likely contains)
- Gmail link format: `https://mail.google.com/mail/u/0/#inbox/[messageId]`

**Skip emails that are:**
- Pure calendar invites/logistics
- Newsletters or automated notifications
- Unrelated to the meeting topic

### Step 5: Check Memory

Read `MEMORY.md` for:
- Any mentions of this person/company in "Open Loops"
- Any relevant "Signals to Watch"
- Any context in "Recent Context"
- Related "Active Projects"

### Step 5b: Check for Overview Documents

For meetings involving new concepts, projects, or initiatives:

1. **Identify if overview docs are needed:**
   - Is the user introducing something new to the attendees?
   - Is this a project kickoff or strategy discussion?
   - Are there topics where a written overview would help?

2. **Check if docs exist:**
   - Search KB for relevant project/topic docs
   - Check `kb/projects/`, `kb/reference/`, related folders

3. **If docs exist:**
   - Note them in prep brief under "Documents to Share"
   - Include KB path and suggest attaching to calendar invite or sending ahead

4. **If docs are needed but don't exist:**
   - Flag this prominently in the prep brief
   - Add to suggested actions: "Draft overview for [topic]"
   - Offer to help create the document now

### Step 6: Generate Prep Brief

Output a structured prep document:

```markdown
# Prep: [Meeting/Person Name]

## Meeting Details
- **When:** [Date, Time]
- **With:** [Attendees with roles]
- **Where:** [Location/Link]

## Context

### Who They Are
[Brief on the person/company - role, relationship, what they care about]

### Relationship History
[Summary of interactions, how long we've worked together, relationship health]

### Recent Interactions
| Date | Topic | Key Points |
|------|-------|------------|
| YYYY-MM-DD | [Meeting type] | [1-2 key points] |

### Recent Email Correspondence

*Include only emails relevant to the meeting topic. Skip logistics/scheduling.*

| Date | Subject | Key Points | Link |
|------|---------|------------|------|
| YYYY-MM-DD | [Subject] | [Brief summary] | [View](https://mail.google.com/mail/u/0/#inbox/[messageId]) |

*Or: No recent relevant email correspondence*

## Open Items

### We Owe Them
- [ ] [Action committed to]

### They Owe Us
- [ ] [Action they committed to]

### Ongoing Threads
- [Topic that's been discussed across multiple meetings]

### Queued 1:1 Topics (direct reports only)
*From _topics.md - items to discuss:*
- [ ] [Topic from queue]

*Or omit this section if not a direct report*

## Suggested Agenda

Based on open items and recent context:
1. [Topic - why it matters]
2. [Topic - why it matters]
3. [Topic - why it matters]

## Watch For

- [Things to be aware of during the meeting]
- [Sensitivities or context that matters]

## Documents

### Ready to Share
- `kb/projects/project-name.md` → Export as .docx and send/attach

### Needs Creation
- [ ] Draft overview for [topic] - [who needs it, by when]

*Preference: Written overviews should be shared in advance for new concepts/projects.*

## Related

- [[Project Name]] - [relevance]
- [[Other Person]] - [relevance]
```

### Step 7: Offer Next Actions

Ask if the user wants to:
- Save the prep as a note
- Create a calendar event note
- Just use it for reference

**For documents:**
- If overview docs exist: "Want me to export [doc] as .docx and you can attach/send it?"
- If docs are needed: "Want to draft the overview for [topic] now?"

## Profile Lookup Patterns

| Looking for | Path |
|-------------|------|
| Direct report | `kb/team/[firstname-lastname]/_profile.md` |
| Client company | `kb/clients/[company-name]/_profile.md` |
| Client contact | Check `contacts` in client company profile |
| Supplier | `kb/suppliers/[company-name]/_profile.md` |
| Board member | `kb/board/[name]/_profile.md` |

## Handling Missing Data

- **No profile exists:** Note this, offer to create one after the meeting
- **No recent meetings:** Note "First meeting" or "No recent interactions on file"
- **No open actions:** Note "No outstanding items"
- **Person not found:** Ask for clarification or check if spelling is different
