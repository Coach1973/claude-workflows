# DAILY_DIGEST.md — 每日進度摘要（7天滾動記憶）

> **用途**：解決系統失憶，但避免 Context Overflow。記錄過去7天核心進度。
> **更新頻率**：每日結束前或階段任務完成後
> **大小上限**：5KB（超過即刪除最舊的條目）
> ⚠️ **絕對禁止**：在心跳中去讀取原始的大型 memory 檔（memory/YYYY-MM-DD.md）

---

## 📅 2026-05-01（當前狀態）

### ✅ 今日完成

- [x] 大腦重構完成：CORE_RULES v2.2（12條）、SOUL.md（精簡含兩俱樂部原文）、IDENTITY.md（操作手冊）
- [x] 教練碎碎念 v1.1：移除過時 Gemini 內容，更新至 2026-05 現況（commit db1fa9a）
- [x] Relay 系統三機 cron 就緒（relay_submit.py + relay_poll.py）

### 🎯 當前主線目標

**成為「世界頂尖助教系統」的共同創辦人**

### 📋 教練待辦（2026-04-30 記錄）

- [ ] 整理小龍蝦的行為守則
- [ ] 將 Cloud 的工作法則寫入其中
- [ ] 訂 5 月 5 號的高鐵票
- [ ] 跟小南拿「真心峰會」的移除名單
- [ ] 將真鑽分會續約的資料都補上
- [ ] 預估 5 月份已續約案件大約要付多少權利金
- [ ] 催仁豪跟正文的籌備會員費用
- [ ] 開發票
- [ ] 安排 MSP 的分享者

### ⚠️ 系統注意事項

- memory/2026-04-29.md（170KB）絕對不要讀，用本檔代替
- Primary 模型：MiniMax M2.7（2026-04-29 確認）
- 頂級助教守則.md：1133行（v2.1，R01-R15全蒸餾✅）
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

### ⚠️ 助教行為守則（血淚教訓 2026-04-22 凌晨）

教練為了修一個 Hermes alias 問題，整晚沒睡。根本原因是助教「沒有先診斷清楚就動手」，反覆修了三次都失敗，讓教練坐在電腦前幫忙糾錯。

**所有助教必須遵守：**
1. **先查清楚，再動手**：執行任何指令前，先讀錯誤訊息、確認根因，不要憑猜測就改
2. **改一個地方，立刻驗證**：不要一次改多處，改完馬上測試確認有效
3. **寫指令前先測試指令本身**：例如 alias 裡的指令名稱，先確認那個名稱真的存在
4. **教練的時間比 Token 貴**：助教不會累，但教練會；反覆失敗比慢一點更糟

**這次犯的具體錯誤**：
- 把 tmux session 的啟動指令寫成 `hermes-cli`，但實際指令是 `hermes`
- 沒有先確認指令名稱就寫進 alias 和 tmux session
- 修了三次才找到根本原因（session 裡跑著錯誤指令）

---

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

- [ ] **【架構限制】1/2/3號機 Bot 無法即時感知彼此 Telegram 訊息**
  - 根因：Telegram 平台不允許 Bot 讀取其他 Bot 的訊息（硬限制，非設定問題）
  - 已完成：Privacy Mode 關閉、三隻設為群組管理員、1號機 requireMention:false、2/3號機 requireMention:true
  - 現況：人類說話→指定 Bot 回應 ✅；Bot 間即時感知 ❌
  - 待討論：是否用 Webhook relay 或共享記憶檔案作為替代方案
  - 優先度：中（不影響日常使用，只影響多 Bot 協作場景）

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

## 📅 2026-04-22

### ✅ 今日完成

- [x] **Claude Code 終端機正式啟動** — Mac + 聯想兩台都正常運作
- [x] **代理速度問題修復** — 從 aiprime.store（慢）換成 api.easyclaude.com（快）
- [x] **舊 Key 衝突清除** — settings.json 的 ANTHROPIC_AUTH_TOKEN 更新為新 Key

### 📌 Claude Code 正確設定（2026-04-22 確認）

