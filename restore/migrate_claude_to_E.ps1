# migrate_claude_to_E.ps1
# Run ONCE after closing Claude Code.
# Moves .claude folder from C: to E: and creates a Junction.
# powershell -ExecutionPolicy Bypass -File "E:\Claude-Data\restore\migrate_claude_to_E.ps1"

Write-Host "=== .claude Migration: C -> E ===" -ForegroundColor Cyan
Write-Host "Make sure Claude Code is fully closed before continuing." -ForegroundColor Yellow
$confirm = Read-Host "Claude Code is closed? (y/n)"
if ($confirm -ne "y") {
    Write-Host "Cancelled." -ForegroundColor Red
    exit
}

$source = "C:\Users\bymyw\.claude"
$dest   = "E:\Claude-Data\.claude"
$backup = "C:\Users\bymyw\.claude_backup_before_migration"

# Step 1: Copy to E:
if (-not (Test-Path $dest)) {
    Write-Host "Copying .claude to E: ..." -ForegroundColor Cyan
    Copy-Item -Path $source -Destination $dest -Recurse -Force
    Write-Host "[OK] Copy complete" -ForegroundColor Green
} else {
    Write-Host "[SKIP] E:\Claude-Data\.claude already exists" -ForegroundColor Yellow
}

# Step 2: Rename original C: folder as backup
Write-Host "Renaming original C: folder as backup..." -ForegroundColor Cyan
if (Test-Path $backup) { Remove-Item $backup -Recurse -Force }
Rename-Item -Path $source -NewName ".claude_backup_before_migration"
Write-Host "[OK] Backup saved as .claude_backup_before_migration" -ForegroundColor Green

# Step 3: Create Junction C: -> E:
Write-Host "Creating Junction..." -ForegroundColor Cyan
New-Item -ItemType Junction -Path $source -Target $dest | Out-Null
Write-Host "[OK] Junction created: $source -> $dest" -ForegroundColor Green

# Step 4: Backup .claude.json
$jsonSrc = "C:\Users\bymyw\.claude.json"
$jsonDst = "E:\Claude-Data\.claude.json"
if (Test-Path $jsonSrc) {
    Copy-Item $jsonSrc $jsonDst -Force
    Write-Host "[OK] Backed up .claude.json to E:" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== Migration complete! You can reopen Claude Code ===" -ForegroundColor Cyan
Write-Host "C:\Users\bymyw\.claude now points to E:\Claude-Data\.claude"
Write-Host "After confirming everything works, delete: $backup"
