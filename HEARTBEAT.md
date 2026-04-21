# HEARTBEAT 熱上下文（每次心跳必讀）

> ⚠️ 剛剛因 Context Overflow（對話太長）自動重啟
> 重啟時間：2026-04-22 01:26
> 對話記錄已完整存入 memory/2026-04-22.md 並推上 GitHub，零遺漏

## 🔴 重啟後第一件事

直接告訴教練：「🦞 對話記錄已滿，已自動重啟，請繼續下指令」
⚠️ **不要讀 memory 大檔**（memory/2026-04-22.md 可能超過 50KB，讀了會造成 Gemini 空白回應）

---

## 🎯 當前主要任務（2026-04-22 更新）

### 結論：VPS 的 TTS 和圖片生成 API 都通 ✅

| 功能 | API 狀態 | 問題所在 |
|---|---|---|
| TTS | ✅ success | VPS OpenClaw 的 `messages.tts` 設定是空的，**沒接上** |
| 圖片生成 | ✅ success | 同左，OpenClaw 沒對接 |

### ⚠️ 重要認知
- **不是 VPS 的問題**，VPS 那邊 API 完全正常
- **問題在我們這邊**：OpenClaw 的設定沒有對接上這兩個功能
- **你現在的工作**：想辦法把 TTS 和圖片生成接進 OpenClaw

### 下一步行動
1. 找到 OpenClaw 的 TTS 設定位置（`messages.tts` 相關設定）
2. 填入正確的 VPS API 端點與參數
3. 同樣處理圖片生成的對接
4. 測試確認兩個功能都能正常運作

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
