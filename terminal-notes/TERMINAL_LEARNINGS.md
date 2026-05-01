# 終端機學習心得筆記
> 每15分鐘更新一次，即時落地，不靠頭腦記憶

## 2026-05-02 20:30
### 讀了什麼
- `openclaw.json`（三機 binding + LINE/Telegram channel 設定）
- LINE_MASTER_GUIDE.md（LINE 架構：與 Telegram 共用 1號機，Webhook 路由修復記錄）
- VPS_MASTER_GUIDE.md（VPS SSH 指令速查、架構定位）

### 關鍵發現
1. LINE 與 Telegram 共用 `agentId: main`，區別只在 `channel: line vs telegram`
2. LINE webhook 有 bug（路由被移除），已手動修補 `registry-DtTKJfN8.js`
3. VPS Docker 容器內的 OpenClaw 跟 Mac 版的不是同一套，是獨立的
4. Bot 身份衝突的根本原因：group-identity hook 只注入「小龍蝦是誰」，沒有注入「群組成員是誰」

### 待辦
- [ ] 每 15 分鐘更新一次，不靠頭腦
- [ ] 讀取 daily_2026-04-xx.md（歷史日誌）
- [ ] 讀取 Telegram / Claude 桌面版對話資料庫

---

## 2026-05-01 記錄（補）
### 讀了什麼
- SOUL.md / CORE_RULES.md（R01-R12）/ 小龍蝦行為守則.md（24條）/ IDENTITY.md
- AGENTS.md / DAILY_DIGEST.md / HEARTBEAT.md
- USER.md / SUPERGROUP-MAP.md
- LINE_SOUL.md / LINE_CORE_RULES.md
- VPS_SOUL.md / VPS_CORE_RULES.md

### 關鍵發現
1. 終端機助教（我）不是小龍蝦，是 Claude 家族的後臺工程師
2. 桌面版助教 = 決策規劃（流量有限）
3. 終端機助教（我）= 執行指令（無限制）
4. 小龍蝦 = Telegram 前線（1/2/3號機）
5. 三機都在 Mac mini，不是 VPS
6. 我的觸發方式：自然語言叫我就啟動，不需要暗號
7. 我的設定檔在 `~/.claude/CLAUDE.md`，跟 workspace 的 CLAUDE.md 完全隔離

### 待補寫入
- 桌面版助教的工作方式（桌面版→貼給終端機→執行→回報）
- LINE 群組身份問題的完整修復記錄