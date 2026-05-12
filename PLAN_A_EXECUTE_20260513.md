# PLAN_A_EXECUTE_20260513.md — 新對話接手執行指令

**給新對話的話**：你是接任軍師（同 Opus 4.7，只是上一輪 /clear 了）。今天是 2026-05-13，額度剩 9.2 元，**省著用**。照下方 5 步做，**不要再分析不要再問、直接動手**。

---

## 你必須先知道的 5 件事（30 秒讀完）

1. **原廠 Opus 4.7 帳號 5/14 到期**，教練已在 Windows 和 Mac 都裝好 CC Switch + 兩家中轉商（EchoTokens、Synterolink）
2. **Windows 有兩個 Claude project 目錄**，**都有記憶**：
   - `C:\Users\bymyw\.claude\projects\C--WINDOWS-system32\memory\`（上一輪軍師今天新寫的 5 份 + 重寫 MEMORY.md）
   - `C:\Users\bymyw\.claude\projects\C--Users-bymyw\memory\`（5/12 軍師寫的 15 份，含完整 CC Switch 設定）
3. **repo 在** `E:\Claude-Data\mac-openclaw-workflows\`，今天寫了 6 份新檔但**還沒 push**
4. **目前 staging 有 16 份待 commit+push**（5/9 的歷史債）
5. **戰略決策**：Mac 為軍師主站、Windows 退居備援（見 repo 端 `MAC_MIGRATION_PLAN.md`）

---

## Plan A 五步驟（照順序執行）

### Step 1：push 今天所有 repo 產出

```powershell
cd E:\Claude-Data\mac-openclaw-workflows
git fetch --all
git pull --rebase
```

**如果 pull 有衝突停手問教練，不要 force**。

然後分兩個 commit：

```powershell
# Commit 1：清 5/9 staged 歷史債
git status --short
git commit -m "chore(memory): 清歷史債 — 5/8-5/9 指揮所考古 staged 產出"

# Commit 2：今天（5/13）交接與 Mac 遷址產出
git add OPUS_HANDOFF_20260513.md CLAUDE_CLI_TASK_OPUS_HANDOFF_20260513.md MAC_MIGRATION_PLAN.md PUSH_STEPS_20260513.md SESSION_LOG_20260513.md MAC_HANDOFF_TEST_20260513.md PLAN_A_EXECUTE_20260513.md
git status --short
git commit -m "docs(handoff): Opus 4.7 軍師 5/14 下線交接 + Mac 遷址計畫"

git push
git log --oneline -5
```

---

### Step 2：改造 sync-strategist-memory.ps1

原腳本位置：`E:\Claude-Data\mac-openclaw-workflows\scripts\sync-strategist-memory.ps1`

**要做兩處修改**：
1. **最前面加 `git pull --rebase`**（新鐵律：上雲前先讀雲）
2. **最後加 `git push`**（commit 完要真的推上去）

用 Edit 工具改，不要 Write 整份蓋掉。原腳本已正確處理兩個 project 來源（`from_system32` + `from_bymyw`），邏輯不動。

**參考的最終結構**（偽碼）：

```powershell
Set-Location E:\Claude-Data\mac-openclaw-workflows
git pull --rebase  # 新增：上雲前先讀雲

# ...原本的 robocopy 鏡像邏輯不動...

git add windows-memory/
git diff --staged --quiet
if ($LASTEXITCODE -eq 1) {
    git commit -m "sync: 軍師記憶同步 $stamp"
    git push  # 新增
    Write-Host "已 commit 並 push"
} else {
    Write-Host "沒有變動，跳過"
}
```

---

### Step 3：手動跑一次同步驗證

```powershell
& "E:\Claude-Data\mac-openclaw-workflows\scripts\sync-strategist-memory.ps1"
```

**預期結果**：
- `E:\Claude-Data\mac-openclaw-workflows\windows-memory\from_system32\` 會有 14 份檔（含今天新寫的 5 份 + 重寫的 MEMORY.md）
- `E:\Claude-Data\mac-openclaw-workflows\windows-memory\from_bymyw\` 會**首次被建立**，有 15 份檔（5/12 軍師的全套）
- 自動 commit + push 完成

跑完用 `git log --oneline -3` 確認 push 成功。

---

### Step 4：設 Windows 工作排程器每小時自動跑

用 `schtasks.exe` 建立排程：

```powershell
$Action = '-NoProfile -ExecutionPolicy Bypass -File "E:\Claude-Data\mac-openclaw-workflows\scripts\sync-strategist-memory.ps1"'

schtasks /Create `
  /TN "SyncStrategistMemory" `
  /TR "powershell.exe $Action" `
  /SC HOURLY `
  /F
```

驗證：`schtasks /Query /TN "SyncStrategistMemory"`

---

### Step 5：向教練報告並等候測試指令

跑完 1~4 後，用以下格式向教練報告：

```
教練，Plan A 執行完成：
□ Step 1: push 成功，最新 commit hash: XXXXXX
□ Step 2: sync 腳本已加 git pull + git push
□ Step 3: 手動同步成功，from_bymyw 首次建立含 15 份檔
□ Step 4: 排程器已設每小時一次

剩餘額度：X.X 元。下一步請問要跑 MAC_HANDOFF_TEST_20260513.md 的測試 A 或 B 嗎？
```

---

## ⚠️ 別踩的坑（上一輪軍師踩過的）

1. **不要重複造輪**：關於 CC Switch 的記憶，5/12 軍師已經寫得很齊（在 `C--Users-bymyw\memory\` 裡），不要再寫新的覆蓋
2. **robocopy /MIR 是鏡像**：它會讓目的地等於來源，包含刪除目的地多出的檔。原本擔心有風險，但實際上是**來源→目的地單向鏡像**，只要來源完整就安全
3. **不要動這三份**（5/12 軍師的，別亂寫）：
   - `handoff_synterolink_dual_models_20260512.md`
   - `project_synterolink_success_202605.md`
   - `reference_synterolink_setup.md`
4. **預設用 Sonnet 省錢**：5/12 軍師有記「Opus 在 Synterolink 一輪燒 10 美金」，見 `feedback_opus_costly_default_sonnet.md`

---

## 所有關鍵路徑速查

| 項目 | 路徑 |
|------|------|
| repo 根 | `E:\Claude-Data\mac-openclaw-workflows\` |
| Windows 記憶（新） | `C:\Users\bymyw\.claude\projects\C--WINDOWS-system32\memory\` |
| Windows 記憶（5/12） | `C:\Users\bymyw\.claude\projects\C--Users-bymyw\memory\` |
| 同步腳本 | `E:\Claude-Data\mac-openclaw-workflows\scripts\sync-strategist-memory.ps1` |
| 今日交接主檔 | `E:\Claude-Data\mac-openclaw-workflows\OPUS_HANDOFF_20260513.md` |
| Mac 遷址計畫 | `E:\Claude-Data\mac-openclaw-workflows\MAC_MIGRATION_PLAN.md` |
| 測試方案 | `E:\Claude-Data\mac-openclaw-workflows\MAC_HANDOFF_TEST_20260513.md` |

---

**一句話**：你的任務不是想，是做。五步做完報告就行。
