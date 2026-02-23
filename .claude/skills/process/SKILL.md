---
name: process
description: Process new items in the inbox folders, routing them to appropriate locations in the knowledge base and updating memory
---

# /process - Inbox Processing

Process new items in the inbox folders, routing them to appropriate locations in the knowledge base.

## Instructions

Scan the inbox folders and process each item:

### Step 1: Scan Inbox

Check these folders for new items:
- `kb/inbox/transcripts/` - Meeting transcripts
- `kb/inbox/notes/` - Quick capture notes
- `kb/inbox/imports/` - Files to process (xlsx, pptx, pdf, md, etc.)

List what's found and process each item.

### Step 2: Process Each Item

For each item, determine what it is and where it belongs:

#### Transcripts (`/inbox/transcripts/`)
1. Read the transcript
2. Identify the meeting: date, attendees, topic
3. Ask user to confirm which meeting/person this relates to if unclear
4. Create meeting file in appropriate location:
   - Team 1:1 → `kb/team/[person]/meetings/YYYY-MM-DD-1on1.md`
   - Client meeting → `kb/clients/[company]/meetings/YYYY-MM-DD-topic.md`
   - Board meeting → `kb/board/meetings/YYYY-MM-DD-topic.md`
   - Other → ask user
5. Include in meeting file:
   - Frontmatter (type, date, attendees, related, summary)
   - Key discussion points (summarized, not full transcript)
   - Decisions made
   - Action items in Obsidian Tasks format: `- [ ] task 📅 YYYY-MM-DD`
6. Update relevant `_profile.md` Recent Activity section
7. Delete or archive the original transcript

#### Quick Notes (`/inbox/notes/`)
1. Read the note
2. Parse intent - is it:
   - An action item? → Extract task, identify person/project, add to appropriate file
   - A note about someone? → Add to their profile
   - A note about a project? → Add to project file
   - General thought? → Ask user where it belongs
3. If note mentions a person:
   - Find or create their profile
   - Add as action item: `- [ ] [Action] with [[Person]] 📅 [appropriate date]`
4. Delete the processed note

#### Imports (`/inbox/imports/`)
1. Analyze the file (read content, check filename)
2. Determine category:

   **Client/Supplier Materials**:
   - Route to `/kb/clients/[company]/` or `/kb/suppliers/[company]/`
   - Create company folder and `_profile.md` if doesn't exist
   - Ask user to confirm company

   **Project Materials**:
   - Route to `/kb/projects/[project]/`
   - Create project file if doesn't exist
   - Ask user to confirm project

   **General Reference**:
   - Route to `/kb/reference/`
   - Create summary markdown if useful

3. For binary files (xlsx, pptx, pdf):
   - Store original in appropriate location
   - Create/update index file with key information extracted from the file
   - Use pandas/openpyxl for xlsx, python-pptx for pptx

4. **Move processed file to `/kb/inbox/imports/archive/`** so unprocessed items are always visible

### Step 3: Update Memory

After processing, update `MEMORY.md` if anything significant was learned:

**Company context changes:**
- New/updated key metrics → Update relevant sections
- Strategy or priority changes → Update "Current Focus" or "Company Context"

**People/Project updates:**
- New active project → Add to "Active Projects" table
- Important person context → Add to "Key People Right Now"
- New commitments or waiting items → Add to "Open Loops"

**Signals:**
- If something needs watching/follow-up → Add to "Signals to Watch"

**Keep memory lean:** ~200 lines max. Summarize, don't accumulate. Remove stale items.

### Step 4: Summary

After processing all items, provide a summary:
- What was processed
- Where items were routed
- Any action items created
- Any memory updates made
- Any items that need follow-up

## Handling Uncertainty

When unsure about routing:
1. State what the item appears to be
2. Suggest most likely destination
3. Ask user to confirm or redirect
4. Never guess on important routing decisions

## File Reading Tools

For binary files, use:
- **xlsx**: `python -c "import pandas as pd; print(pd.read_excel('file.xlsx').to_markdown())"`
- **pptx**: `python -c "from pptx import Presentation; ..."`
- **pdf**: Read tool supports PDFs directly

## Examples

**Transcript processing:**
```
Found: kb/inbox/transcripts/meeting-2026-01-23.txt
This appears to be a 1:1 with Sarah Chen based on attendees.
→ Creating: kb/team/sarah-chen/meetings/2026-01-23-1on1.md
→ Updating: kb/team/sarah-chen/_profile.md (Recent Activity)
→ Extracted 3 action items
```

**Quick note processing:**
```
Found: kb/inbox/notes/note.txt
Content: "discuss budget with jane"
→ This looks like an action item about Jane
→ Adding to: kb/team/jane/_profile.md
→ Task: "- [ ] Discuss budget with [[Jane]] 📅 2026-01-24"
```

**Import processing:**
```
Found: kb/inbox/imports/Q4-report.xlsx
This appears to be financial data.
Should I file this in /reference/ and create a summary index? [Y/confirm destination]
```
