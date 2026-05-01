# HEARTBEAT 熱上下文（每次心跳必讀）

> ⚠️ 剛剛因 Context Overflow（對話太長）自動重啟
> 重啟時間：2026-05-01 12:07
> 對話記錄已完整存入 memory/2026-05-01.md 並推上 GitHub，零遺漏

## 🔴 重啟後第一件事

直接告訴教練：「🦞 對話記錄已滿，已自動重啟，請繼續下指令」
⚠️ **不要讀 memory 大檔**（memory/2026-05-01.md 可能超過 50KB，讀了會造成 Gemini 空白回應）

## ⚡ 系統狀態
- Primary 模型：MiniMax M2.7（唯一指定，無教練授權不切換）
- 名稱對等：Telegram = 小龍蝦 = 電報

## ⚠️ 所有對話守則
- 全部繁體中文，不夾任何英文
- 能自己做直接做，不問確認
- 截圖禁用，直接讀檔案
- 執行完通報 Telegram（Chat ID: 6124913915）
- 預估超過 5 萬 Token 先回報教練確認
- ⚠️ 不要讀大型 memory 檔（會造成 Gemini 空白回應）

---

## 💓 心跳紀錄

| 時間 | 動作 | 結果 |
|------|------|------|
| 2026-05-01 12:35 | Gateway 健康檢查 | ✅ 200 OK |
| 2026-05-01 15:00 | 插件評估完成：memory-lancedb 跳過（需 OpenAI Key，現有 Hybrid 架構已足夠）；MASTER_PROMPT_TEMPLATE.md 建立；memory-lancedb-pro skill 安裝備用 | ✅ commit 904bcd3 |

| 2026-05-01 14:03 | 心跳-小前進 | ✅ Gateway 200 OK；HB.md 已廢止（歸 DAILY_DIGEST），心跳指引依 DAILY_DIGEST 執行 |
| 2026-05-01 15:03 | 心跳-小前進 | ✅ Gateway 200 OK；架構重構已完成（三機 cron 就緒）；催款/權利金/開發票三事需教練提供資料才能推進 |
| 2026-05-01 15:33 | 心跳-小前進 | ✅ Gateway 200 OK；HB.md 不存在（已廢止）；所有待辦均需教練提供資料，暫無可獨立推進項目 |
| 2026-05-01（下午，Claude對話）| 大腦工程+VPS同步準備 | ✅ CORE_RULES v2.4（R02語音糾偏通用升級）；VPS_SOUL.md+VPS_CORE_RULES.md建立；TASK_VPS_BRAIN_SYNC.md交接終端機；VPS_MASTER_GUIDE.md建立。終端機待執行：git push + SSH同步 + Gateway重啟。分工確立：Claude=設計，終端機=執行 |
