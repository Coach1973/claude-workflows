# restore_junctions.ps1
# Run this after a C: system restore to rebuild all Junctions.
# powershell -ExecutionPolicy Bypass -File "E:\Claude-Data\restore\restore_junctions.ps1"

Write-Host "=== Claude Junction Restore Script ===" -ForegroundColor Cyan
Write-Host ""

# 1. Rebuild .claude Junction (C: -> E:)
$claudeSource = "E:\Claude-Data\.claude"
$claudeTarget = "C:\Users\bymyw\.claude"

if (Test-Path $claudeSource) {
    if (Test-Path $claudeTarget) {
        $item = Get-Item $claudeTarget -Force
        if ($item.LinkType -eq "Junction") {
            Write-Host "[OK] Junction already exists, no action needed" -ForegroundColor Green
        } else {
            Write-Host "[WARN] $claudeTarget is a real folder - delete it manually then re-run" -ForegroundColor Yellow
        }
    } else {
        New-Item -ItemType Junction -Path $claudeTarget -Target $claudeSource | Out-Null
        Write-Host "[OK] Junction rebuilt: $claudeTarget -> $claudeSource" -ForegroundColor Green
    }
} else {
    Write-Host "[ERROR] Source not found: $claudeSource" -ForegroundColor Red
}

# 2. Restore .claude.json
$jsonSource = "E:\Claude-Data\.claude.json"
$jsonTarget = "C:\Users\bymyw\.claude.json"

if (Test-Path $jsonSource) {
    Copy-Item $jsonSource $jsonTarget -Force
    Write-Host "[OK] Restored .claude.json" -ForegroundColor Green
} else {
    Write-Host "[SKIP] $jsonSource not found (not yet backed up)" -ForegroundColor Gray
}

# 3. Rebuild Task Scheduler tasks
Write-Host ""
Write-Host "Rebuilding scheduled tasks..." -ForegroundColor Cyan

schtasks /query /tn "ClaudeHeartbeat" 2>$null
if ($LASTEXITCODE -ne 0) {
    schtasks /create /tn "ClaudeHeartbeat" /tr "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File E:\Claude-Data\scripts\claude_heartbeat.ps1" /sc hourly /mo 2 /st 00:00 /f | Out-Null
    Write-Host "[OK] ClaudeHeartbeat rebuilt (every 2 hours)" -ForegroundColor Green
} else {
    Write-Host "[SKIP] ClaudeHeartbeat already exists" -ForegroundColor Yellow
}

schtasks /query /tn "YouTubeDailyDigest" 2>$null
if ($LASTEXITCODE -ne 0) {
    schtasks /create /tn "YouTubeDailyDigest" /tr "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File E:\Claude-Data\.claude\scheduled-tasks\youtube-daily-digest\fetch_rss.ps1" /sc daily /st 08:00 /f | Out-Null
    Write-Host "[OK] YouTubeDailyDigest rebuilt (daily 08:00)" -ForegroundColor Green
} else {
    Write-Host "[SKIP] YouTubeDailyDigest already exists" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Done! Please restart Claude Code ===" -ForegroundColor Cyan
