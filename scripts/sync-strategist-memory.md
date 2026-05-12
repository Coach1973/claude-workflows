# 軍師大腦 Windows 記憶上雲腳本

> **建立**：2026-05-09 凌晨
> **目的**：把 C 槽 `.claude\projects\C--WINDOWS-system32\memory\` 與 `C--Users-bymyw\memory\` 的軍師記憶，同步進 E 槽 repo `windows-memory\` → 跟著現有 auto-sync 上 GitHub
> **執行頻率**：軍師對話收尾時手動跑一次；或併入 Windows 排程每小時跑一次

---

## 為什麼要做這件事

軍師的對話記憶（指揮所考古、handoff、feedback）目前**只存在 C 槽**。
C 槽風險：一鍵還原、系統壞掉 = 軍師全部失憶。
解法：把記憶複製進 E 槽 repo，跟著 Mac 那邊 auto-sync 一起 push 到 GitHub。

---

## 腳本本身

存於：`E:\Claude-Data\mac-openclaw-workflows\scripts\sync-strategist-memory.ps1`

```powershell
# sync-strategist-memory.ps1
# 把 C 槽軍師記憶同步到 E 槽 repo windows-memory\

$ErrorActionPreference = "Stop"

$RepoRoot = "E:\Claude-Data\mac-openclaw-workflows"
$Dest = Join-Path $RepoRoot "windows-memory"

# C 槽兩個可能的軍師記憶位置
$Sources = @(
    "C:\Users\bymyw\.claude\projects\C--WINDOWS-system32\memory",
    "C:\Users\bymyw\.claude\projects\C--Users-bymyw\memory"
)

# 確保目標資料夾存在
if (-not (Test-Path $Dest)) { New-Item -ItemType Directory -Path $Dest | Out-Null }

# 為每個來源建立子資料夾，避免檔名碰撞
foreach ($src in $Sources) {
    if (-not (Test-Path $src)) { continue }

    $tag = if ($src -match "system32") { "from_system32" } else { "from_bymyw" }
    $subDest = Join-Path $Dest $tag
    if (-not (Test-Path $subDest)) { New-Item -ItemType Directory -Path $subDest | Out-Null }

    # robocopy：MIR 鏡像、/XO 不覆蓋較新檔、/NFL/NDL/NJH/NJS 安靜模式
    robocopy $src $subDest /MIR /XO /NFL /NDL /NJH /NJS | Out-Null
}

# 寫一個 timestamp 標記檔，讓 git 看得到變動
$stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
"# 軍師記憶最後同步時間`n`n$stamp" | Out-File -FilePath (Join-Path $Dest "LAST_SYNC.md") -Encoding utf8

# 進 repo 跑 git
Set-Location $RepoRoot
git add windows-memory/ 2>&1 | Out-Null
git diff --staged --quiet
if ($LASTEXITCODE -eq 1) {
    git commit -m "sync: 軍師記憶同步 $stamp" 2>&1 | Out-Null
    Write-Host "已 commit。下次 auto-sync 會 push。"
} else {
    Write-Host "沒有變動，跳過。"
}
```

---

## 使用方式

### 方式一：手動跑（推薦剛上線時用這個）

```powershell
cd E:\Claude-Data\mac-openclaw-workflows
.\scripts\sync-strategist-memory.ps1
```

### 方式二：併入 Windows 排程（每小時自動）

待第一週驗證穩定後再開。指令備忘：

```powershell
$Action = New-ScheduledTaskAction -Execute "powershell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -File E:\Claude-Data\mac-openclaw-workflows\scripts\sync-strategist-memory.ps1"
$Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) `
    -RepetitionInterval (New-TimeSpan -Hours 1) -RepetitionDuration ([TimeSpan]::MaxValue)
Register-ScheduledTask -TaskName "StrategistMemorySync" -Action $Action -Trigger $Trigger
```

---

## 風險評估

| 風險 | 機率 | 緩解 |
|------|------|------|
| C 槽記憶有敏感資訊（API Key）被上 GitHub | 低 | 軍師寫記憶時就避免 paste key；MEMORY 目錄是 markdown、純文字，可預先掃 |
| robocopy 把舊版覆蓋新版 | 低 | `/XO` 旗標確保不覆蓋較新檔 |
| auto-sync 跟手動同步打架 | 低 | git commit 會自動處理；衝突很少發生 |

---

## 上線檢查清單

第一次跑之前確認：

- [ ] E 槽 repo 是 main 分支、git status 是乾淨的
- [ ] 跑一次 `.\scripts\sync-strategist-memory.ps1`
- [ ] git log 看到「sync: 軍師記憶同步 ...」commit
- [ ] 等下一輪 Mac auto-sync（30 分鐘內）
- [ ] 上 GitHub 確認 windows-memory/from_system32/ 出現

---

軍師大腦於 2026-05-09 凌晨交付
