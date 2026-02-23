---
name: ea-sync
description: Update ea-core.md from template, commit and push personal changes
---

# /ea-sync - Sync EA

Keeps your EA in sync: updates core system instructions from the template repo and commits/pushes your personal changes. Non-technical users never need to touch git directly.

Runs automatically as part of `/startup`, or can be called manually.

## Instructions

### Step 1: Update ea-core.md from Template

Fetch the latest `ea-core.md` from the template repo and overwrite the local copy. This is how system upgrades are shipped.

First, check if the repo has a remote origin to determine the template source:

```bash
git remote get-url origin
```

Use the template repo URL from the remote's GitHub org. If the remote is `github.com/SOME-ORG/ea-username`, fetch from `github.com/SOME-ORG/ea-template` (or the configured template repo).

If unable to determine the template URL, skip this step and note it.

**If download succeeds:**
- Compare with current `ea-core.md` to check for changes
- If different, replace local file
- Note in summary: "ea-core.md updated"

**If download fails:**
- Delete the temp file if it exists
- Note the error but continue — this is not critical

**IMPORTANT:** Never modify ea-core.md locally. It is always overwritten from the template. User-specific config belongs in CLAUDE.md.

### Step 2: Commit and Push Personal Changes

Check the personal repo (root directory) for uncommitted changes.

```bash
git status
```

**What to auto-commit:**
- Modified or new files in `kb/`
- `MEMORY.md`
- Files in `.claude/skills/`
- `ea-core.md` (if updated from template in Step 1)

**What NOT to auto-commit:**
- `CLAUDE.md` — changes here are deliberate and should be committed manually
- `.claude/settings.json`, `.mcp.json` — config changes are deliberate
- `.claude/settings.local.json` — machine-specific, should be in .gitignore
- Any files that look like secrets, credentials, or tokens

**Commit process:**
1. Check `git status` for changes in the allowed paths
2. If changes exist, stage them: `git add kb/ MEMORY.md .claude/skills/ ea-core.md`
3. Commit with message: `EA sync: auto-commit [date]`
4. Push to remote: `git push`

**If nothing to commit:** Skip silently.

**If push fails** (e.g., remote has changes): Run `git pull --rebase` first, then push. If rebase conflicts, report the error and stop.

### Step 3: Output Summary

Provide a brief sync summary. Keep it minimal unless something notable happened.

**If nothing changed:**
```
Synced. No changes.
```

**If things happened:**
```
SYNC:
- ea-core.md: Updated from template
- Personal: Pushed 2 changes (MEMORY.md, kb/todos.md)
```

**If errors:**
```
SYNC:
- ea-core.md: Update failed - [error description]
- Personal: Pushed OK

[Suggestion for resolving the error]
```

## When Called from /startup

When running as part of `/startup`, keep output to one line unless there are errors:
- No changes: Don't mention sync at all
- Changes: One line in the startup summary, e.g., "Synced: ea-core updated, personal changes pushed"
- Errors: Surface prominently with the error details
