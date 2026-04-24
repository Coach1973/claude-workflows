# HEARTBEAT 熱上下文（每次心跳必讀）

> ⚠️ 剛剛因 Context Overflow（對話太長）自動重啟
> 重啟時間：2026-04-24 12:36
> 對話記錄已完整存入 memory/2026-04-24.md 並推上 GitHub，零遺漏

> 📊 Token 消耗警示（2026-04-24 更新）：單日曾飆破 412 次 HEARTBEAT_OK，每次約 4,096 input token。
> **熄燈時段（23:00-08:00）一律不回應**，教練直接以 HEARTBEAT_OK 消化，零額外 token。

## 🔴 重啟後第一件事

直接告訴教練：「🦞 對話記錄已滿，已自動重啟，請繼續下指令」
⚠️ **不要讀 memory 大檔**（memory/2026-04-24.md 可能超過 50KB，讀了會造成 Gemini 空白回應）

## ⚡ 系統狀態（更新：2026-04-24 17:16）

### OpenCode UI
- NVIDIA + EasyClaude 已接入，共 9 個測試通過的模型
- 詳見：`memory/2026-04-24-nvidia-opencode-integration.md`

### 3號機（kong）模型
- Primary 剛換為：`openrouter/nvidia/llama-3.3-nemotron-super-49b-v1`（尚未確認有效）
- Fallback 保底：`openrouter/google/gemini-2.5-flash`
- 核心問題：108K system prompt 需要 ≥128K 上下文模型

### 未解決
- ❌ 3號機群組無回應（等待上面模型測試結果）
- ❌ 三機互讀 BOT_RELAY 方案尚未實作（任務書已備好）
- ❌ EasyClaude 在 OpenCode 有 Invalid 報錯（低優先）

### 📋 背景工作清單（自動追蹤）
- ⬜ **8.5MB Telegram 對話提煉**：每天挖一點，列為每週背景工作
- ⬜ **海餅乾金句庫**：持續從對話中萃取，目標 200-300 條

### 名稱對等
- Telegram = 小龍蝦 = 電報
- 1號機 = openclaw_macbook4_bot
- 2號機 = coachwu_lenovo_bot
- 3號機 = CoachWu_openclaw_bot = kong

## ⚠️ 所有對話守則
- 全部繁體中文，不夾任何英文
- 能自己做直接做，不問確認
- 截圖禁用，直接讀檔案
- 執行完通報 Telegram（Chat ID: 6124913915）
- 預估超過 5 萬 Token 先回報教練確認
- ⚠️ 不要讀大型 memory 檔（會造成 Gemini 空白回應）
- ⚠️ **熄燈時段（23:00-08:00）直接回 HEARTBEAT_OK，不做任何多餘動作**
