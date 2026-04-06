# Claude Heartbeat Script v2.0
# Schedule: every 2 hours (via Windows Task Scheduler)
# Logic:
#   Daytime  07:00-23:59 -> run every 2 hours
#   Nighttime 00:00-06:59 -> run only if last run was 4+ hours ago

$LogFile    = "E:\Claude-Data\scripts\heartbeat_log.txt"
$TaskFile   = "E:\Claude-Data\scripts\pending_tasks.md"
$PromptFile = "E:\Claude-Data\scripts\heartbeat_prompt.txt"
$Timestamp  = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$NowHour    = (Get-Date).Hour

function Write-Log {
    param([string]$Message)
    $Line = "$Timestamp | $Message"
    $Line | Add-Content -Path $LogFile -Encoding UTF8
    Write-Host $Line
}

# ── Night throttle check (00:00-06:59) ──────────────────────────
if ($NowHour -ge 0 -and $NowHour -lt 7) {
    # Read last run timestamp from log
    $lastRunLine = $null
    if (Test-Path $LogFile) {
        $lastRunLine = Get-Content $LogFile -Encoding UTF8 |
                       Where-Object { $_ -match "=== Heartbeat START ===" } |
                       Select-Object -Last 1
    }
    if ($lastRunLine -and $lastRunLine -match "^(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})") {
        $lastRunTime = [datetime]::ParseExact($Matches[1], "yyyy-MM-dd HH:mm:ss", $null)
        $hoursSinceLast = ((Get-Date) - $lastRunTime).TotalHours
        if ($hoursSinceLast -lt 4) {
            # Silent skip during nighttime
            exit 0
        }
    }
}

Write-Log "=== Heartbeat START === (hour=$NowHour)"

# ── Validate files ───────────────────────────────────────────────
if (-not (Test-Path $TaskFile)) {
    Write-Log "ERROR: Task file not found: $TaskFile"
    exit 1
}
if (-not (Test-Path $PromptFile)) {
    Write-Log "ERROR: Prompt file not found: $PromptFile"
    exit 1
}

# ── Check Claude CLI ─────────────────────────────────────────────
try {
    $claudeVersion = & claude --version 2>&1
    Write-Log "Claude CLI: $claudeVersion"
} catch {
    Write-Log "ERROR: Claude CLI not found in PATH"
    exit 1
}

# ── Check for pending tasks ──────────────────────────────────────
$content = Get-Content $TaskFile -Raw -Encoding UTF8
if ($content -notmatch "\[ \]") {
    Write-Log "No pending TODO tasks. Nothing to do."
    Write-Log "=== Heartbeat END ==="
    "" | Add-Content -Path $LogFile -Encoding UTF8
    exit 0
}

Write-Log "Pending tasks found. Launching Claude..."

# ── Run Claude ───────────────────────────────────────────────────
$Prompt    = Get-Content $PromptFile -Raw -Encoding UTF8
$result    = & claude -p $Prompt 2>&1
$exitCode  = $LASTEXITCODE

if ($exitCode -eq 0) {
    Write-Log "Claude completed successfully."
} else {
    Write-Log "Claude exited with code $exitCode (rate-limited or error). Will retry next cycle."
    $errMsg = ($result | Select-Object -First 2) -join " | "
    Write-Log "Detail: $errMsg"
}

Write-Log "=== Heartbeat END ==="
"" | Add-Content -Path $LogFile -Encoding UTF8
