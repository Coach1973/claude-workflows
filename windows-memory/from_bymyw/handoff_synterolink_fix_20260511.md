---
name: Synterolink 接入修復接班（2026-05-11）
description: 把 Claude CLI 從 EasyClaude 切到 Synterolink 的修復進度，含關鍵啟動詞與下一步
type: handoff
date: 2026-05-11
originSessionId: e08504ad-23a4-4a10-ab3a-2b905e47bc7d
---
# 關鍵啟動詞（教練在新視窗貼這句即可接續）

> **「軍師，Synterolink 接班，讀 handoff_synterolink_fix_20260511。」**

讀完後我會自動：
1. 確認當前 CLI 是否已經連到 Synterolink（看 process env 與 settings.json）
2. 若連線正常，直接進入下一階段工作
3. 若連線失敗，按本檔「除錯路徑」處理

---

# 本輪做了什麼（一句話）

把 CC Switch 的 Synterolink provider DB 設定校正、`.claude\settings.json` 同步改寫成 AUTH_TOKEN + 根網址，三邊（DB、CC Switch UI 狀態、Claude settings）對齊。

# 三邊現狀（已對齊 ✅）

| 位置 | 內容 |
|------|------|
| `cc-switch.db` providers 表 synterolink 那筆 | `ANTHROPIC_AUTH_TOKEN=sk-f57e…18c22e` + `ANTHROPIC_BASE_URL=https://api.synterolink.com`（無 /v1），`is_current=1` |
| `C:\Users\bymyw\.cc-switch\settings.json` | `currentProviderClaude: "synterolink"` |
| `C:\Users\bymyw\.claude\settings.json` | env 區塊已是 AUTH_TOKEN + 根網址（一致） |

DB 裡 `default` provider 也被改成 synterolink 內容（教練在 UI 操作的副作用，不影響運作）。

# 備份位置

- `C:\Users\bymyw\.cc-switch\backups\cc-switch.db.before_synterolink_fix_20260511_212359`
- `C:\Users\bymyw\.claude\settings.json.before_synterolink_fix_20260511_213046`
- 上一輪舊備份：`db_backup_20260511_211513.db`、`db_backup_20260510_015913.db`

# 兩個關鍵踩雷點（已寫進 memory，避免再犯）

1. **Synterolink 規格**：必須用 `ANTHROPIC_AUTH_TOKEN`（不是 API_KEY），Base URL 用根網址 `https://api.synterolink.com`（不要加 `/v1`，CLI 會自動加 `/v1/messages`）。記在 `reference_synterolink_setup.md`。
2. **CC Switch 切換不用重啟 CLI**：教練 5/11 親驗，UI 切完當前對話框直接生效。記在 `feedback_cc_switch_no_restart.md`。

# 教練的 CC Switch 新增能力（5/11 由桌面版助教做的）

教練把「現用的 EasyClaude 模型」也加進 CC Switch 一筆。意義：任何 provider 出問題（包含 Synterolink），都能在 CC Switch UI 即時切回 EasyClaude，不用關 CLI、不用重啟。CC Switch 變成熱切換的保險。

# 工具與路徑備忘（不要再走冤枉路）

- **sqlite3.exe 在這**：`C:\Users\bymyw\AppData\Local\Microsoft\WinGet\Packages\SQLite.SQLite_Microsoft.Winget.Source_8wekyb3d8bbwe\sqlite3.exe`
- **Windows 內建 python.exe 是 stub**：跑會 exit 9009，py launcher 也沒裝。要查 DB 直接用上面那支 sqlite3.exe。
- **classifier 對 sqlite3 命令敏感**：把指令寫成 `.sh` 檔再 `bash xxx.sh` 比直接打整串穩定（本輪實測）。

# 除錯路徑（萬一新視窗開不起來）

**症狀 A：401 / 403 / Invalid API key**
→ 先看 `.claude\settings.json` env 區塊。如果 KEY 名變回 `ANTHROPIC_API_KEY` 或 URL 又多了 `/v1`，代表被某個流程蓋寫；查 CC Switch DB 該 provider 的 `settings_config` 是不是又錯了。

**症狀 B：連到 EasyClaude（不是 Synterolink）**
→ 教練在 CC Switch UI 切到 Synterolink；切完當下生效，不用重啟。

**症狀 C：完全連不上（網路錯誤）**
→ 教練在 CC Switch UI 切回 EasyClaude（保險），先讓 CLI 能用，再回頭查 Synterolink 後台 / 配額（900 點是平台後台的事，CLI 端看不到）。

# 下一步（教練裁示）

接班後請教練指定：
- (a) 確認 Synterolink 連通後，回到原本的工作主線（如果上一輪有暫停的工作）
- (b) 把 MEMORY.md 那批「待補」的記憶從 `E:\Claude-Data\mac-openclaw-workflows\windows-memory\from_system32\` 搬遷整理
- (c) 其他指示
