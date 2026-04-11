# sync-memory.ps1 — 三臺電腦記憶同步腳本（Windows 版）
# 用法（PowerShell）：
#   .\sync-memory.ps1 pull    ← 從 GitHub 拉最新記憶
#   .\sync-memory.ps1 push    ← 推送新記憶到 GitHub
#   .\sync-memory.ps1 status  ← 查看同步狀態

param(
    [string]$Action = "status"
)

# ─── 機器自動識別 ───────────────────────────────────────────
$MachineName = $env:COMPUTERNAME
$HasEDrive   = Test-Path "E:\"
$IsLenovo    = $HasEDrive  # 只有聯想有 E 槽

# ─── 路徑設定 ──────────────────────────────────────────────
$GithubRepo = "Coach1973/mac-openclaw-workflows"
$RepoDir    = "$env:USERPROFILE\Documents\mac-openclaw-workflows"

# 自動尋找 Claude 記憶資料夾（相容不同機器的 project 路徑）
$MemoryDir = Get-ChildItem "$env:USERPROFILE\.claude\projects" -Recurse -Filter "MEMORY.md" -ErrorAction SilentlyContinue |
             Select-Object -First 1 |
             ForEach-Object { $_.DirectoryName }

if (-not $MemoryDir) {
    Write-Host "❌ 找不到 Claude 記憶資料夾，請確認 Claude Code 已啟動過"
    exit 1
}

# Lenovo 專屬備份路徑
$EBackupDir = "E:\Claude-Data\memory-backup"

Write-Host "🖥️  機器：$MachineName | E槽：$($HasEDrive ? '有（Lenovo模式）' : '無')"
Write-Host "📂 記憶路徑：$MemoryDir"

# ─── 確保 repo 存在 ────────────────────────────────────────
if (-not (Test-Path "$RepoDir\.git")) {
    Write-Host "📦 首次初始化：clone GitHub repo..."
    git clone "https://github.com/$GithubRepo.git" $RepoDir
}

# ─── 執行動作 ──────────────────────────────────────────────
switch ($Action.ToLower()) {

    "pull" {
        Write-Host "`n⬇️  從 GitHub 拉取最新記憶..."
        Set-Location $RepoDir
        git pull origin main

        # 複製 .md 到 Claude 記憶資料夾
        $Updated = 0
        Get-ChildItem "$RepoDir\*.md" | ForEach-Object {
            $dest = Join-Path $MemoryDir $_.Name
            if (-not (Test-Path $dest) -or (Get-FileHash $_.FullName).Hash -ne (Get-FileHash $dest).Hash) {
                Copy-Item $_.FullName $dest -Force
                Write-Host "  ✅ 更新：$($_.Name)"
                $Updated++
            }
        }

        if ($Updated -eq 0) {
            Write-Host "  ✅ 已是最新，無需更新"
        } else {
            Write-Host "  📚 共更新 $Updated 個記憶檔案"
        }

        # Lenovo 專屬：同時備份到 E 槽
        if ($IsLenovo) {
            if (-not (Test-Path $EBackupDir)) { New-Item -ItemType Directory -Path $EBackupDir -Force | Out-Null }
            Copy-Item "$RepoDir\*.md" $EBackupDir -Force
            Write-Host "  💾 Lenovo E槽備份完成：$EBackupDir"
        }
    }

    "push" {
        Write-Host "`n⬆️  推送記憶到 GitHub..."

        # 複製本地記憶到 repo
        Copy-Item "$MemoryDir\*.md" $RepoDir -Force

        Set-Location $RepoDir
        git add "*.md"

        $Status = git status --porcelain
        if (-not $Status) {
            Write-Host "  ✅ 無新變更，GitHub 已是最新"
        } else {
            $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
            git commit -m "Memory sync from $MachineName @ $Timestamp`n`nCo-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
            git push origin main
            Write-Host "  ✅ 推送成功"
        }

        # Lenovo 專屬：同時備份到 E 槽
        if ($IsLenovo) {
            if (-not (Test-Path $EBackupDir)) { New-Item -ItemType Directory -Path $EBackupDir -Force | Out-Null }
            Copy-Item "$MemoryDir\*.md" $EBackupDir -Force
            Write-Host "  💾 Lenovo E槽備份完成：$EBackupDir"
        }
    }

    "status" {
        Write-Host "`n📊 記憶同步狀態"
        Set-Location $RepoDir
        git fetch origin main --quiet 2>$null
        $Local  = git rev-parse HEAD 2>$null
        $Remote = git rev-parse origin/main 2>$null
        if ($Local -eq $Remote) {
            Write-Host "  狀態：✅ 已同步（最新）"
        } else {
            Write-Host "  狀態：⚠️  有差異，請執行 pull 或 push"
            git log --oneline HEAD..origin/main 2>$null | Select-Object -First 5
        }
    }

    default {
        Write-Host "用法：.\sync-memory.ps1 [pull|push|status]"
    }
}
