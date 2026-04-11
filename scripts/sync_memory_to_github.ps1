# sync_memory_to_github.ps1
# Auto-sync Claude memory files to GitHub every 30 minutes
# Task Scheduler triggers this; it copies local memory -> repo -> git push

$LogFile   = "E:\Claude-Data\scripts\sync_memory_log.txt"
$MemorySrc = "C:\Users\bymyw\.claude\projects\E--\memory"
$SkillsSrc = "C:\Users\bymyw\.claude\skills"
$RepoRoot  = "E:\Claude-Data\claude-workflows"
$MemoryDst = "$RepoRoot\memory"
$SkillsDst = "$RepoRoot\skills"

function Log($msg) {
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$ts  $msg" | Add-Content $LogFile
}

Log "=== sync_memory_to_github start ==="

# 1. Copy memory files into repo
New-Item -ItemType Directory -Path $MemoryDst -Force | Out-Null
Copy-Item -Path "$MemorySrc\*" -Destination $MemoryDst -Recurse -Force
Log "Copied memory -> $MemoryDst"

# 2. Copy skills into repo
New-Item -ItemType Directory -Path $SkillsDst -Force | Out-Null
Copy-Item -Path "$SkillsSrc\*" -Destination $SkillsDst -Recurse -Force
Log "Copied skills -> $SkillsDst"

# 3. Git operations inside repo
Set-Location $RepoRoot

$gitStatus = git status --porcelain 2>&1
if (-not $gitStatus) {
    Log "No changes detected, skipping commit."
    Log "=== done (no change) ==="
    exit 0
}

$changedCount = ($gitStatus | Measure-Object).Count
Log "Changed files: $changedCount"

git add memory/ skills/ 2>&1 | ForEach-Object { Log "git add: $_" }

$commitMsg = "auto-sync memory+skills $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git commit -m $commitMsg 2>&1 | ForEach-Object { Log "git commit: $_" }

git push origin main 2>&1 | ForEach-Object { Log "git push: $_" }

Log "=== done (pushed $changedCount changes) ==="
