# HEARTBEAT 熱上下文（每次心跳必讀）

> 最後更新：2026-04-24（Claude 桌面版 UI，視窗結案交接）

## ⚡ 系統狀態
- Primary 模型：claude-sonnet-4-6（Claude 桌面版 UI）
- 名稱對等：Telegram = 小龍蝦 = 電報

## 🔴 新視窗啟動後第一件事
直接告訴教練：「🦞 已同步最新記憶，PROMISES 尚有1條待兌現」

## 📋 PROMISES 待兌現（1條）
| # | 內容 | 狀態 |
|---|------|------|
| 9 | 海餅乾知識庫統整（seabiscuit 知識庫完整建立） | ⬜ 指派給聯想 Claude Sonnet CLI |

---

## 🔄 目前背景任務（Hermes CLI 執行中）

**任務：四月份教練語錄 648 條 → 三項提煉**
- 輸入：`/Users/bymyway/Desktop/coach_messages_april_FULL.md`（499 KB，648 條教練發言）
- 輸出一：`COACH_DECISIONS_APRIL.md`（決策與分工提煉）
- 輸出二：`COACH_GOLDEN_QUOTES_APRIL.md`（金句精選 50-100 條）
- 輸出三：承諾核對（對比 PROMISES.md 找漏網之魚）
- 狀態：⏳ 執行中（本視窗結案時尚未完成）
- 完成後：Hermes 應 git commit 並用 Telegram 回報 hash（Chat ID: 6124913915）

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

## 🔑 關鍵架構速查
- shared-context 路徑：`/Users/bymyway/.openclaw/workspace/shared-context/`
- 三機 bot：1號 @openclaw_macbook4_bot / 2號 @CoachWu_openclaw_bot / 3號 @coachwu_lenovo_bot
- 群組 ID：-1003877502911（頂級特助分工群）
- ClawHub：`openclaw skills search "功能"` → `openclaw skills install <slug>`
- CLI 分工地圖：`workspace/CLI_DIVISION.md`
- 四月教練語錄：桌面 `coach_messages_april_FULL.md`（648 條）
