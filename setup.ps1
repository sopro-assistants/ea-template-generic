#Requires -Version 5.1
param(
    [switch]$DryRun
)
<#
.SYNOPSIS
    IT'S ALIVE! - Executive Assistant Setup
    Brings your Claude Code Executive Assistant to life.

.DESCRIPTION
    Run this after cloning your EA repo from the template.
    Personalizes CLAUDE.md, sets up direct report folders, and commits everything.

    Use -DryRun to see what would happen without changing anything.

.EXAMPLE
    .\setup.ps1
    .\setup.ps1 -DryRun
#>

# ============================================================
#  BANNER
# ============================================================

Clear-Host
Write-Host ""
Write-Host "  +----------------------------------------------+" -ForegroundColor Green
Write-Host "  |                                              |" -ForegroundColor Green
Write-Host "  |       >>> I T ' S   A L I V E ! <<<          |" -ForegroundColor Yellow
Write-Host "  |                                              |" -ForegroundColor Green
Write-Host "  |      Executive Assistant Setup               |" -ForegroundColor Cyan
Write-Host "  |      Powered by Claude Code                  |" -ForegroundColor Cyan
Write-Host "  |                                              |" -ForegroundColor Green
Write-Host "  +----------------------------------------------+" -ForegroundColor Green
Write-Host ""
if ($DryRun) {
    Write-Host "  +----------------------------------------------+" -ForegroundColor Magenta
    Write-Host "  |       DRY RUN - nothing will be changed       |" -ForegroundColor Magenta
    Write-Host "  +----------------------------------------------+" -ForegroundColor Magenta
    Write-Host ""
}
Write-Host "  Let's bring your AI assistant to life..." -ForegroundColor Gray
Write-Host ""

# ============================================================
#  CHECK WE'RE IN THE RIGHT PLACE
# ============================================================

$EADir = Get-Location

if (-not (Test-Path (Join-Path $EADir "ea-core.md"))) {
    Write-Host "  ERROR: Can't find ea-core.md in current directory." -ForegroundColor Red
    Write-Host "  Make sure you've cloned your EA repo and are running this from inside it." -ForegroundColor Red
    Write-Host ""
    Write-Host "  Expected:" -ForegroundColor Gray
    Write-Host "    git clone https://github.com/YOUR-ORG/ea-YOURNAME.git" -ForegroundColor Gray
    Write-Host "    cd ea-YOURNAME" -ForegroundColor Gray
    Write-Host "    .\setup.ps1" -ForegroundColor Gray
    exit 1
}

if (-not (Test-Path (Join-Path $EADir ".git"))) {
    Write-Host "  ERROR: This doesn't look like a git repo." -ForegroundColor Red
    Write-Host "  Clone from GitHub first, then run setup." -ForegroundColor Red
    exit 1
}

# ============================================================
#  CHECK PREREQUISITES
# ============================================================

Write-Host "  Checking prerequisites..." -ForegroundColor Gray

$gitVersion = & git --version 2>$null
if (-not $gitVersion) {
    Write-Host "  ERROR: git is not installed or not in PATH." -ForegroundColor Red
    exit 1
}
Write-Host "  [OK] $gitVersion" -ForegroundColor Green

# Check Claude Code
$claudeVersion = & claude --version 2>$null
if ($claudeVersion) {
    Write-Host "  [OK] Claude Code $claudeVersion" -ForegroundColor Green
} else {
    Write-Host "  [WARN] Claude Code not found. Install it from https://claude.ai/code" -ForegroundColor Yellow
    Write-Host "         You can still run setup - just install Claude Code before using the EA." -ForegroundColor Gray
}

Write-Host ""

# ============================================================
#  GATHER USER INFO
# ============================================================

Write-Host "  --- WHO ARE YOU? ---" -ForegroundColor Cyan
Write-Host ""

$Name = Read-Host "  Your first name"
$FullName = Read-Host "  Your full name (e.g. Jane Smith)"
$Title = Read-Host "  Your job title (e.g. Head of Sales)"
$Email = Read-Host "  Your work email (e.g. jane@company.com)"
$ReportsTo = Read-Host "  Who do you report to? (e.g. John Doe)"

Write-Host ""
Write-Host "  --- TIMEZONE ---" -ForegroundColor Cyan
Write-Host "  Common options: Europe/London, America/New_York, America/Los_Angeles, Asia/Tokyo"
$Timezone = Read-Host "  Your timezone (default: Europe/London)"
if ([string]::IsNullOrWhiteSpace($Timezone)) {
    $Timezone = "Europe/London"
}

# ============================================================
#  DIRECT REPORTS
# ============================================================

Write-Host ""
Write-Host "  --- YOUR DIRECT REPORTS ---" -ForegroundColor Cyan
Write-Host "  (People you have regular 1:1s with. Leave blank to skip.)"
Write-Host "  Enter full names one per line, blank line when done."
Write-Host ""