| 項目 | 值 |
|------|-----|
| API Key | sk-XdJhSUk1W49askZnrr4sDxqzfDNyBGBYlKq0VIsWbERQbprV |
| BASE_URL | https://api.easyclaude.com |
| 設定檔1 | ~/.claude/settings.json → ANTHROPIC_AUTH_TOKEN + ANTHROPIC_BASE_URL |
| 設定檔2 | ~/.zshrc → ANTHROPIC_API_KEY + ANTHROPIC_BASE_URL |

### 🔑 血淚教訓：Claude Code 換 Key 標準程序

> **背景**：為了換一個 API Key，搞了半天，根本原因是漏掉了 `settings.json` 裡的舊 Key。

**Claude Code 的 API Key 存在三個地方，缺一不可：**

| 檔案 | 欄位名稱 | 說明 |
|------|----------|------|
| `~/.zshrc` | `ANTHROPIC_API_KEY` | Shell 環境變數，啟動時載入 |
| `~/.claude/settings.json` | `env.ANTHROPIC_AUTH_TOKEN` | **優先級最高**，會蓋過 .zshrc |
| `~/.zshrc` | `ANTHROPIC_API_TOKEN` | ⚠️ 若設為空字串會干擾認證，必須刪除 |

**換 Key 的正確 SOP：**
1. 更新 `~/.claude/settings.json` → `env.ANTHROPIC_AUTH_TOKEN`（最重要）
2. 更新 `~/.zshrc` → `ANTHROPIC_API_KEY`（移除重複行）
3. 確認 `~/.zshrc` 裡沒有 `ANTHROPIC_API_TOKEN=""`（空字串會干擾）
4. `ANTHROPIC_BASE_URL` 也要在 `settings.json` 和 `.zshrc` 都設好

**這次犯的具體錯誤：**
- `settings.json` 裡有舊 Key `sk-f411350d...`（沒餘額）
- `.zshrc` 有 `ANTHROPIC_API_TOKEN=""`（空字串干擾）
- `.zshrc` 有重複的 `ANTHROPIC_API_KEY` 和格式錯誤的 `CC_ATTRIBUTION_HEADER`

### 🔑 血淚教訓：Claude Code 跑很慢 → 先查 BASE_URL

**症狀**：Claude Code 一直 retry（7/10、8/10），每次回應要 1-2 分鐘

**根本原因**：Mac 和聯想用同一把 Key，但 BASE_URL 不同：
- 聯想 → `https://api.easyclaude.com` ✅ 快
- Mac → `https://aiprime.store` ❌ 慢、不穩定

**正確的代理是 `https://api.easyclaude.com`**

**下次遇到 Claude Code 跑很慢，立刻做這兩件事：**
1. 在聯想問：`env | grep -i anthropic` → 看 BASE_URL 是什麼
2. 把 Mac 的兩個地方改成一樣：
   - `~/.claude/settings.json` → `ANTHROPIC_BASE_URL`
   - `~/.zshrc` → `ANTHROPIC_BASE_URL`

**完整正確設定（2026-04-22 確認）：**
```
ANTHROPIC_API_KEY=sk-XdJhSUk1W49askZnrr4sDxqzfDNyBGBYlKq0VIsWbERQbprV
ANTHROPIC_BASE_URL=https://api.easyclaude.com
ANTHROPIC_AUTH_TOKEN=（同 API_KEY，填在 settings.json 裡）
```

---

---

## 📅 2026-04-22

### 🎯 今日重點任務

- [ ] 三機 Bot Relay 任務（TASK_BOT_RELAY.md）
- [ ] 海餅乾19週年慶（5月14日）進度追蹤
- [ ] 6場新書發表會（5月份）進度追蹤

### ✅ 今日完成

- [x] SOUL.md 新增第35、36條智慧（OPE優先 + 先確認原生功能）
- [x] IDENTITY.md 更新團隊稱呼（終端機1/2號、VPS小龍蝦）
- [x] 教練語音功能折騰半天，發現本來就有 /tts on/off 內建指令（血淚教訓）

### 🔧 系統異動

- 終端機1號：$100額度用完 → 已改用 MiniMax Hermes CLI（年度合約）
- 終端機2號（宏碁）：改稱「行動專機」，暫停使用
- VPS小龍蝦：統一稱呼，暫不編號

