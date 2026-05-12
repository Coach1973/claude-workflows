---
name: .clawhub 指揮所雛形已存在 — 考古發現
description: mac-openclaw-workflows repo 在 5 月初已有跨機通訊雛形，明天的 SOP 要從考古開始而非從零寫
type: project
originSessionId: 3ef91e84-d39c-4b85-a6af-416598fead38
---
# .clawhub 指揮所雛形 — 考古發現

**事實：repo 裡已經有跨機通訊的雛形，不要從零設計指揮所 SOP。**

## 在 Lenovo E:\Claude-Data\mac-openclaw-workflows 發現的關鍵檔案

### 已存在的雛形元件（5/5 ~ 5/6 修改）
- `.clawhub/lock.json` — 「爪 hub」鎖檔，hub 概念已存在
- `scripts/queue_runner.sh` — 佇列執行器
- `scripts/relay_submit.py` — 訊息提交腳本
- `scripts/relay_poll.py` — 訊息輪詢腳本
- `scripts/relay_claude_task.sh` — Claude 任務轉發
- `scripts/relay_hello_test.sh` — 測試腳本
- `shared-context/RELAY_QUEUE.json` — 共享佇列檔
- `TASK_SHARED_QUEUE_RELAY.md` — 設計文件
- `terminal-notes/RELAY_SETUP.md` — 設定指南
- `terminal-notes/RELAY_USER_GUIDE.md` — 使用手冊
- `terminal-notes/relay_output_20260505.md` — 5/5 實際輸出記錄
- `TASK_QUEUE.txt` — 任務隊列檔

### 觀察到的訊號
- 5/6 之後**沒有新檔**，代表系統可能沒持續運轉
- 完整的設計文件 + 設定指南 + 使用手冊都有，代表當時做得還滿認真
- 但教練現在仍在當人肉搬運工 → **某個環節卡住，沒有走通**

## Why（為什麼這個發現重要）
2026-05-08 軍師原本要照交接檔寫「全新指揮所 SOP」。
開工前掃 repo，先用 OPE 鐵律「先搜再做」，發現雛形已存在。
若直接寫新 SOP，會跟教練既有資產打架，而且重複工作浪費 token。

## How to apply（明天的指揮所 SOP 工作怎麼做）
**改用兩階段策略，省一半 token：**

### A. 考古階段（約 2 元）
讀三份檔案，搞清楚 5 月初做到哪、為什麼停：
1. `terminal-notes/RELAY_USER_GUIDE.md`（使用手冊）
2. `terminal-notes/RELAY_SETUP.md`（設定指南）
3. `TASK_SHARED_QUEUE_RELAY.md`（設計文件）

### B. 補缺階段（約 4 元）
1. 在現有 relay 系統上補**軍師大腦**的位置（CLI_DIVISION.md 沒寫到 Windows）
2. 寫**「為什麼沒繼續用」根因分析**
3. 給出**復活方案**（不是新 SOP，是讓現有系統重新跑起來）
4. 寫好後給教練看，他校正後再細修

**鐵律：不要寫全新 SOP 跟現有 relay 打架。要當考古學家，不是建築師。**
