# HEARTBEAT 熱上下文（每次心跳必讀）

> 📌 2026-04-25 20:00 更新

## 🔴 當前狀態

### ✅ 模型鐵律確認（2026-04-25）
- 三臺機器（1/2/3號機）全部統一使用 **MiniMax M2.7 為唯一模型**
- 不再有 GPT / Claude / Gemini fallback
- 已寫入 MEMORY.md

### ✅ 三機互讀 BOT_RELAY 任務告一段落
- 3號機（孔大哥）狀態解除
- 三機溝通機制已穩定

### ✅ NVIDIA API Key 接入 OpenCode（2026-04-24 對話記錄提煉）
- Key: `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`
- OpenCode 設定檔：`~/.config/opencode/opencode.jsonc`（14 個可選模型）
- macOS 終端機：`~/.zshrc` 已寫入 `nvidia` / `nvidia-code` / `nvidia-think` 指令
- HTTP 200 可用模型：`meta/llama-3.3-70b-instruct`、`qwen/qwen3-next-80b-a3b-thinking`（推薦推理）、
  `moonshotai/kimi-k2-thinking`、`deepseek-ai/deepseek-v3.2`、`qwen/qwen2.5-coder-32b-instruct`
- 404 無法使用：Nemotron Ultra 253B（需特殊帳號授權）、Mistral Large 2
- 注意：OpenCode 內 Kimi K2 Thinking 目前走 NVIDIA Key，非教練自費的 Kimi Key（兩者相同，無需額外付費）

### 📋 8.5MB 對話萃取進度

**實際規模（2026-04-25 修正）：**
- 原始檔：8.5MB / 3,710 筆訊息
- 實際文字量：55-56 萬字（教練提醒：非 200萬，之前說法錯誤）
- 純中文內容約 55 萬字

**已完成：**
- `seabiscuit_golden_quotes.md` — 108KB 金句庫
- `seabiscuit_ideas_backlog.md` — 132KB 創意待辦
- `seabiscuit_case_studies.md` — 12KB 案例研究
- `memory/2026-04-24.md` — 239KB / 5588行對話流水

**尚未完成：**
- ⬜ 尚未建立每日自動萃取流程
- ⬜ 尚未將萃取結果結構化輸出（如：教練可讀的日/週報）

### 📋 背景工作清單
- ⬜ **8.5MB 對話提煉**：已萃取出三大文件，待建立自動化流程
- ⬜ **海餅乾金句庫**：持續從對話中萃取，目標 200-300 條

## ⚠️ 所有對話守則
- 全部繁體中文，不夾任何英文
- 能自己做直接做，不問確認
- 截圖禁用，直接讀檔案
- 執行完通報 Telegram（Chat ID: 6124913915）
- 預估超過 5 萬 Token 先回報教練確認
- ⚠️ **熄燈時段（23:00-08:00）直接回 HEARTBEAT_OK，不做任何多餘動作**