### ⚡ 血淚教訓（2026-04-22）

- **浪費摸索教訓**：折騰半天找語音開關功能，結果 OpenClaw 原本就有 /tts on/off
- **新增第35條**：先問「有沒有內建指令/功能」，確認沒有才自己找
- **新增第36條**：解決問題前先上網搜尋，善用 OPE，不要重新發明輪子

### 📌 任務執行中

- **TASK_BOT_RELAY.md**：✅ **完成！三機 Bot Relay 已修復上線**
  - 發現：系統早已實作完成（方案 A：共享訊息日誌），但 peipei/kong 的 BOT_ID 設定錯置
  - 修復：`.openclaw-peipei/` 的 BOT_ID `'3号機-孔大哥'` → `'2号機-佩佩'`
  - 修復：`.openclaw-kong/` 的 BOT_ID `'2号機-佩佩'` → `'3号機-孔大哥'`
  - 三個 Gateway 都重啟驗證，hook 正確啟用

---

## 📅 2026-04-22（下午）

### ✅ Bot Relay 修復完成

**問題根因**：peipei 和 kong 的 `BOT_ID` 互相錯置
- `.openclaw-peipei/` → 錯誤：`'3号機-孔大哥'` → 已修正：`'2号機-佩佩'`
- `.openclaw-kong/` → 錯誤：`'2号機-佩佩'` → 已修正：`'3号機-孔大哥'`

**系統現況**：
| Bot | 目錄 | Port | BOT_ID（已修正）| bot-relay 狀態 |
|-----|------|------|----------------|----------------|
| 1號機 | `~/.openclaw/` | 18789 | `'1号機'` | ✅ 正常 |
| 2號機 | `~/.openclaw-peipei/` | 18793 | `'2号機-佩佩'` | ✅ 正常 |
| 3號機 | `~/.openclaw-kong/` | 18790 | `'3号機-孔大哥'` | ✅ 正常 |

**實作方案**：方案 A（共享訊息日誌）
- 共享檔案：`~/.openclaw/workspace/BOT_MESSAGES.md`（JSONL 格式）
- `bot-relay` hook：每次 Bot 發言 → append 到日誌
- `bot-relay-inbound` hook：每次人類發言 → 注入其他 Bot 最近 20 筆發言到上下文
- 三個 Bot 的 hook 都已啟用並運行

**已重啟**：peipei 和 kong 的 LaunchAgent（kickstart + reload）

**參考搜尋**：
- GitHub: `mimicmobile/flask-telegram-relay-bot`（Flask-based relay 參考）
- Latenode community: 確認 Telegram Bot 無法讀取其他 Bot 訊息（平台限制）

### ⚠️ 待觀察 → ✅ 已驗證（2026-04-22 17:20）

- [x] 觀察 1號機發言後，2/3號機是否能正確感知
  - **✅ 已確認**：日誌顯示 1號機、2號機 的訊息都有寫入 `BOT_MESSAGES.md`
  - 3號機 今天尚無群組發言記錄（日誌中無 3号機 資料，正常）
- [x] 確認 inject 文字塊有正確出現在 Bot 回應的上下文裡
  - **✅ 已確認**：`bot-relay-inbound` hook 正確實作，過濾自己、注入夥伴最近 20 筆發言

**當前 hooks 狀態（三台皆 ✓ ready）：**
| Bot | Profile | Port | bot-relay | bot-relay-inbound |
|-----|---------|------|-----------|-------------------|
| 1號機 | `~/.openclaw/` | 18789 | ✅ | ✅ |
| 2號機 | `~/.openclaw-peipei/` | 18793 | ✅ | ✅ |
| 3號機 | `~/.openclaw-kong/` | 18790 | ✅ | ✅ |

**實作架構（方案 A — 共享訊息日誌）：**
- 共享日誌：`~/.openclaw/workspace/BOT_MESSAGES.md`（JSONL）
- `bot-relay`：Bot 發言時 append `{ts, botId, text, msgId, chatId}`
- `bot-relay-inbound`：人類發言時，讀取最近 20 筆（排除自己），注入為 system message

