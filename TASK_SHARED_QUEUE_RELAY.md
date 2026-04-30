# TASK_SHARED_QUEUE_RELAY.md — 三機共享訊息佇列 Relay 系統

> **建立時間**：2026-04-25
> **執行者**：Claude Code（程式實作）
> **目標**：讓 1/2/3號機在同一個 Telegram 群組裡能互相觸發、有序發言

---

## 🔴 問題本質

三個 bot 是三個獨立的 OpenClaw gateway 程序，運行在不同 port：
- **1號機**：port 18789，`~/.openclaw/`，bot @openclaw_macbook4_bot
- **2號機（學弟）**：port 18790，`~/.openclaw-kong/`，bot @CoachWu_openclaw_bot（孔大哥）
- **3號機（學妹）**：port 18793，`~/.openclaw-peipei/`，bot @coachwu_lenovo_bot（佩佩老師）

**核心限制**：Telegram Bot API 不會把 bot 發的訊息投遞給其他 bot。

**現有資源**：
- `multi-agent-chat` 插件已啟用（每個 bot 的 extensions 目錄都有）
- 共享資料夾：`/Users/bymyway/.openclaw/workspace/shared-context/`
- 所有 bot 都在同一臺 Mac mini，檔案系統完全互通

---

## 🎯 目標行為

1. **教練發言**：任何 bot 收到教練的訊息，可以呼叫其他 bot 處理
2. **任務委派**：學長（1號機）可以委派任務給學弟或學妹
3. **有感知的回應**：被委派的 bot 回覆時，其他 bot 能感知到這是一次協作回應（不是普通回覆）
4. **有序發言**：透過 shared-queue 的任務排程，確保同一時間只有一個 bot 在執行任務

---

## 📋 共用訊息佇列設計

### 共享檔案位置
```
/Users/bymyway/.openclaw/workspace/shared-context/RELAY_QUEUE.json
```

### 佇列格式（JSON）

```json
{
  "tasks": [
    {
      "id": "uuid-v4",
      "from": "1",
      "to": "2",
      "content": "學弟，請說明今天的工作進度",
      "status": "pending",
      "createdAt": "2026-04-25T16:30:00.000Z",
      "createdBy": "教練"
    }
  ],
  "status": {
    "1": { "lastTaskId": null, "lastAt": null },
    "2": { "lastTaskId": null, "lastAt": null },
    "3": { "lastTaskId": null, "lastAt": null }
  }
}
```

### 三個 Bot 的職責

| Bot | 角色 | 負責工作 |
|-----|------|---------|
| 1號機（學長） | 統籌 | 接收教練指令，決定委派給誰，寫入佇列 |
| 2號機（學弟） | 執行者 | 每 10 秒輪詢佇列，發現 to="2" 的任務就執行並回覆群組 |
| 3號機（學妹） | 執行者 | 每 10 秒輪詢佇列，發現 to="3" 的任務就執行並回覆群組 |

### 任務生命週期

1. **建立（Create）**：教練向任何 bot 發言 → 該 bot 評估是否需要委派 → 寫入 RELAY_QUEUE.json
2. **輪詢（Poll）**：學弟/學妹每 10 秒檢查佇列，發現 status=pending 且 to=自己的任務
3. **鎖定（Lock）**：開始處理前，先把該任務的 status 改為 processing（防止重複處理）
4. **執行（Execute）**：在群組發送回覆（透過 multi-agent-chat 插件）
5. **完成（Complete）**：把 status 改為 completed，並更新 status 區塊的 lastTaskId

---

## 🔧 實作步驟

### Step 1：在 shared-context 建立 RELAY_QUEUE.json 初始檔案

```json
{
  "tasks": [],
  "status": {
    "1": { "lastTaskId": null, "lastAt": null },
    "2": { "lastTaskId": null, "lastAt": null },
    "3": { "lastTaskId": null, "lastAt": null }
  }
}
```

### Step 2：寫一個共用的輪詢腳本

建立 `/Users/bymyway/.openclaw/workspace/scripts/relay_poll.sh`：

