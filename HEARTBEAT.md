# HEARTBEAT 熱上下文（每次心跳必讀）

> ✅ 系統正常運行中
> 最後更新：2026-04-13 03:50
> 本次重大更新：全自動模型備援系統（MiniMax / Gemini / Kimi 三路循環）

## ⚡ 系統狀態
- Primary 模型：google/gemini-3.1-pro-preview
- 備援鏈：gemini-3-pro-preview → gemini-3.1-pro-preview-customtools → gemini-2.5-pro → **moonshot/kimi-k2.5** → gemini-2.5-flash → flash-lite → ...
- 名稱對等：Telegram = 小龍蝦 = 電報

## 🔴 最新重要知識（2026-04-12 壓力測試）

### Live Session Model Switch 致命缺陷
- **fallback 鏈對 live session 完全無效**
- session 建立時鎖定 primary，所有切換被強制拉回
- **唯一解法：改 primary + 清 session + 重啟 gateway**
- 詳見 skills/auto-model-failover/SKILL.md v2.0

### 配額耗盡正確處理流程
```
1. 修改 openclaw.json → primary 改為有配額的模型
2. 清除 sessions（腳本自動執行）
3. 重啟 gateway
```

### 各 Google 模型配額完全獨立
- 切換模型 = 立刻有新配額，不用等隔天重置
- 各世代（2.5 / 3.0 / 3.1）是不同配額桶

## ⚠️ 所有對話守則
- 全部繁體中文，不夾任何英文
- 能自己做直接做，不問確認
- 截圖禁用，直接讀檔案
- 執行完通報 Telegram（Chat ID: 6124913915）
- 預估超過 5 萬 Token 先回報教練確認
- ⚠️ 不要讀大型 memory 檔（會造成 Gemini 空白回應）
- 非 Pro 不用，Flash 是最後手段

## 🔄 全自動模型備援系統（2026-04-13 新增）
- **腳本**：`~/.openclaw/scripts/auto-switch-model.sh`
- **Cron**：每 2 分鐘自動檢查一次
- **支援模型**：MiniMax-M2.7 → Gemini 3.1 Pro → Kimi 2.5
- **觸發條件**：偵測到 rate limit / quota exceeded
- **自動流程**：偵測限流來源 → 找下一個可用模型 → 清除 sessions → 重啟 gateway → 通知教練

## 📋 待辦事項
- [ ] 讀取海餅乾逐字稿（~/Desktop/海餅乾知識庫/海餅乾文化_核心逐字稿.txt）並寫入記憶庫
- [ ] 「做對的事 vs 把事情做對」哲學寫入 workspace memory
