---
name: 系統基礎架構
description: 已建立的自動化機制、排程任務、資料夾結構與 GitHub 連接狀態
type: project
---

## 資料儲存架構

**E 槽是獨立 SSD（與 C/D 槽不同顆硬碟），為主要安全儲存位置。**

| 路徑 | 用途 |
|------|------|
| `E:\Claude-Data\scripts\` | 心跳腳本、待辦任務、日誌 |
| `E:\Claude-Data\restore\` | 還原腳本（C 槽還原後用） |
| `E:\Claude-Data\.claude\` | .claude 遷移目標（執行後才生效） |
| `C:\Users\bymyw\.claude\` | 目前仍在 C 槽，待遷移到 E 槽 |
| `E:\Claude-Data\session-logs\` | 每次對話工作總結 + 對話產出的重要檔案 |
| `E:\Claude-Data\memory-backup\` | memory\ 資料夾的鏡像備份（技能與經驗） |

**Why:** C 和 D 是同一顆硬碟的不同分割，E 槽才能真正防硬碟故障。

**待完成：** 關閉 Claude Code 後執行 `E:\Claude-Data\restore\migrate_claude_to_E.ps1`，將 .claude 移到 E 槽並建立 Junction。

---

## 心跳機制（ClaudeHeartbeat）

- **腳本：** `E:\Claude-Data\scripts\claude_heartbeat.ps1`
- **任務佇列：** `E:\Claude-Data\scripts\pending_tasks.md`
- **提示詞：** `E:\Claude-Data\scripts\heartbeat_prompt.txt`
- **日誌：** `E:\Claude-Data\scripts\heartbeat_log.txt`
- **排程：** Windows 工作排程器，每 2 小時執行
- **邏輯：** 白天（07:00-23:59）每 2 小時執行；深夜（00:00-06:59）距上次不足 4 小時則靜默跳過
- **流量限制時：** Claude 退出碼非 0，記錄日誌後等下次觸發，不需手動介入

**How to apply:** 有新的自動化任務要排程時，加入 pending_tasks.md，心跳會自動執行。需要用戶互動的任務請標注「[需要用戶互動]」。

---

## YouTube 每日摘要（YouTubeDailyDigest）

- **腳本：** `C:\Users\bymyw\.claude\scheduled-tasks\youtube-daily-digest\fetch_rss.ps1`
- **排程：** Windows 工作排程器，每天 08:00
- **頻道數：** 31 個（含 @sensebar，2026-04-06 新增）
- **發送目標：** Telegram Bot（已設定 token 和 chat_id）
- **過濾關鍵字：** AI、ChatGPT、Claude、效率、自動化、workflow 等

---

## GitHub 連接

- **帳號：** Coach1973（`gh auth login` 已完成，keyring 儲存）
- **Git user.name：** CoachWU
- **Git user.email：** Coach1973@users.noreply.github.com
- **protocol：** https
- **驗證：** 已建立 claude-test repo 並成功 push

## GitHub 倉庫（Repository）

| 倉庫名稱 | 說明 | 本地路徑 |
|----------|------|----------|
| `claude-test` | 連線測試用（可忽略）| — |
| `claude-workflows` | 所有自動化腳本正式備份 | `E:\Claude-Data\claude-workflows\` |

**claude-workflows 內容：**
- `scripts/`：心跳腳本、提示詞、待辦佇列、sync_memory_to_github.ps1
- `restore/`：C槽還原腳本、E槽遷移腳本
- `youtube/`：YouTube摘要腳本、31個頻道清單
- `memory/`：所有 .md 記憶檔鏡像（每 30 分鐘自動同步）
- `skills/`：所有技能鏡像（每 30 分鐘自動同步）

**更新方式：** Task Scheduler `ClaudeMemorySync` 每 30 分鐘自動執行 `sync_memory_to_github.ps1`，完成任務後也可立即手動執行。

---

## NotebookLM 帳號

| 暱稱（Profile） | 帳號 | 用途 |
|----------------|------|------|
| `default` | bymyway7@gmail.com | 個人筆記 |
| `public` | seabiscuitclub@gmail.com | 公共事務、資訊收集 |

切換指令：`nlm login switch public` / `nlm login switch default`

---

## GitHub Pages 網站清單（從 Netlify 遷移，共 21 個）

本機備份：`E:\Claude-Data\netlify-backup\`
更新方式：修改本機檔案 → git push → 1分鐘後自動生效

| 網站名稱 | GitHub Pages 網址 |
|----------|------------------|
| peipeievent-411 | https://coach1973.github.io/peipeievent-411/ |
| jiesheng-leadership | https://coach1973.github.io/jiesheng-leadership/ |
| bni-traffic | https://coach1973.github.io/bni-traffic/ |
| northern411 | https://coach1973.github.io/northern411/ |
| tainan-calender | https://coach1973.github.io/tainan-calender/ |
| tree-coach-book | https://coach1973.github.io/tree-coach-book/ |
| bniheroway | https://coach1973.github.io/bniheroway/ |
| bni-top10 | https://coach1973.github.io/bni-top10/ |
| bni-happy | https://coach1973.github.io/bni-happy/ |
| bni-88888 | https://coach1973.github.io/bni-88888/ |
| bni-99999 | https://coach1973.github.io/bni-99999/ |
| goeasy-ai | https://coach1973.github.io/goeasy-ai/ |
| goeasy-ai88 | https://coach1973.github.io/goeasy-ai88/ |
| worklucky-2026 | https://coach1973.github.io/worklucky-2026/ |
| everyday7 | https://coach1973.github.io/everyday7/ |
| courageous-scanstart | https://coach1973.github.io/courageous-scanstart/ |
| 其餘6個 | https://coach1973.github.io/{名稱}/ |

---

## 全域 CLAUDE.md（新增 2026-04-12）

- **位置：** `C:\Users\bymyw\.claude\CLAUDE.md`
- **作用：** Claude Code 每次啟動自動讀取，定義全域行為規則
- **核心指令：** 新對話開始時自動 git pull `E:\Claude-Data\claude-workflows`，讀取最新記憶
- **GitHub 備份：** `E:\Claude-Data\claude-workflows\CLAUDE.md.windows`

---

## 記憶自動同步（ClaudeMemorySync，新增 2026-04-12）

- **腳本：** `E:\Claude-Data\scripts\sync_memory_to_github.ps1`
- **排程：** Windows Task Scheduler `ClaudeMemorySync`，每 30 分鐘
- **動作：** memory\ + skills\ → 複製進 claude-workflows\ → git add / commit / push
- **日誌：** `E:\Claude-Data\scripts\sync_memory_log.txt`
- **原則：** 完成重要任務、除錯成功、新方法確立後，立即手動觸發一次；不要等 30 分鐘

---

## C 槽還原後的復原步驟

1. 執行 `E:\Claude-Data\restore\restore_junctions.ps1`
2. 重新啟動 Claude Code

此腳本會重建 .claude Junction 和所有 Task Scheduler 任務。
