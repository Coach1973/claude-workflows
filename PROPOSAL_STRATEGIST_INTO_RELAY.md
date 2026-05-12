# 軍師大腦接入 relay 的三條路 — 給教練選

> **建立**：2026-05-09 凌晨（軍師大腦提案）
> **狀態**：等教練拍板
> **前提**：第 1 步驗證通過、relay 系統還活著之後再執行

---

## 痛點

現在 relay 系統只覆蓋「三隻小龍蝦 + Mac 終端機」，**Windows 軍師完全在 loop 之外**。
教練每次都得當人肉訊息搬運工——軍師寫完指令 → 教練手動複製 → 貼給 Mac。

要把軍師寫進 relay，需要一條從 Windows 到 Mac 的通道。

---

## 三條路比較

| 維度 | A) GitHub repo | B) SSH 直連 Mac | C) Telegram 中繼 |
|------|---------------|-----------------|------------------|
| 即時性 | 慢（30 秒～2 分鐘）| 即時（<1 秒）| 即時（<3 秒）|
| 設定複雜度 | 最低（已有 repo + auto-sync）| 中（要設 SSH key）| 中（要寫 bot handler）|
| 安全性 | 高（GitHub 認證）| 中（公網 SSH）| 中（Telegram 信任鏈）|
| 失敗恢復 | 好（git 記錄）| 差（連線斷了沒紀錄）| 中（Telegram 有歷史）|
| 跨機通用 | 好（任何電腦 git pull）| 差（只能對特定 IP）| 好（任何裝置）|
| 對 Mac 改動 | 加一個 watcher | 開 SSH 服務 | 改小龍蝦 handler |
| 月成本 | 0 | 0 | 0 |

---

## 詳解

### A) GitHub repo（推薦）

**運作方式**：
1. 軍師在 Windows 寫指令到 `E:\Claude-Data\mac-openclaw-workflows\WAR_ROOM_INBOX\<timestamp>.md`
2. git commit + push（用既有 auto-sync）
3. Mac 那邊每 30 秒 `git pull`
4. 偵測到 `WAR_ROOM_INBOX/` 有新檔 → 內容塞進 RELAY_QUEUE.json → relay_poll.py 自動處理
5. 處理結果寫回 `WAR_ROOM_OUTBOX/<timestamp>.md` → push 上來
6. 軍師 git pull 看回應

**優點**：完全沿用既有 auto-sync，**不需要新基礎建設**。SSH 沒開、Telegram 沒動。
**缺點**：30 秒～2 分鐘延遲（可調 cron 頻率到 10 秒，但 GitHub API 有 rate limit）

**新增檔案**：
- `WAR_ROOM_INBOX/` 資料夾
- `WAR_ROOM_OUTBOX/` 資料夾
- `scripts/war_room_watcher.py`（Mac 端，掃 inbox → 寫 RELAY_QUEUE）

### B) SSH 直連 Mac

**運作方式**：
1. 軍師在 Windows 直接 SSH 到 Mac
2. SSH command 把指令寫進 RELAY_QUEUE.json
3. relay_poll.py 處理
4. 軍師再 SSH 讀 relay_output

**優點**：即時、零延遲
**缺點**：
- 要在 Mac 開 SSH 服務（家裡 IP 不固定的話還要 DDNS）
- 攻擊面大（公網 SSH 是經典 brute force 目標）
- 出門換網路就連不上

### C) Telegram 中繼

**運作方式**：
1. 軍師在 Windows 用 Telegram Bot API 發訊息給 1號機學長
2. 學長收到後識別「來源：軍師」→ 寫進 RELAY_QUEUE
3. 處理完透過學長回報軍師

**優點**：手機也能用、免設新通道
**缺點**：
- 軍師要拿到 1號機 bot token（增加洩漏風險）
- 要修小龍蝦的訊息分類邏輯（增加學長的故障點）
- 訊息一多就跟教練自己的對話混在一起

---

## 軍師建議

**走 A**。理由：

1. **OPE 鐵律**：既有 auto-sync 已驗證可用，不重新發明輪子
2. **資料留痕**：每次溝通都有 git commit，事後查證、debug 都方便
3. **跨機通用**：教練哪天用宏碁、用筆電都一樣能用——這正是教練前面講的「放雲端最穩」
4. **可逆**：如果 A 證明太慢，再升級到 B 或 C 不衝突

**A 的最小可行版本**：今天先做「軍師→Mac」單向，能跑通就先跑。雙向（Mac→軍師回報）等下一輪再加。

---

## 等教練決定的事

1. 走 A、B、C 哪一條？
2. 如果走 A，輪詢頻率設多少（30 秒 / 60 秒 / 5 分鐘）？
3. inbox/outbox 命名要不要中文（`軍師收件夾` vs `WAR_ROOM_INBOX`）？

教練醒來看到提案後說一聲方向，軍師就接著寫實作指令給 Mac 終端機。

---

軍師大腦於 2026-05-09 凌晨提案
