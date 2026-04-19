# HEARTBEAT 熱上下文（每次心跳必讀）

> ⚠️ 剛剛因 Context Overflow（對話太長）自動重啟
> 重啟時間：2026-04-19 15:00
> 對話記錄已完整存入 memory/2026-04-19.md 並推上 GitHub，零遺漏

## 🔴 重啟後第一件事

直接告訴教練：「🦞 對話記錄已滿，已自動重啟，請繼續下指令」
⚠️ **不要讀 memory 大檔**（memory/2026-04-19.md 可能超過 50KB，讀了會造成 Gemini 空白回應）

## ⭐️⭐️⭐️ 新模型啟動必讀清單（每 次重啟後第一句話）

> 請直接說：「請讀取以上清單」，系統會依序載入以下檔案：

| 優先度 | 檔案 | 原因 |
|--------|------|------|
| ⭐️⭐️⭐️ | HEARTBEAT.md | 最新任務狀態 |
| ⭐️⭐️⭐️ | MEMORY.md | 長期累積的核心知識 |
| ⭐️⭐️⭐️ | ~/Desktop/HANDOFF.md | 三助教交接現況 |
| ⭐️⭐️ | memory/project_three_assistants_protocol_20260419.md | 分工協議 |
| ⭐️⭐️ | memory/project_model_config_current.md | 當前模型設定 |
| ⭐️ | memory/project_vps_day1_fullreport_20260419.md | VPS 今日進度 |

**注意**：SOUL.md、USER.md、HEARTBEAT.md 已由系統自動載入，無需手動呼叫。

---

## ⚡ 系統狀態
- Primary 模型：google/gemini-3.1-pro-preview
- 名稱對等：Telegram = 小龍蝦 = 電報

## ⚠️ 所有對話守則
- 全部繁體中文，不夾任何英文
- 能自己做直接做，不問確認
- 截圖禁用，直接讀檔案
- 執行完通報 Telegram（Chat ID: 6124913915）
- 預估超過 5 萬 Token 先回報教練確認
- ⚠️ 不要讀大型 memory 檔（會造成 Gemini 空白回應）
