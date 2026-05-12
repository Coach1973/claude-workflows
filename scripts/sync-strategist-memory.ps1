# sync-strategist-memory.ps1
# 把 C 槽軍師記憶同步到 E 槽 repo windows-memory\

$ErrorActionPreference = "Stop"

$RepoRoot = "E:\Claude-Data\mac-openclaw-workflows"
$Dest = Join-Path $RepoRoot "windows-memory"

$Sources = @(
    "C:\Users\bymyw\.claude\projects\C--WINDOWS-system32\memory",
    "C:\Users\bymyw\.claude\projects\C--Users-bymyw\memory"
)

if (-not (Test-Path $Dest)) { New-Item -ItemType Directory -Path $Dest | Out-Null }

foreach ($src in $Sources) {
    if (-not (Test-Path $src)) { continue }

    $tag = if ($src -match "system32") { "from_system32" } else { "from_bymyw" }
    $subDest = Join-Path $Dest $tag
    if (-not (Test-Path $subDest)) { New-Item -ItemType Directory -Path $subDest | Out-Null }

    robocopy $src $subDest /MIR /XO /NFL /NDL /NJH /NJS | Out-Null
}

$stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
"# 軍師記憶最後同步時間`n`n$stamp" | Out-File -FilePath (Join-Path $Dest "LAST_SYNC.md") -Encoding utf8

Set-Location $RepoRoot
git add windows-memory/ 2>&1 | Out-Null
git diff --staged --quiet
if ($LASTEXITCODE -eq 1) {
    git commit -m "sync: 軍師記憶同步 $stamp" 2>&1 | Out-Null
    Write-Host "已 commit。下次 auto-sync 會 push。"
} else {
    Write-Host "沒有變動，跳過。"
}
