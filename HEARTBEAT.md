# HEARTBEAT 熱上下文（每次心跳必讀）

> 最後更新：2026-04-24 下午（Claude 桌面版 UI，視窗結案交接）

## ⚡ 系統狀態
- Primary 模型：claude-sonnet-4-6（Claude 桌面版 UI）
- 名稱對等：Telegram = 小龍蝦 = 電報

## 🔴 新視窗啟動後第一件事
直接告訴教練：「🦞 已同步最新記憶，PROMISES 尚有3條待兌現」

## 📋 PROMISES 待兌現（3條）
| # | 內容 | 狀態 |
|---|------|------|
| 14 | 金句篩選器（138條）待教練人工審核 → 桌面 `金句篩選器.html` | ⬜ 等教練點選 |
| 15 | Windows 桌面版 Claude 助教開工觸發詞設定 | ⬜ 等聯想 CLI 執行 `CLAUDE_CLI_TASK_WIN_DESKTOP.md` |
| 16 | 宏碁備用機開工觸發詞設定 | ⬜ 等帶宏碁外出時執行 |

---

## ✅ 今日完成里程碑（2026-04-24）

### 三機體系正式確立
- Mac / 聯想 / 宏碁（備用）三機定義寫入 `project_team_structure.md`
- 聯想 Claude CLI：CLAUDE.md 開工觸發詞設定完成（`d22a1a9`）
- PROMISES #15、#16：任務書已立案

### 知識庫建設
- `SEABISCUIT_KNOWLEDGE_BASE.md` 產出（303行，Claude CLI 聯想，`89bb753`）
- `seabiscuit_case_studies.md` 追加 7 條哲學語錄（Hermes CLI，`6af3510`）
- 金句候選清單（138條）+ 互動篩選器 HTML 存桌面，待教練審核

### 自動化
- 每2小時蒸餾 cron 建立（`7a52c34`）→ JSONL → Claude API → `distilled_claude_[日期].md` → git push

### 機器人通訊系統
- 1號機 `SOUL.md` 補入 bot-relay 夥伴通訊說明，修正「看不到其他 bot」誤判（`4a771ae`）
- 三台 bot Group Privacy 已全部關閉（教練親自完成）
- BOT_MESSAGES.md 共享日誌運作正常（三台皆可讀寫）

### ClawHub 技能安裝
- `multi-agent-group-chat`（v2.0）已安裝至 workspace/skills/
- `team-communication`（v1.0）已安裝至 workspace/skills/

---

## 🔜 下個視窗待辦

| 優先 | 任務 | 執行者 |
|------|------|--------|
| 高 | 教練審核金句篩選器（桌面 `金句篩選器.html`） | 教練 |
| 高 | 聯想 CLI 執行 `CLAUDE_CLI_TASK_WIN_DESKTOP.md`（#15） | Claude CLI 聯想 |
| 中 | 裝 `webhook-send` 技能，讓1號機 HTTP 叫醒 2/3號機實現跨機對話 | 下個視窗克勞德助教 |
| 中 | 宏碁備用機開工設定（#16） | 帶宏碁外出前 |
| 低 | 31個 YouTube 頻道排程穩定化 | Hermes CLI |

---

## ⚠️ 所有對話守則
- 全部繁體中文，不夾任何英文
- 能自己做直接做，不問確認
- 預估超過 5 萬 Token 先回報教練確認（今日違規一次，已記錄）
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
- relay 端口：1號18789 / 2號18793 / 3號18790，token: `relay-secret-2026`
- ClawHub：`openclaw skills search "功能"` → `openclaw skills install <slug>`
- CLI 分工地圖：`workspace/CLI_DIVISION.md`
- ClawHub 技能數量：約 13,700+（非 12,000）

## ⚠️ 已知問題
- `sessions_send` 不支援跨 gateway 進程（三機各自獨立），需用 `webhook-send` HTTP 方式互叫
- openclaw.json 不接受 `remoteAgents` key（已嘗試並還原）
- plugins.allow 內有殘留的 `capability` stale entry，不影響運作但可清理