$DirectReports = @()
while ($true) {
    $dr = Read-Host "  Direct report name"
    if ([string]::IsNullOrWhiteSpace($dr)) { break }
    $DirectReports += $dr
}

# ============================================================
#  OTHER REGULARS (non-direct-reports with 1:1s)
# ============================================================

Write-Host ""
Write-Host "  --- OTHER REGULAR 1:1s ---" -ForegroundColor Cyan
Write-Host "  (e.g. chairman, cross-functional partners. Leave blank to skip.)"
Write-Host ""

$OtherRegulars = @()
while ($true) {
    $or = Read-Host "  Name (and role, e.g. 'Sam Wilson (VP Sales)')"
    if ([string]::IsNullOrWhiteSpace($or)) { break }
    $OtherRegulars += $or
}

# ============================================================
#  CONFIRMATION
# ============================================================

Write-Host ""
Write-Host "  --- READY TO SET UP ---" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Name:         $FullName ($Title)" -ForegroundColor White
Write-Host "  Email:        $Email" -ForegroundColor White
Write-Host "  Reports to:   $ReportsTo" -ForegroundColor White
Write-Host "  Timezone:     $Timezone" -ForegroundColor White
Write-Host "  EA Directory: $EADir" -ForegroundColor White
if ($DirectReports.Count -gt 0) {
    Write-Host "  Direct reports: $($DirectReports -join ', ')" -ForegroundColor White
} else {
    Write-Host "  Direct reports: [none specified]" -ForegroundColor Gray
}
if ($OtherRegulars.Count -gt 0) {
    Write-Host "  Other 1:1s:   $($OtherRegulars -join ', ')" -ForegroundColor White
}
Write-Host ""

$Confirm = Read-Host "  Look good? (Y/n)"
if ($Confirm -eq 'n' -or $Confirm -eq 'N') {
    Write-Host "  Aborted. Run again when ready." -ForegroundColor Yellow
    exit 0
}

Write-Host ""

# ============================================================
#  PERSONALIZE CLAUDE.MD
# ============================================================

Write-Host "  > Personalizing CLAUDE.md..." -ForegroundColor Yellow

$ClaudeMdPath = Join-Path $EADir "CLAUDE.md"

if (-not $DryRun) {
    $content = Get-Content $ClaudeMdPath -Raw -Encoding UTF8

    $content = $content -replace '\[YOUR_NAME\]', $FullName
    $content = $content -replace '\[YOUR_TITLE\]', $Title
    $content = $content -replace '\[YOUR_EMAIL\]', $Email
    $content = $content -replace '\[YOUR_TIMEZONE\]', $Timezone

    # Build the direct reports line
    if ($DirectReports.Count -gt 0) {
        $drLine = "**Direct reports:** $($DirectReports -join ', ')"
        $content = $content -replace '(?m)^<!-- Add your direct reports here.*?-->[\r\n]*<!-- .*?-->', ''
        $content = $content -replace '\*\*Direct reports:\*\*', $drLine
    }

    # Build the other regulars line
    if ($OtherRegulars.Count -gt 0) {
        $orLine = "**Other regulars:** $($OtherRegulars -join ', ')"
        $content = $content -replace '(?m)^<!-- Add other people.*?-->', ''
        $content = $content -replace '\*\*Other regulars:\*\*', $orLine
    }

    Set-Content -Path $ClaudeMdPath -Value $content -Encoding UTF8 -NoNewline
} else {
    Write-Host "    [DRY RUN] Would replace placeholders in CLAUDE.md" -ForegroundColor DarkGray
}

Write-Host "  [OK] CLAUDE.md personalized" -ForegroundColor Green

# ============================================================
#  CREATE DIRECT REPORT FOLDERS
# ============================================================

$AllPeople = $DirectReports

# Extract just names from OtherRegulars (strip parenthetical role info)
foreach ($or in $OtherRegulars) {
    $cleanName = ($or -replace '\s*\(.*\)\s*', '').Trim()
    $AllPeople += $cleanName
}

