# HEARTBEAT 熱上下文（每次心跳必讀）

> 由 Claude 助教維護 | 最後更新：2026-04-12 06:30

---

## 🔁 正常心跳（每 30 分鐘）

**只做這一件事**：回覆 `HEARTBEAT_OK` 即可。
❌ 不需要重讀記憶檔案（記憶檔已超過 50KB，讀了會造成空白回應）

---

## 🚨 重啟後才需要做（Context Overflow 或 Session Lock 後）

按順序執行：
1. 直接告訴教練：「🦞 對話記錄已滿，已自動重啟，請繼續下指令」
2. **不要讀 memory 大檔**（2026-04-12.md 已 55KB，會讓 Gemini 回空白）
3. 等教練下新指令再開始工作

---

## 📋 當前任務狀態（2026-04-12 更新）

| 任務 | 狀態 |
|------|------|
| 五條備援模型線路 | ✅ Primary = Gemini 3.1 Pro |
| 記憶體系 | ✅ memory/ 已建立 |
| Context Overflow 自動修復 | ✅ 書籤全量存檔 |
| 30 分鐘記憶同步 | ✅ LaunchAgent 運行中 |
| YouTube 31 頻道監測 | ✅ 今天 12:30 自動跑 |
| NotebookLM 搬移驗證 | ⏳ 未確認 |

---

## ⚠️ 守則摘要

- **全部繁體中文**，不夾任何英文
- **能自己做直接做**，不問確認
- **Telegram = 小龍蝦 = 電報**（三個說法同一個意思）
- **預估超過 5 萬 Token** 先回報教練確認
- **截圖禁用**，直接讀 JSONL 檔案
- **執行完立刻** Telegram 通報（Chat ID: 6124913915）
- **⚠️ 不要讀大型 memory 檔**（會造成 Gemini 空白回應）

---

## 🏗️ 系統架構速查

- Primary 模型：`google/gemini-3.1-pro-preview`
- Fallback：sambanova → cerebras → openrouter gemma → openrouter nemotron → claude sonnet
- SambaNova 端點：`https://fast-api.snova.ai/v1`
- Session Lock 修復：刪 JSONL + 清 sessions.json + 清 cooldown + 重啟 gateway
