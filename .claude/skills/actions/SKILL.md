---
name: actions
description: Action item overview - all open tasks grouped by person, project, and due date
---

# /actions - Action Item Overview

Comprehensive view of all open action items.

## Usage

```
/actions              # Full overview
/actions overdue      # Only overdue items
/actions Jane         # Actions related to Jane
/actions this week    # Due this week
```

## Instructions

### Step 1: Read Central Todo List

**Primary source:** `kb/todos.md`

This is the central todo list. Read it first for all active tasks.

### Step 2: Find Distributed Tasks

Also grep the KB for tasks that may exist in context files:

```bash
grep -r "\- \[ \]" kb/ --include="*.md" | grep -v "kb/todos.md" | grep -v "kb/_templates/"
```

**Note:** Tasks should be consolidated into `kb/todos.md` for visibility. If found elsewhere, suggest moving them.

### Step 3: Parse Each Task

For each task found, extract:
- **Task text:** The action item description
- **Priority:** Look for ⏫ (highest), 🔺 (high), 🔼 (medium), 🔽 (low), ⏬ (lowest)
- **Project:** Parse `| [[Project]]` if present
- **Requestor:** Parse `| from [[Person]]` if present
- **Due date:** Parse `📅 YYYY-MM-DD` if present
- **Scheduled:** Parse `⏳ YYYY-MM-DD` if present
- **Recurrence:** Parse `🔁 every...` if present
- **Created:** Parse `➕ YYYY-MM-DD` if present
- **Location:** Which file it's in (for distributed tasks)

### Step 4: Categorize

Group tasks by multiple dimensions:

#### By Status
- **Overdue:** Due date before today
- **Due Today:** Due date is today
- **Due This Week:** Due in next 7 days
- **Upcoming:** Due date >7 days away
- **No Date:** No due date specified

#### By Owner
- **User's tasks:** Tasks the user needs to do
- **Waiting on others:** Tasks assigned to other people

#### By Context
- **By Person:** Group by who the task relates to
- **By Project:** Group by project
- **By Company:** Group by client/supplier

### Step 5: Output Overview

```markdown
# Action Items Overview

*Generated: YYYY-MM-DD HH:MM*

## Summary

| Category | Count |
|----------|-------|
| 🔴 Overdue | X |
| 📅 Due Today | X |
| 📆 This Week | X |
| ⏳ Upcoming | X |
| ❓ No Date | X |
| **Total Open** | **X** |

---

## 🔴 Overdue

| Pri | Task | Due | Project | From |
|-----|------|-----|---------|------|
| 🔺 | [Task description] | YYYY-MM-DD | [[Project]] | [[Person]] |

---

## 📅 Due Today

| Pri | Task | Project | From |
|-----|------|---------|------|
| ⏫ | [Task description] | [[Project]] | [[Person]] |

---

## 📆 Due This Week

| Pri | Task | Due | Project | From |
|-----|------|-----|---------|------|

---

## ⏳ Upcoming (Next 30 Days)

| Pri | Task | Due | Project | From |
|-----|------|-----|---------|------|

---

## ⏸️ Waiting On Others

| Task | Delegated To | Due | Check Back |
|------|--------------|-----|------------|

---

## ❓ No Due Date

| Pri | Task | Project | From |
|-----|------|---------|------|

---

## By Project

### [[Project Name]]
- [ ] [Task 1] 🔺 | from [[Person]] | 📅 YYYY-MM-DD

---

## By Requestor

### [[Person Name]]
- [ ] [Task 1] | [[Project]] | 📅 YYYY-MM-DD

```

### Step 6: Highlight Critical Items

At the end, surface the most important:

```markdown
## ⚡ Immediate Attention

These need action today:

1. **[Task]** - [X days overdue] - [Context]
2. **[Task]** - Due today - [Context]
```

## Filtered Views

### /actions overdue
Only show overdue items with full context.

### /actions [person]
Show all tasks related to a specific person.

### /actions this week
Show tasks due in the next 7 days, sorted by date.

### /actions [project]
Show all tasks related to a specific project.

## Maintenance Suggestions

If issues are found, suggest fixes:

```markdown
## 🔧 Maintenance Suggestions

- **12 tasks have no due date** - Consider adding dates for better tracking
- **3 tasks are >30 days overdue** - Review if still relevant
```

## Quick Summary Mode

For a fast check:

```
Actions Summary:
- 🔴 2 overdue (oldest: 5 days)
- 📅 1 due today
- 📆 4 due this week
- ⏳ 8 upcoming

Top priority: [Most critical overdue task]
```