if ($AllPeople.Count -gt 0) {
    Write-Host "  > Setting up team member folders..." -ForegroundColor Yellow

    foreach ($person in $AllPeople) {
        $folderName = ($person.Trim() -replace '\s+', '-').ToLower()
        $personDir = Join-Path $EADir "kb\team\$folderName"

        if ($DryRun) {
            Write-Host "    [DRY RUN] Would create: kb/team/$folderName/ (_profile.md, _topics.md, meetings/)" -ForegroundColor DarkGray
            continue
        }

        if (-not (Test-Path $personDir)) {
            New-Item -ItemType Directory -Path $personDir -Force | Out-Null
            New-Item -ItemType Directory -Path (Join-Path $personDir "meetings") -Force | Out-Null
        }

        # Determine role
        $isDirectReport = $DirectReports -contains $person
        $role = if ($isDirectReport) { "direct-report" } else { "colleague" }

        # Create _profile.md
        $profileContent = @"
---
type: person
role: $role
title: ""
reports_to: "$(if ($isDirectReport) { "[[${FullName}]]" } else { "" })"
---

# $person

## Working Style

## Current Focus

## Recent Activity

"@
        $profilePath = Join-Path $personDir "_profile.md"
        if (-not (Test-Path $profilePath)) {
            Set-Content -Path $profilePath -Value $profileContent -Encoding UTF8
        }

        # Create _topics.md
        $topicsContent = @"
# $person - 1:1 Topics

Discussion topics for next 1:1. Add items as they come up, remove after discussing.

## To Discuss

## Parked

"@
        $topicsPath = Join-Path $personDir "_topics.md"
        if (-not (Test-Path $topicsPath)) {
            Set-Content -Path $topicsPath -Value $topicsContent -Encoding UTF8
        }
    }

    Write-Host "  [OK] Created folders for: $($AllPeople -join ', ')" -ForegroundColor Green
}

# ============================================================
#  INITIAL COMMIT
# ============================================================

Write-Host "  > Committing personalized setup..." -ForegroundColor Yellow

if ($DryRun) {
    Write-Host "    [DRY RUN] Would commit and push personalized files" -ForegroundColor DarkGray
} else {
    & git add CLAUDE.md kb/ 2>$null
    $Today = Get-Date -Format "yyyy-MM-dd"
    & git commit -m "EA setup: personalized for $FullName ($Today)" 2>$null

    if ($LASTEXITCODE -eq 0) {
        & git push 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  [OK] Changes committed and pushed" -ForegroundColor Green
        } else {
            Write-Host "  [OK] Changes committed locally" -ForegroundColor Green
            Write-Host "  [WARN] Push failed - run 'git push' manually when ready" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  [OK] No changes to commit" -ForegroundColor Green
    }
}

# ============================================================
#  CREATE DESKTOP SHORTCUT
# ============================================================

Write-Host "  > Creating desktop shortcut..." -ForegroundColor Yellow

if ($DryRun) {
    Write-Host "    [DRY RUN] Would create 'My Assistant' shortcut on Desktop" -ForegroundColor DarkGray
} else {
    $DesktopPath = [Environment]::GetFolderPath("Desktop")
    $ShortcutPath = Join-Path $DesktopPath "My Assistant.lnk"
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = "cmd.exe"
    $Shortcut.Arguments = "/k cd /d `"$EADir`""
    $Shortcut.WorkingDirectory = "$EADir"
    $Shortcut.Description = "Open terminal in your EA assistant folder"
    $Shortcut.Save()
    Write-Host "  [OK] Desktop shortcut created: My Assistant" -ForegroundColor Green
}

# ============================================================
#  REMOVE SETUP SCRIPT (it's done its job)
# ============================================================

Write-Host "  > Cleaning up setup files..." -ForegroundColor Yellow

if ($DryRun) {
    Write-Host "    [DRY RUN] Would remove setup.ps1 and commit" -ForegroundColor DarkGray
} else {
    & git rm setup.ps1 2>$null
    & git commit -m "Remove setup script (setup complete)" 2>$null
    & git push 2>$null
}

Write-Host "  [OK] Setup script removed from repo" -ForegroundColor Green

# ============================================================
#  DONE!
# ============================================================

Write-Host ""
Write-Host ""
Write-Host "  +----------------------------------------------+" -ForegroundColor Green
Write-Host "  |                                              |" -ForegroundColor Green
Write-Host "  |       >>> I T ' S   A L I V E ! <<<          |" -ForegroundColor Yellow
Write-Host "  |                                              |" -ForegroundColor Green
Write-Host "  |      Your EA is ready.                       |" -ForegroundColor White
Write-Host "  |                                              |" -ForegroundColor Green
Write-Host "  +----------------------------------------------+" -ForegroundColor Green
Write-Host ""
Write-Host "  NEXT STEPS:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  1. Double-click the 'My Assistant' shortcut on your desktop" -ForegroundColor White
Write-Host "     Then type: claude" -ForegroundColor Gray
Write-Host ""
Write-Host "  2. Connect your Google Calendar and Gmail:" -ForegroundColor White
Write-Host "     Claude will prompt you to connect MCP on first use." -ForegroundColor Gray
Write-Host "     Just say: 'Connect my Google Calendar and Gmail'" -ForegroundColor Gray
Write-Host ""
Write-Host "  3. Start using your EA:" -ForegroundColor White
Write-Host "     /startup  - Session check (runs automatically)" -ForegroundColor Gray
Write-Host "     /morning  - Daily briefing" -ForegroundColor Gray
Write-Host "     /prep     - Meeting preparation" -ForegroundColor Gray
Write-Host "     /process  - Process inbox items" -ForegroundColor Gray
Write-Host ""
Write-Host "  Welcome to the future, $Name." -ForegroundColor Green
Write-Host ""
