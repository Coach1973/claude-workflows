🦞 健康檢查報告（19:30）

## ⚠️ 發現系統問題（需教練裁決）

**Telegram 傳送失敗（minimax-portal 模式）**
- 受影響任務：FB 生日祝福、海餅乾精神複習、19週年倒數/策劃提醒、YouTube 頻道掃描
- 錯誤訊息：`Telegram bot token missing for account "default"`
- 分析：任務本身執行成功，但使用 minimax-portal provider 時，delivery 模組找不到 Telegram token（openclaw.json 已有 bot_main 設定，但 provider 卻找 "default" 帳號）
- 前天這些任務用 litellm provider 正常，明天 06:00 可能又會成功
- **需要裁決**：是否要將這些任務的 delivery 改回 litellm，或有其他修復方式？

✅ Git：無需 commit（僅有 tools/gogcli 為外部repo，不加入）

---

🦞 健康檢查報告（18:36）

✅ Git：已 commit + push（75e6daf）
✅ INSTALL_SOP.md：補足 MiniMax API Key 申請步驟（5 Steps）

## 🔴 重啟後第一件事

直接告訴教練：「🦞 對話記錄已滿，已自動重啟，請繼續下指令」
⚠️ **不要讀 memory 大檔**（memory/2026-04-26.md 可能超過 50KB，讀了會造成 Gemini 空白回應）

## ⚡ 系統狀態
- Primary 模型：google/gemini-3.1-pro-preview
- 名稱對等：Telegram = 小龍蝦 = 電報

## 心跳執行摘要（17:40）

- **任務**：頂級助教守則.md → 第二優先：Skills 建立
- **動作**：盤點現有 Skills，發現缺少「頂級特助安裝 SOP」
- **結果**：建立 `skills/onboarding_script/INSTALL_SOP.md` v0.1 草稿（2600字），涵蓋五階段安裝流程（OpenClaw安裝→Bot設定→身份設定→Git備份→多機連接）
- **下一步**：補充截圖說明、測試 SOP 是否可行、補充 MiniMax API Key 申請步驟
- **Commit Hash**：`48a7b72`

---

## 心跳執行摘要（17:07）

- **任務**：頂級助教守則.md 第二優先，第一章節
- **動作**：檢視現有守則，發現缺少「截圖禁用Token消耗」與「信件代發風險」兩條安全原則
- **結果**：已將兩條禁止條款加入第八章禁止條款表，commit hash: `c449946`
- **下一步**：可繼續檢查守則是否有其他遺漏，或推進第二章 Skills 建立

---

## 心跳執行摘要（19:07）

- **任務**：頂級助教守則.md → 第八章禁止條款補充
- **動作**：從 AGENTS.md 蒸餾出三條新禁止條款：拒絕承諾幻覺、零驗證負擔、一次找不到就停止
- **結果**：三條已加入第八章禁止條款表
- **下一步**：可繼續整合 SOUL.md 中的其他實踐原則，或推進第二章 Skills 建立
- **Commit Hash**：8479e9d

---

## ⚠️ 所有對話守則
- 全部繁體中文，不夾任何英文
- 能自己做直接做，不問確認
- 截圖禁用，直接讀檔案
- 執行完通報 Telegram（Chat ID: 6124913915）
- 預估超過 5 萬 Token 先回報教練確認
- ⚠️ 不要讀大型 memory 檔（會造成 Gemini 空白回應）
