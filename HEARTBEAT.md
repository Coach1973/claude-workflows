# HEARTBEAT 熱上下文（每次心跳必讀）

> 由 Claude 助教維護 | 最後更新：2026-04-11 16:00

---

## 🔁 正常心跳（每 30 分鐘）

**只做這一件事**：回覆 `HEARTBEAT_OK` 即可。
❌ 不需要重讀記憶檔案（避免 Token 浪費與 Context 膨脹）

---

## 🚨 重啟後才需要做（Context Overflow 或 Session Lock 後）

按順序執行：
1. 讀 `memory/2026-04-11.md` — 取得完整工作進度
2. 告訴教練：「🦞 對話記錄已滿，已自動重啟並讀取最新進度，請繼續下指令」
3. 繼續未完成的任務

---

## 📋 當前任務狀態（2026-04-11 更新）

| 任務 | 狀態 |
|------|------|
| 五條備援模型線路 | ✅ 完成（Primary = Gemini 3.1 Pro） |
| 記憶體系建立 | ✅ 完成（memory/ 已建立） |
| Context Overflow 自動修復 | ✅ 完成（書籤全量存檔） |
| 30 分鐘記憶同步 LaunchAgent | ✅ 完成 |
| YouTube 31 頻道監測 | ✅ 完成（明天 12:30 第一次跑） |
| NotebookLM 搬移驗證 | ⏳ 未確認（腳本已跑） |
| Obsidian 第二大腦 | ❌ 未開始 |

---

## ⚠️ 守則摘要

- **全部繁體中文**，不夾任何英文
- **能自己做直接做**，不問確認
- **Telegram = 小龍蝦 = 電報**（三個說法同一個意思）
- **預估超過 5 萬 Token** 先回報教練確認
- **截圖禁用**，直接讀 JSONL 檔案
- **執行完立刻** Telegram 通報（Chat ID: 6124913915）

---

## 🏗️ 系統架構速查

- Primary 模型：`google/gemini-3.1-pro-preview`
- Fallback 1：openrouter nemotron → 2：openrouter gemma → 3：sambanova llama → 4：cerebras qwen → 5：claude sonnet
- SambaNova 端點：`https://fast-api.snova.ai/v1`（不是 api.sambanova.ai）
- Session Lock 修復：刪 JSONL + 清 sessions.json + 清 cooldown + 重啟 gateway
