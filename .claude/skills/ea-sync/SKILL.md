---
name: ea-sync
description: Sync shared knowledge bases, update ea-core.md from template, and push personal changes
---

# /ea-sync - Sync EA

Keeps your EA in sync: pulls shared knowledge bases, updates core system instructions from the template repo, and commits/pushes your personal changes. Non-technical users never need to touch git directly.

Runs automatically as part of `/startup`, or can be called manually.

## Usage

```
/ea-sync                                              # Full sync (pull shared KBs, update core, push changes)
/ea-sync add https://github.com/org/shared-kb.git     # Add a new shared knowledge base
```

## Instructions

### Step 1: Pull Shared Knowledge Bases

Check if `kb/shared/` exists and contains any subdirectories that are git repos. For each one, pull latest changes.

```bash
# Find all git repos under kb/shared/
for dir in kb/shared/*/; do
  if [ -d "$dir/.git" ]; then
    cd "$dir" && git pull && cd -
  fi
done
```

**Possible outcomes per repo:**
- **Already up to date** — Note silently, move on
- **Updated** — Note how many files changed and the repo name
- **Conflict or error** — Report the error clearly. Do NOT try to auto-resolve merge conflicts. Tell the user what happened and suggest they ask for help.
- **No shared repos** — Skip silently, this is fine

### Step 2: Update ea-core.md from Template

Fetch the latest `ea-core.md` from the template repo and overwrite the local copy. This is how system upgrades are shipped.

First, check if the repo has a remote origin to determine the template source:

```bash
git remote get-url origin
```

Use the template repo URL from the remote's GitHub org. If the remote is `github.com/SOME-ORG/ea-username`, fetch from `github.com/SOME-ORG/ea-template-generic` (or the configured template repo).

If unable to determine the template URL, skip this step and note it.

**If download succeeds:**
- Compare with current `ea-core.md` to check for changes
- If different, replace local file
- Note in summary: "ea-core.md updated"

**If download fails:**
- Delete the temp file if it exists
- Note the error but continue — this is not critical

**IMPORTANT:** Never modify ea-core.md locally. It is always overwritten from the template. User-specific config belongs in CLAUDE.md.

### Step 3: Commit and Push Personal Changes

Check the personal repo (root directory) for uncommitted changes.

```bash
git status
```

**What to auto-commit:**
- Modified or new files in `kb/` (except `kb/shared/` which contains separate repos)
- `MEMORY.md`
- Files in `.claude/skills/`
- `ea-core.md` (if updated from template in Step 2)

**What NOT to auto-commit:**
- `kb/shared/` subdirectories — these are separate git repos
- `CLAUDE.md` — changes here are deliberate and should be committed manually
- `.claude/settings.json`, `.mcp.json` — config changes are deliberate
- `.claude/settings.local.json` — machine-specific, should be in .gitignore
- Any files that look like secrets, credentials, or tokens

**Commit process:**
1. Check `git status` for changes in the allowed paths
2. If changes exist, stage them: `git add kb/ MEMORY.md .claude/skills/ ea-core.md` (git will respect .gitignore for kb/shared/)
3. Commit with message: `EA sync: auto-commit [date]`
4. Push to remote: `git push`

**If nothing to commit:** Skip silently.

**If push fails** (e.g., remote has changes): Run `git pull --rebase` first, then push. If rebase conflicts, report the error and stop.

### Step 4: Output Summary

Provide a brief sync summary. Keep it minimal unless something notable happened.

**If nothing changed:**
```
Synced. No changes.
```

**If things happened:**
```
SYNC:
- Shared KBs: company-kb updated (3 files changed)
- ea-core.md: Updated from template
- Personal: Pushed 2 changes (MEMORY.md, kb/todos.md)
```

**If errors:**
```
SYNC:
- Shared KBs: company-kb pull failed - [error description]
- ea-core.md: OK
- Personal: Pushed OK

[Suggestion for resolving the error]
```

## Adding a Shared Knowledge Base

When called with `add <url>`:

```
/ea-sync add https://github.com/org/shared-kb.git
```

1. **Create `kb/shared/` if it doesn't exist**

2. **Derive the folder name from the repo URL:**
   - `https://github.com/org/kb-company-data.git` → `kb/shared/kb-company-data`
   - Or let the user specify a name: `/ea-sync add <url> as <name>`
   - If a name is given: `kb/shared/<name>`

3. **Clone the repo:**
   ```bash
   git clone <url> kb/shared/<name>
   ```

4. **Verify `.gitignore` excludes it:**
   - Check that `kb/shared/` is in `.gitignore`
   - If not, add it and commit

5. **Confirm:**
   ```
   Added shared KB: kb/shared/<name>
   This will be synced automatically on each /ea-sync and /startup.

   Contents:
   - [list top-level files/folders in the cloned repo]
   ```

6. **Read the shared KB** to understand what's in it. If there's a README or _overview.md, summarise it for the user.

## Removing a Shared Knowledge Base

When asked to remove a shared KB:

1. Confirm with the user: "Remove kb/shared/<name>? This deletes the local clone but doesn't affect the remote repo."
2. Delete the directory: `rm -rf kb/shared/<name>`
3. Note in summary

## When Called from /startup

When running as part of `/startup`, keep output to one line unless there are errors:
- No changes: Don't mention sync at all
- Changes: One line in the startup summary, e.g., "Synced: 2 shared KB updates, ea-core updated, personal changes pushed"
- Errors: Surface prominently with the error details
