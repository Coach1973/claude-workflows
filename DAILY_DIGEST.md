# DAILY_DIGEST.md — 每日進度摘要

> **用途**：每次 Context Overflow 重啟後，小龍蝦第一件事就是讀這個檔案，立刻回到狀態
> **更新頻率**：每日結束前或階段任務完成後
> **大小上限**：30KB
> **重啟讀取**：✅ 必讀

---

## 📅 2026-04-20

### 🎯 今日重點任務

- [ ] 海餅乾19週年慶（5月14日）行銷規劃
- [ ] 6場新書發表會（5月份）進度追蹤

### ✅ 今日完成

- [x] NotebookLM 雙向複製（21個筆記本）— ✅ 完成（教練確認 2026-04-20 16:50）
- [x] HEARTBEAT.md 清除過時 Gemini 50KB 警告，更新三層架構說明
- [x] 90分鐘心跳報告（ai.openclaw.heartbeat）已從系統根除

### 🔧 系統異動

- WISDOM_CORES.md 第34條更新：50KB限制改為三層架構（HEARTBEAT/DAILY_DIGEST/memory）
- Primary 模型已切換為 MiniMax M2.7
- 終端機2號（聯想 Windows）已確認路徑：E:\Claude-Data\mac-openclaw-workflows\

### 📌 VPS 小龍蝦智慧庫狀態（2026-04-20 更新）
- `seabiscuit_case_studies.md`：**✅ 已完成**（4864 bytes）
- `seabiscuit_distilled_knowledge.md`：⚠️ 空殼（無實質內容）
- 結論：不用再處理，內容已就緒

---

### 📝 教練狀態

教練今日主要討論了 Context Overflow 問題的根因與解決方案。確認了 VPS 版小龍蝦的智慧庫內容已完成，無需進一步處理。

---

## 📅 2026-04-21

### ✅ 今日完成

- [x] **Tavily 搜尋 API 金鑰接通**（tvly-dev-3hp3Hz...）— API 測試回傳正常，0.74秒
- [x] **2號機（佩佩）網路搜尋開通**
  - `~/.openclaw-peipei/openclaw.json`：tavily enabled: true、duckduckgo enabled: true、xai disabled
  - `~/.openclaw-peipei/agents/main/agent/auth-profiles.json`：加入 tavily:default 金鑰
  - Gateway 已重啟（PID 6199）
- [x] **3號機（孔大哥）網路搜尋開通**
  - `~/.openclaw-kong/openclaw.json`：tavily enabled: true、duckduckgo enabled: true、xai disabled
  - `~/.openclaw-kong/agents/main/agent/auth-profiles.json`：加入 tavily:default 金鑰
- [x] **3號機每次重啟需重新配對問題修正**
  - `~/.openclaw-kong/identity/device-auth.json`：scopes 加入 `operator.approvals`
- [x] **1號機（主機）xAI 停用**（team_blocked:true 導致 403）、DuckDuckGo 啟用

### 🔧 系統異動

- 三台 Mac mini 龍蝦（1/2/3號機）全部在**同一台 Mac mini** 上，不同 `~/.openclaw-*` 目錄
- 搜尋架構確認：瀏覽器插件（Browser Control）= 導向特定網址；Tavily = 關鍵字搜尋 API
- 目前行為：2/3號機模型傾向用瀏覽器控制搜尋（非 Tavily），因為兩者同時啟用，AI 自行選擇
- VPS 小龍蝦：DuckDuckGo 正常運作，無瀏覽器插件，不需額外調整
- MiniMax 免費額度（1,500次呼叫/天）對2/3號機用量足夠

### ✅ 今日完成（下午段）

- [x] **共享智慧同步**：SOUL.md、AGENTS.md、WISDOM_CORES.md、教練碎碎念等核心檔案同步到 2/3 號機
- [x] **同步腳本建立**：`~/.openclaw/workspace/scripts/sync-shared-wisdom.sh`，下次說「同步助教智慧」即可執行
- [x] **MiniMax 升級 $200/年**：教練已完成升級，4,500次/5小時，新增圖像/語音功能
- [x] **VPS 圖像/語音能力調查完成**

### ⚠️ 待處理

- [ ] **VPS 啟用圖像/語音功能**（半完成）
  - 根因：VPS 用 `minimax`（直接API），Mac 用 `minimax-portal`（OAuth）
  - 解法：更新 VPS `/home/node/.openclaw/agents/main/agent/auth-profiles.json` 加入 `minimax-portal` 項目
  - 並將 VPS `openclaw.json` 的 model 改為 `minimax-portal/MiniMax-M2.7`
  - VPS API Key：`sk-cp-0_iW72rvuoBmDucQXmRaSAUmcrjXTzZCpIxQt7xgKX_ImdeMkhGmgEV9QBzMNwH87jP-VLIXDNC8VqdgJmntnj5M9gJfTJFiveu9fWuXyQHnW9Z8EQnvlC8`
- [ ] 海餅乾19週年慶（5月14日）行銷規劃
- [ ] 6場新書發表會（5月份）進度追蹤
- [ ] YouTube 頻道 handle 待確認：`@greentrainTW`（綠色火車）、`@aaron-1215` 是否正確

### 📝 教練狀態

教練今日關注額度消耗問題：Claude.ai Pro（$20/月）已用60%、API 額度剩約$30。
計畫改用終端機 Claude Code（API 計費）分擔聊天額度壓力。

---