```bash
#!/bin/bash
# relay_poll.sh — 檢查並處理 RELAY_QUEUE 中的任務
# 用法: ./relay_poll.sh <bot_number>
# 例如: ./relay_poll.sh 2

BOT_NUM=$1
QUEUE_FILE="/Users/bymyway/.openclaw/workspace/shared-context/RELAY_QUEUE.json"
BOT_TOKEN_1="8758843664:AAE4W-hGh2mPxNt89b2donZ0Q--YZ9uwdsA"
BOT_TOKEN_2="8555923043:AAEOoI2ZWIyKW69Z32IMaM0sYajG6D9HkeQ"
BOT_TOKEN_3="8705446823:AAHDA0wvjdxXsaB3yX3PRiEkG_wO2N-BWa8"
GROUP_ID="-1003877502911"

BOT_TOKEN="BOT_TOKEN_${BOT_NUM}"
BOT_TOKEN="${!BOT_TOKEN}"

# 讀取佇列
QUEUE=$(cat "$QUEUE_FILE")

# 用 jq 找到第一個 status=pending 且 to=$BOT_NUM 的任務
TASK=$(echo "$QUEUE" | jq -r --arg bot "$BOT_NUM" '.tasks | map(select(.status == "pending" and .to == $bot)) | .[0]')

if [ "$TASK" = "null" ] || [ -z "$TASK" ]; then
  exit 0
fi

TASK_ID=$(echo "$TASK" | jq -r '.id')
CONTENT=$(echo "$TASK" | jq -r '.content')

# 把任務狀態改為 processing
# （需要用 Python 或 jq 完整讀取、修改、寫回，避免競態條件）

# 這裡只是框架，詳細實作交給 Claude Code
```

### Step 3：設定 Cron Job（每 10 秒輪詢）

在 2號機（.openclaw-kong）和 3號機（.openclaw-peipei）的 gateway 設定中加入 cron job：

```json
{
  "cron": {
    "enabled": true,
    "jobs": [
      {
        "name": "relay-poll",
        "schedule": { "kind": "every", "everyMs": 10000 },
        "payload": {
          "kind": "agentTurn",
          "message": "請執行 relay_poll.sh 檢查是否有新任務"
        },
        "sessionTarget": "isolated"
      }
    ]
  }
}
```

### Step 4：修改 SOUL.md 的溝通方式

更新三個 bot 的 SOUL.md，把委派方式從「sessions_send」改為「寫入 RELAY_QUEUE.json」。

---

## ⚠️ 重要技術細節

1. **競態條件（Race Condition）**：
   - 三個 bot 都在讀寫同一個檔案
   - 必須用「先 lock 再修改」的機制
   - 建議用 Python 脚本作為 atomic update，或者用 `flock` 指令

2. **任務超時（Timeout）**：
   - 如果一個任務 status=processing 超過 60 秒，自動重置為 pending，讓其他 bot 可以接手

3. **multi-agent-chat 插件**：
   - 當 bot 在群組發言時，plugin 會自動在 sessions_send 結束後把回覆送到群組
   - 這是為什麼輪詢腳本要用 sessions_spawn 而不是直接用 exec

---

## 📁 檔案變更清單

| 檔案 | 動作 |
|-----|------|
| `shared-context/RELAY_QUEUE.json` | 新建（初始空佇列） |
| `scripts/relay_poll.py` | 新建（Python 版本，防止競態） |
| `scripts/relay_submit.py` | 新建（供 1號機 寫入任務） |
| `scripts/setup_cron_jobs.py` | 新建（設定 cron jobs） |
| 三個 bot 的 SOUL.md | 更新（委派方式） |

---

## ✅ 完成標準

- [x] RELAY_QUEUE.json 存在且格式正確
- [x] relay_poll.py / relay_submit.py 已實作（Python 版本，防止競態）
- [ ] relay_poll.sh 能正確讀取並處理任務
- [ ] 1號機 對教練說「呼叫學弟」時，任務會被寫入佇列
- [ ] 學弟在 10 秒內檢測到任務並在群組回覆
- [ ] 連續三次委派測試都成功
- [ ] Git commit + 回報 commit hash

---

## 📝 實作記錄（2026-04-30 心跳）

### 已完成
- ✅ `scripts/relay_submit.py`（寫入任務）
- ✅ `scripts/relay_poll.py`（輪詢+處理任務，含超時機制）
- ✅ 更新 TASK_SHARED_QUEUE_RELAY.md 標記完成狀態
