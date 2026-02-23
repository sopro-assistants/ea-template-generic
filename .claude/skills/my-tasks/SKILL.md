---
name: my-tasks
description: Review delegated tasks, suggest pickups, clarify context, and execute in parallel
---

# /my-tasks - Claude Task Management

Review the todo list, suggest tasks Claude could pick up, clarify context on delegated tasks, and execute ready tasks in parallel.

## Usage

```
/my-tasks
```

Run anytime to have Claude check and work through delegated tasks.

## Instructions

### Step 1: Read Todo List

Read `kb/todos.md` and parse all tasks:

1. **Delegated to Claude** - Tasks with `@Claude` that are not done
2. **User's open tasks** - All other open tasks (potential pickups)

### Step 2: Categorize Claude's Tasks

For each `@Claude` task, categorize:

| Category | Criteria | Action |
|----------|----------|--------|
| **Ready** | Has enough context to start immediately | Queue for execution |
| **Needs clarification** | Missing info, ambiguous scope, unclear output | Add to questions list |
| **Blocked** | Depends on something external or another task | Note blocker |

### Step 3: Suggest Pickups

Review the user's open tasks and identify ones Claude could help with:

**Good candidates:**
- Research tasks (competitor analysis, market data, documentation review)
- Document drafting (overviews, summaries, templates)
- Data gathering (pulling info from emails, calendar, KB)
- Administrative (scheduling, email drafts, meeting prep)
- Analysis (reviewing transcripts, summarizing threads)

**Not suitable:**
- Tasks requiring the user's judgment or authority
- External meetings or calls
- Tasks marked as personal
- Anything requiring physical action

Present suggestions:
```
I could help with these from your list:
1. "Research X" - I can gather data and summarize
2. "Draft overview for Y" - I can create first draft for your review
3. "Summarize meeting notes" - I can process and extract action items

Want me to take any of these on? (I'll add @Claude and start working)
```

### Step 4: Clarify All Questions Upfront

**CRITICAL:** Before executing ANY task, gather all needed context.

For each task needing clarification, ask specific questions:

```
Before I start on your delegated tasks, I need some context:

**Task: "Research competitor pricing"**
- Which competitors? (list names or say "top 3 in our space")
- What pricing info? (public plans, enterprise estimates, feature comparison)
- Output format? (summary doc, comparison table, bullet points)

Please answer these so I can work on all tasks in parallel.
```

Wait for answers before proceeding to execution.

### Step 5: Execute Ready Tasks

Once all clarifications are gathered, execute tasks in parallel using background agents.

For each ready task:

```python
# Use Task tool with appropriate subagent
Task(
    subagent_type="general-purpose",  # or "Explore" for research
    prompt="[Detailed task prompt with all context from clarification]",
    run_in_background=True,
    description="Working on: [task name]"
)
```

**Parallel execution rules:**
- Independent tasks → run simultaneously
- Dependent tasks → run sequentially
- Large tasks → consider breaking into subtasks

**Agent prompts should include:**
- Full task description
- All clarified context from the user
- Expected output format
- Where to save results (if applicable)
- Note: "You cannot ask the user questions - work with the context provided"

### Step 6: Monitor and Report

While agents run:
```
Working on 3 tasks in parallel:
⏳ Research competitor pricing...
⏳ Draft overview doc...
✓ Summarize emails - Complete

[When all complete]

All tasks finished. Here's the summary:

**1. Research competitor pricing**
[Key findings or link to output]

**2. Draft overview doc**
[Summary and location: kb/projects/x/overview.md]

**3. Summarize emails**
[Summary with action items extracted]
```

### Step 7: Update Todos

After completion:

1. Mark completed tasks as done with `@Claude` tag preserved:
   ```
   - [x] Research competitor pricing | @Claude | ✅ 2026-01-28
   ```

2. Add any follow-up tasks discovered during execution

3. Note any tasks that couldn't be completed and why

## Proactive Behavior

When the user adds a task with `@Claude` during a conversation:

1. Notice the delegation immediately
2. Ask: "I see you've assigned me [task]. Want me to start on it now, or should I pick it up later via /my-tasks?"
3. If starting now, ask any clarifying questions inline

## Task Execution Templates

### Research Task
```
Research [topic] with the following scope:
- Focus areas: [from clarification]
- Sources to check: [web, KB, emails, etc.]
- Output: Create a summary document at [path] with:
  - Key findings
  - Data points with sources
  - Recommendations if applicable
- You cannot ask questions - use your judgment for ambiguities
```

### Document Draft Task
```
Draft [document type] for [audience]:
- Purpose: [from clarification]
- Key points to cover: [list]
- Tone: [from clarification or infer from audience]
- Length: [estimate]
- Output: Save to [path]
- Reference tone guide at kb/reference/tone-guide.md if it exists
- You cannot ask questions - create best draft for review
```

### Summary/Analysis Task
```
Analyze [source material]:
- What to look for: [specific items]
- Output format: [bullets, table, narrative]
- Extract: [action items, decisions, key points, etc.]
- You cannot ask questions - note any ambiguities in output
```

## Error Handling

| Issue | Response |
|-------|----------|
| Agent fails | Report error, suggest manual approach or retry |
| Insufficient context after clarification | Ask follow-up questions, don't guess |
| Task too ambiguous | Ask the user to redefine scope |
| External dependency (API, file access) | Note blocker, skip to next task |

## Output Locations

When tasks produce artifacts:
- Documents → `kb/` appropriate subfolder
- Research → `kb/reference/` or project folder
- Meeting prep → `kb/board/` or `kb/team/[person]/`
- Drafts → Note location in completion summary for review
