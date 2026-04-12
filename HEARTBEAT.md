# HEARTBEAT 熱上下文（每次心跳必讀）

> ✅ 系統正常運行中
> 最後更新：2026-04-13 06:00
> **SOUL.md v2.0 完成（海餅乾靈魂深度內化版）**

## ⚡ 系統狀態
- **Primary 模型**：minimax-portal/MiniMax-M2.7 ✅（Token Plan OAuth）
- **備援鏈**：google/gemini-3.1-pro-preview → moonshot/kimi-k2.5 → Gemini Flash

## 🔑 今天發生的重大事件

### MiniMax Token Plan 接入成功（05:33）
- 找到了官方文件：https://platform.minimax.io/docs/token-plan/openclaw
- 修改設定：baseUrl 從 `/anthropic` 改為 `/v1`，api 從 `anthropic-messages` 改為 `openai-completions`
- 重啟 gateway 後 MiniMax-M2.7 成功運行
- **驗證：教練的 88 美金 Token Plan 可以接入 OpenClaw**

### Claude 助教的錯誤資訊
- Claude 之前說「需要開發者 API 錢包」是錯誤的
- 實際：Token Plan + OAuth 就可以接入 MiniMax-M2.7
- 文件證據：Prerequisites 明確寫「A MiniMax Token Plan subscription」

## ⚠️ 所有對話守則
- 全部繁體中文，不夾任何英文
- 能自己做直接做，不問確認
- 截圖禁用，直接讀檔案
- 執行完通報 Telegram（Chat ID: 6124913915）
- 預估超過 5 萬 Token 先回報教練確認
- ⚠️ 不要讀大型 memory 檔（會造成空白回應）

## 📋 待辦事項
- [ ] 讀取海餅乾逐字稿並寫入記憶庫（拖延中）
- [ ] 「做對的事 vs 把事情做對」哲學寫入 workspace memory
- [ ] YouTube 31 頻道監測排程（腳本完成，待設 cron）
- [ ] 兩天後（4/15）重新評估是否啟用自動模型備援檢查

## 🗓️ 教練近期提醒
- 4/14 10:55 信用卡帳單提醒（聯邦銀行，$143,078，截止日 4/18）
- 4/14 22:00 銷售會議提醒
- 5/14 海餅乾 19 週年慶
