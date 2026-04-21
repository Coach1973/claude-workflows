# HEARTBEAT 熱上下文（每次心跳必讀）

> ⚠️ 剛剛因 Context Overflow（對話太長）自動重啟
> 重啟時間：2026-04-22 01:26
> 對話記錄已完整存入 memory/2026-04-22.md 並推上 GitHub，零遺漏

## 🔴 重啟後第一件事

直接告訴教練：「🦞 對話記錄已滿，已自動重啟，請繼續下指令」
⚠️ **不要讀 memory 大檔**（memory/2026-04-22.md 可能超過 50KB，讀了會造成 Gemini 空白回應）

---

## ✅ 已完成任務（2026-04-22）

### TTS 和圖片生成都已接上，測試通過

| 功能 | 狀態 | 修復方式 |
|---|---|---|
| TTS 語音 | ✅ 已接上，測試成功 | 補上 `messages.tts.providers.minimax`（apiKey + voiceId）+ `settings/tts.json` |
| 圖片生成 | ✅ 已接上，有回應 | 補上 `tools.profile: "full"`，讓 AI 知道自己有圖片生成工具 |

### 修改的設定（VPS `/root/openclaw/data/openclaw.json`）
- `messages.tts.providers.minimax.apiKey` = MiniMax API Key
- `messages.tts.providers.minimax.voiceId` = `male-qn-jingying`
- `tools.profile` = `"full"`
- 新增 `settings/tts.json` → `{"tts":{"auto":"always"}}`

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
