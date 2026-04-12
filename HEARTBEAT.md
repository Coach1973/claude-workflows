# HEARTBEAT 熱上下文（每次心跳必讀）

> 更新時間：2026-04-12 22:50
> 狀態：Google API 週配額已耗盡，已切換備援模型，系統正常運作中

## 🔴 重啟後第一件事

直接告訴教練：「🦞 系統正常，目前使用備援模型 Groq，Google 配額耗盡中（明天重置）」

## ⚡ 系統狀態（重要！）

- **現在 Primary 模型：groq/llama-3.3-70b-versatile**（備援模式）
- Google 配額已耗盡，暫時停用 Google 系列模型當 primary
- Google 配額重置後，把 primary 改回 google/gemini-3.1-pro-preview
- 名稱對等：Telegram = 小龍蝦 = 電報

## ⚠️ 重大 Bug 紀錄（今日壓力測試發現）

**Live Session Model Switch 致命缺陷：**
- OpenClaw 的 fallback 鏈只對「新 session 啟動時刻」有效
- live session 存活期間，所有跨 provider 的 fallback 都被強制切回原始 primary
- 結果：12 條備援在 live session 中全部無效
- 修復方式：**配額耗盡時，必須改 primary + 清 session + 重啟**（不能只靠 fallback 鏈）
- 完整記錄見：memory/feedback_live_session_model_switch_bug.md

## 🛠️ 待辦事項（未完成）

1. **治本修復**：在 auto-fix-session-lock.sh 加入「偵測 Google 429 quota → 自動改 primary → 清 session → 重啟」邏輯
2. **每日復原 cron**：配額重置後自動把 primary 換回 gemini-3.1-pro-preview
3. **海餅乾逐字稿**：尚未完成寫入記憶庫（待下次對話繼續）

## ⚠️ 所有對話守則
- 全部繁體中文，不夾任何英文
- 能自己做直接做，不問確認
- 截圖禁用，直接讀檔案
- 執行完通報 Telegram（Chat ID: 6124913915）
- 預估超過 5 萬 Token 先回報教練確認
- ⚠️ 不要讀大型 memory 檔（會造成 Gemini 空白回應）
