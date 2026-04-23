# HEARTBEAT 熱上下文（每次心跳必讀）

> 最後更新：2026-04-24（Claude 桌面版 UI，視窗結案交接）

## ⚡ 系統狀態
- Primary 模型：claude-sonnet-4-6（Claude 桌面版 UI）
- 名稱對等：Telegram = 小龍蝦 = 電報

## 🔴 新視窗啟動後第一件事
直接告訴教練：「🦞 已同步最新記憶，PROMISES 尚有1條待兌現」

## 📋 PROMISES 待兌現（4條）
| # | 內容 | 狀態 |
|---|------|------|
| 11 | 8.5MB JSON（4/22-4/23）對話提煉 → 補入教練金句庫 | ⬜ 待啟動 |
| 12 | 海餅乾知識庫 + seabiscuit 完整融合比對（避免重複） | ⬜ 指派給聯想 Claude Sonnet CLI |
| 13 | 每兩小時蒸餾任務誰負責執行確認 | ⬜ 待確認 |
| 14 | 100/200 金句提煉（海餅乾知識庫精華） | ⬜ 待啟動 |

---

## ✅ Hermes 剛完成（hash: `97d66c4`）
- `COACH_DECISIONS_APRIL.md`：29 條決策記錄
- `COACH_GOLDEN_QUOTES_APRIL.md`：52 條金句（九大類）
- PROMISES.md：補入 #11-14 四條漏網之魚

---

## ✅ 本視窗完成的里程碑（2026-04-24）

### 補記 CLI 三助教分工（`CLI_DIVISION.md`，hash: `9c84f09`）
| 助教 | 位置 | 強項 | 限制 |
|------|------|------|------|
| Claude 桌面版 UI | Mac GUI | 神經中樞、思考、寫指令書 | 不做量大重複 |
| Hermes CLI（1號終端機） | Mac mini | 量大/長時間/定時，無限額度 | 不跨目錄，不做模糊任務 |
| Claude Sonnet CLI（2號終端機） | 聯想 Windows | 理解力分析、提煉判斷 | 每天20元人民幣，不做定時任務 |

### 防呆機制寫入（hash: `afc6425`）
- 全域 CLAUDE.md + workspace CLAUDE.md 加入「結論即時落地鐵律」
- 達成結論 = 立刻 commit，不等對話結束，不等教練提醒

### PROMISES #8 結案（hash: `2bddd83`）
- 8.5MB JSON → 提煉 12 條哲學語錄追加至 seabiscuit_case_studies.md
- 立案 hash: c6f034f，完成 hash: a33f014

### 四月份教練語錄提煉準備完成
- 8 個對話視窗，648 條教練發言，已輸出為桌面 `coach_messages_april_FULL.md`
- 交 Hermes CLI 執行三項提煉（進行中）

---

## 🔜 下個視窗待辦

1. **接收 Hermes 回報**：四月語錄提煉的 commit hash，更新 PROMISES（若有新發現的未兌現承諾）
2. **指派 PROMISES #9 給聯想 Claude Sonnet CLI**：
   - 任務：讀取現有 seabiscuit 相關檔案，完整建立海餅乾知識庫
   - 相關檔案：`seabiscuit_case_studies.md`、`seabiscuit_golden_quotes.md`、`seabiscuit_ideas_backlog.md`、`sea_biscuit_club.md`、`SEABISCUIT_TEN_COMMANDMENTS.md`
3. **Hermes 任務範本更新**：以後每個任務指令結尾加 git commit + Telegram 回報 hash

---

## ⚠️ 所有對話守則
- 全部繁體中文，不夾任何英文
- 能自己做直接做，不問確認
- 預估超過 5 萬 Token 先回報教練確認
- 執行完通報 Telegram（Chat ID: 6124913915）

## 🤖 克勞德助教對話 JSONL 路徑
- 所有視窗記錄：`/Users/bymyway/.claude/projects/-Users-bymyway--openclaw/*.jsonl`
- 每2小時自動蒸餾 cron（已設定）→ 輸出：`workspace/distilled_claude_[日期].md`
- 蒸餾腳本：`workspace/scripts/distill_claude_sessions.py`
- Cron log：`workspace/logs/distill_cron.log`

## 🔑 關鍵架構速查
- shared-context 路徑：`/Users/bymyway/.openclaw/workspace/shared-context/`
- 三機 bot：1號 @openclaw_macbook4_bot / 2號 @CoachWu_openclaw_bot / 3號 @coachwu_lenovo_bot
- 群組 ID：-1003877502911（頂級特助分工群）
- ClawHub：`openclaw skills search "功能"` → `openclaw skills install <slug>`
- CLI 分工地圖：`workspace/CLI_DIVISION.md`
- 四月教練語錄：桌面 `coach_messages_april_FULL.md`（648 條）

## ✅ 今日完成里程碑（2026-04-24）

### 三機體系正式確立
- Mac / 聯想 / 宏碁（備用）三機定義寫入 project_team_structure.md
- 聯想 Claude CLI：CLAUDE.md 開工觸發詞設定完成（`d22a1a9`）
- PROMISES #15、#16：Windows 桌面版 + 宏碁備用機觸發詞任務已立案

### 知識庫建設
- SEABISCUIT_KNOWLEDGE_BASE.md 產出（303行，Claude CLI 聯想執行，`89bb753`）
- seabiscuit_case_studies.md 追加 7 條哲學語錄（Hermes CLI，`6af3510`）
- 金句候選清單（138條）+ 互動篩選器 HTML 已存桌面，待教練審核

### 自動化
- 每2小時蒸餾 cron 建立（`7a52c34`），讀 JSONL → Claude API → distilled_claude_[日期].md → git push
- CLAUDE.md 對話 JSONL 路徑寫入 HEARTBEAT.md

### 開工流程修復
- 全域 CLAUDE.md 啟動暗號已確認有效（含絕對路徑）
- 聯想 Claude CLI CLAUDE.md 今日第一次真正建立（非只口頭說說）

## 🔜 下一步

| 優先 | 任務 | 執行者 |
|------|------|--------|
| 高 | 教練審核金句篩選器（桌面 HTML），確認精選清單 | 教練 |
| 高 | 聯想 CLI 執行 CLAUDE_CLI_TASK_WIN_DESKTOP.md（#15） | Claude CLI 聯想 |
| 中 | 宏碁備用機開工設定（#16） | 下次帶宏碁外出前 |
| 低 | 31個 YouTube 頻道排程穩定化 | Hermes CLI |
