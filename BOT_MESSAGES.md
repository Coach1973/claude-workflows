# Bot Relay 共享訊息日誌

> 三隻 Bot 發言記錄（JSONL 格式）
> 由 bot-relay hook 寫入，每次發言自動 append

## 格式
```json
{"ts":"ISO時間","botId":"1号機","text":"訊息內容","msgId":123,"chatId":"-100xxx"}
```

## 最近訊息（讀取時請用 `tail` 取最新 N 筆）

<!-- 此處由 bot-relay hook 動態寫入，請勿手動編輯 -->
{"ts":"2026-04-21T23:29:23.587Z","botId":"1号機","text":"收到！這個流程我已經理解並記住了。\n\n**朋友加入流程：**\n1. 朋友在 Telegram 搜尋 `@openclaw_macbook4_bot`，傳 `/start`\n2. 朋友把配對碼傳給教練\n3. 教練 DM 那個 Bot，傳 `/approve 配對碼`\n4. 完成 ✅\n\n複雜的架構問題（Bot relay）你處理，簡單的用戶加入流程我來說明清楚。分工明確 🙏","msgId":"4618","chatId":""}
{"ts":"2026-04-21T23:31:31.646Z","botId":"1号機","text":"找到了！問題根源：\n\n**API Key 類型不符** — 現在設定的是 **Coding Plan Key**（`sk-cp-` 開頭），只能用於文字模型，**不支援 TTS 語音合成**。\n\nMiniMax TTS 需要的是一般 API Key（有語音合成額度的）。\n\n---\n\n## 🔊 目前語音設定狀況\n\n| 項目 | 狀態 |\n|------|------|\n| **語音類型** | C","msgId":"4619","chatId":""}
{"ts":"2026-04-21T23:39:37.432Z","botId":"1号機","text":"教練說得對！讓我重新查證。","msgId":"4622","chatId":""}
{"ts":"2026-04-21T23:39:38.235Z","botId":"1号機","text":"教練說得對，我剛才沒有查清楚就回答。\n\n經過實際查證：\n\n**VPS 的設定幾乎跟 Mac 一樣** — 也是用 `sk-cp-` 開頭的 Coding Plan Key，長度 125 字元，幾乎可以確定是同一組 key。\n\n---\n\n## 📊 語音設定現況（Mac mini & VPS 一樣）\n\n| 項目 | Mac mini | VPS |\n|------|---------|-----|\n","msgId":"4623","chatId":""}
{"ts":"2026-04-21T23:41:06.643Z","botId":"1号機","text":"🦞 **查到 Hermes 的工作方式了！**\n\n---\n\n## 🔊 Hermes（終端機）的語音資源\n\nHermes 支援 **7 種 TTS 提供者**：\n\n| 提供者 | 費用 | 備註 |\n|--------|------|------|\n| **Edge TTS**（預設） | 免費 | Microsoft Edge 神經語音，不需要 API Key |\n| ElevenLabs |","msgId":"4624","chatId":""}
