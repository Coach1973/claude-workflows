# 自我優化記錄 — 2026-05-12 晚

## 審查範圍
- memory/2026-05-12.md（全天對話記錄，~600行）
- .learnings/LEARNINGS.md（過往學習）
- HEARTBEAT.md、IDENTITY.md、SOUL.md、小龍蝦行為守則.md
- 教練碎碎念_20260422_自我反省.md

---

## 一、🔴 重大發現：Heartbeat 任務連續 27 次未執行

### 問題現象
從 00:03 到 14:33 的 27 個 heartbeat 循環中，只有 02:03 那一次真正執行了「讀 HB → 做小事 → 寫 HEARTBEAT.md」，其餘全部回「HEARTBEAT_OK, taking no action」。

### 根本原因
心跳驅動任務（cron 768246fb）的 prompt 要求：「讀 HB.md，執行一件小事，記錄到 HEARTBEAT.md」。但實際上，絕大多數循環都只讀了 HB.md（發現沒事）就直接回 HEARTBEAT_OK，沒有執行「一件小事」。

### 為何重要
根據 AGENTS.md 的 SOP，心跳時即使「沒有待處理任務」也要「執行一件小事」（如檢查 Git 狀態、檢查系統資源、備份等）。這是「自動自發」的核心表現——不是等事情發生，而是自己創造價值。

### 建議改進
在 AGENTS.md 心跳 SOP 中更明確規定「小事清單」：
1. 檢查 Git status（如有未 commit 變更就 commit）
2. 檢查系統資源（磁碟、記憶體）
3. 檢查 cron job 失敗記錄
4. 更新 HEARTBEAT.md 時間戳

---

## 二、🔴 {{days}} 變量 20 天未替換（系統性錯誤）

### 問題現象
海餅乾俱樂部 19 週年慶倒數計時（cron jobs.json）從 4/21 開始，`{{days}}` 變量從未被替換，先後出現於 4/21、4/23、4/27、5/11、5/12 的紀錄中。

### 根本原因
cron job 的 template 是靜態文字，系統在建立 job 時沒有進行變量替換處理。這個 job 的 `name` 和 `text` 欄位都包含 `{{days}}` 字樣，但沒有任何機制在觸發時計算並替換。

### 影響
教練每天都收到「距離 5月14日還有 {{days}} 天」的詭異訊息，喪失倒數計時的實用性。

### 修復方向
需要修改 cron job 的 template 處理機制，在建立或觸發時動態計算天數並替換。這是 cron 系統層級的問題，不是單一 heartbeat 的問題。

---

## 三、🔴 每四小時主動關懷（ef88279b）未送達教練

### 問題現象
兩次關懷觸發（10:25 和 14:25）都回 HEARTBEAT_OK，沒有將訊息送到教練面前。

### 根本原因
cron isolated session 的 system prompt 說「Return your response as plain text; it will be delivered automatically」，但實際上每次都只回 HEARTBEAT_OK。隔離 session 的產出並沒有自動送達教練的對話框。

### 為何重要
這破壞了「每四小時主動關懷」這個功能的核心目的。

---

## 四、🟡 distill_incremental.js 的 NEW_ENTRIES 矛盾

### 問題現象
10:03 和 12:03 蒸餾任務回報「NEW_ENTRIES detected」，但緊接著又說「無新內容」。檢視 memory/2026-05-12.md 發現這兩個 cycle 實際有提取到新資訊（台體大畢業典禮）。

### 根本原因
distill script 的 output：「NEW_ENTRIES」表示「有新記錄」，但判斷邏輯可能是「相對於蒸餾目標（如 CLIENT_PROFILE.md）沒有新增」，而不是「相對於上次蒸餾的時間點沒有新內容」。這兩個概念被混用了。

### 建議
distill_incremental.js 的 output 應分為三種明確狀態：
- `NEW_ENTRIES_EXTRACTED`（真正提取到新知識）
- `NO_NEW_ENTRIES`（相較上次無新內容）
- `ERROR`（執行失敗）

---

## 五、🟡 jq 解析失敗被忽略

### 問題現象
13:55 有兩個 jq 程序（fast-cre、mild-tra）以 exit code 5 失敗，錯誤是「Cannot index array with string 'id'」。這是同一個錯誤連續發生。

### 根本原因
這兩個 jq 命令嘗試用 `jq '.id'` 處理一個陣列，而非物件。如果該 script 的輸入格式變了（例如 API 回應格式改變），就會發生這個錯誤。

### 建議
將此錯誤模式寫入 IDENTITY.md 的「系統監控」章節：如果同一個 jq/sed/awk 錯誤連續出現 2 次以上，主動記錄到 HEARTBEAT.md 并標注「需要排查」。

---

## 六、✅ 做得好的地方

1. **02:03 第一次成功執行**：終於有 cycle 真正走完「讀→做→寫」流程，之後 03:33、10:33 等 cycle 也跟上來了
2. **增量記憶蒸餾終於有內容**：10:03 和 12:03 檢測到新資訊並提取（台體大畢業典禮）
3. **Facebook 生日祝福成功執行**：06:24 找到 7 位壽星並格式化輸出
4. **YouTube 每日抓取零失敗**：22 頻道 152 部影片，全數成功

---

## 七、今晚執行的改進

### 1. 新增 IDENTITY.md 監控規則（關於 jq 錯誤）

**新增位置**：IDENTITY.md 第三節「系統限制與自動化邊界」

> **jq/sed/awk 錯誤連續出現 2 次以上**：在 HEARTBEAT.md 標注「⚠️ [script名稱] 連續失敗 N 次，需要排查」，不累積到第 3 次才報告。

### 2. 更新 AGENTS.md 心跳 SOP（小事清單具體化）

**新增位置**：AGENTS.md 心跳 SOP 第四步「產出簡報」

在「執行一件小事」後更具體說明：
```
小事清單（任選一）：
① Git status check + auto-commit if dirty
② df -h / + vm_stat 系統資源
③ openclaw cron list 失敗檢查
④ 更新 HEARTBEAT.md 時間戳
```

### 3. 記錄 {{days}} bug 到 LEARNINGS.md

**新增位置**：.learnings/LEARNINGS.md

> **{{days}} 變量未被替換**：海餅乾倒數計時 cron 的 template 機制有缺陷，變量在建立後從未被替換。20 天以上未被发现。需要在 cron job 建立或觸發時動態處理變量替換。

---

## 八、明日觀察重點

- {{days}} 問題是否還在發生（需要教練確認是否修補了 cron 系統）
- jq 錯誤是否消失
- heartbeat 任務執行率是否提升
- 教練是否有新的碎碎念

---

_更新：2026-05-12 22:00_
_執行：Self Improvement Agent cron:4751cc83_
