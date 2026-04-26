# HEARTBEAT 熱上下文（每次心跳必讀）

> ⚠️ 剛才因 Context Overflow（對話太長）自動重啟
> 重啟時間：2026-04-26 12:49
> 對話記錄已完整存入 memory/2026-04-26.md 並推上 GitHub，零遺漏

## 🔴 重啟後第一件事

直接告訴教練：「🦞 對話記錄已滿，已自動重啟，請繼續下指令」
⚠️ **不要讀 memory 大檔**（memory/2026-04-26.md 可能超過 50KB，讀了會造成 Gemini 空白回應）

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

---

## 💓 心跳執行摘要

| 時間 | 做了什麼 |
|------|---------|
| 2026-04-26 13:03 | 🆕 建立 HB.md（心願驅動檔）+ 設定每15分鐘心跳任務 |
| 2026-04-26 13:36 | 🆕 安裝 ClawHub 技能：agent-group + agent-collab<br>📖 研究 agent-collab 三模式框架（Dispatch/Collaborate/Direct Chat）<br>🔗 更新 SUPERGROUP-MAP.md 整合協作框架參考

---
| 2026-04-26 13:45 | 🔴 發現系統問題：多個 cron jobs 處於 error 狀態<br>⚠️ 錯誤原因：「Telegram bot token missing for account 'default'」<br>📋 受影響任務：每4小時主動關懷、YouTube 頻道掃描、海餅乾精神每日複習、FB 每日生日祝福、19週年慶策劃提醒、每30分鐘任務健康檢查<br>🔍 根本原因：設定檔default帳號是「bot_main」但cron job可能使用「default」<br>💡 待確認：是否需要將cron jobs的target account改為「bot_main」

---

| 2026-04-26 14:15 | 🔍 調查發現：學弟/學妹 SOUL.md 背景資訊確實遺失<br>📁 學弟（kong）：只有基本暱稱，缺少「孔大哥與教練共同創辦海餅乾俱樂部」等背景<br>📁 學妹（peipei）：有佩佩老師自我介紹格式，但缺少「真愛分會200人目標」等深層背景<br>🔍 kong.bak 也無原始設定（只是通用 personality guide）<br>💡 教練曾在對話中說过這些資訊「不見了」，建議未來避免直接覆寫 SOUL.md
| 2026-04-26 14:53 | ✅ 心跳常規檢查<br>• 確認 cron jobs 全部正常運行（lastStatus: ok）<br>• 增量蒸餾：NO_NEW_ENTRIES<br>• 分工群：無新 subagent 進度<br>• 自動 commit 上傳（commit: d46ea8c）

---

## 🚀 目標心跳驅動系統（已啟用）

- **HB.md** 已建立：~/.openclaw/workspace/HB.md
- **心跳頻率**：每 15 分鐘自動戳一下
- **目標**：打造「讓零基礎老闆只要動嘴、AI 全自動執行」的頂級特助系統

---

## 📊 待觀察

- 心跳任務 ID：768246fb-0b1a-409a-985c-f7419954c29c
- 下一個心跳：15 分鐘後

---

## 🔧 健康檢查記錄（2026-04-26 14:41）

**發現並自動修復的問題：**

1. **根本原因**：6 個 cron jobs 沒有設定 `account` 欄位，gateway 嘗試使用不存在的 `default` 帳號，導致所有任務失敗
2. **錯誤訊息**：`Telegram bot token missing for account "default"`
3. **修復方式**：直接寫入 jobs.json，為每個 job 補上 `delivery.accountId: bot_main`，並清除 `consecutiveErrors` 計數

**已修復的任務：**
- Self Improvement Agent（每晚22:00）
- FB 每日生日祝福（每天06:00）
- 海餅乾精神每日複習（每天06:00）
- 19週年倒數計時（每天09:00）
- 19週年策劃提醒（每天10:00）
- YouTube頻道掃描（每天12:30）

**⚠️ 待觀察**：19週年倒數任務（89106297）為 systemEvent 類型，無法用 `cron edit` 修改，故直接編輯 jobs.json。未來新增 cron jobs 請務必指定 `--account bot_main`。