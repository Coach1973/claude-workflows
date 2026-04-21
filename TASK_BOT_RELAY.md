# TASK_BOT_RELAY.md — 三隻龍蝦 Bot 互通中繼任務

> **建立時間**：2026-04-22
> **執行者**：終端機 Claude Code
> **目標**：讓1/2/3號機 Telegram Bot 能「聽到」彼此的訊息

---

## 🔴 問題背景

三隻 OpenClaw Bot 在同一台 Mac mini 上，在同一個 Telegram 群組裡：
- **1號機（主龍蝦）**：Bot Token `8758843664:AAE4W-...`，port 18789
- **2號機（佩佩）**：Bot Token `8705446823:AAHDA0...`，port 18793
- **3號機（孔大哥）**：Bot Token（待確認），port（待確認）

**Telegram 硬限制**：Bot 無法收到其他 Bot 發的訊息（平台規則，無法繞過）

**現況**：
- 人類 → 指定 Bot 回應 ✅
- Bot A 說話 → Bot B/C 完全聽不到 ❌

---

## 🎯 目標解法：Webhook Relay（中繼轉發）

### 概念
在 VPS 或本機架一個輕量 relay 服務：
1. 三隻 Bot 各自設定一個「監聽 hook」
2. 任何 Bot 收到或發出訊息時，同時呼叫 relay
3. Relay 把訊息轉發給另外兩隻 Bot 的 OpenClaw API

### 或者更簡單的替代方案：共享訊息檔
- 每隻 Bot 收到訊息後，把內容 append 到一個共享檔案
- 其他 Bot 定時（每30秒）讀取這個檔案，感知彼此狀態
- 用 OpenClaw 的 hooks 機制實作

---

## 📋 請你做的事（請按順序）

### ⚠️ 執行前必讀：兩條鐵則
1. **先搜尋，不要自己摸索** — 用 Tavily 或 DuckDuckGo 搜尋別人解決過的方案，直接套用，不要重新發明輪子
2. **先確認原生功能** — 動手前先確認 OpenClaw 有沒有內建支援（`/help` 或查 commands-registry）

### Step 0：先上網搜尋（必做！）
```
搜尋關鍵字：
- "telegram bot relay messages between bots"
- "telegram bot cannot read other bot messages workaround"  
- "openclaw webhook relay"
- "telegram group bot to bot communication"

目標：找到別人已經實作過的方案，直接套用，不要自己從零開始。
```

### Step 1：先查清楚現有架構
```bash
# 查看3號機的 port 和 bot token
cat ~/.openclaw-kong/openclaw.json | grep -E '"port"|"botToken"'

# 查看 OpenClaw 的 hook 機制有哪些可用
ls ~/.openclaw/workspace/feedback_*.md | head -5
cat ~/.openclaw/workspace/WISDOM_CORES.md | grep -i hook
```

### Step 2：查看 OpenClaw 是否有內建轉發機制
```bash
# 查 OpenClaw 文件或 source，看是否有 relay 或 forward 功能
find /opt/homebrew/lib/node_modules/openclaw -name "*.json" | xargs grep -l "relay\|forward\|bridge" 2>/dev/null | head -5
```

### Step 3：設計最簡解法

請你根據查到的資料，選擇以下其中一個方案並實作：

**方案 A（推薦）：共享訊息日誌 + 定時感知**
- 在 `~/.openclaw/workspace/BOT_MESSAGES.md` 建立共享訊息日誌
- 用 OpenClaw 的 `hooks.internal` 機制，讓每隻 Bot 收到訊息時寫入這個檔案
- 每隻 Bot 的 session 開始時讀取最近 N 筆訊息

**方案 B：本機 Webhook Relay**
- 寫一個簡單的 Node.js 或 Python HTTP server
- 監聽一個 port（例如 19000）
- 三隻 Bot 設定 outgoing webhook 到這個 relay
- Relay 把訊息廣播給其他兩隻 Bot 的 OpenClaw API（`http://localhost:18789/...`）

### Step 4：實作並測試
- 實作選定的方案
- 測試：在 Telegram 群組讓1號機說話，確認2/3號機能感知到
- 把結果寫入 `~/.openclaw/workspace/DAILY_DIGEST.md`

---

## 🔧 重要參考資訊

### OpenClaw API 端點
- 1號機：`http://localhost:18789`
- 2號機：`http://localhost:18793`
- Auth token：`0283df55e8cb4c34a1c095f5f5ccb5455e7b388e30152ada`

### VPS 資訊（如需遠端協助）
- IP：43.245.60.200
- SSH：`ssh root@43.245.60.200`（密碼：9kdxvQN2）
- Docker container：openclaw

### Telegram Bot Tokens
- 1號機：`8758843664:AAE4W-hGh2mPxNt89b2donZ0Q--YZ9uwdsA`
- 2號機：`8705446823:AAHDA0wvjdxXsaB3yX3PRiEkG_wO2N-BWa8`
- 3號機：查 `~/.openclaw-kong/openclaw.json`

---

## ✅ 完成標準

- [ ] 至少一個方案可以運作
- [ ] 1號機在群組說的話，2/3號機能「感知到」
- [ ] 解法穩定，不需要每次重啟手動設定
- [ ] 結果記錄在 DAILY_DIGEST.md

---

## ⚠️ 行為守則（血淚教訓）

1. **先查清楚再動手**：不要憑猜測就改設定
2. **改一處、立刻驗證**：不要一次改多個地方
3. **教練在睡覺**：不要搞壞現有能用的東西，只做新增
4. **遇到不確定的，先記下來，等教練醒來再問**
