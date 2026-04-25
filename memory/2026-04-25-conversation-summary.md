# 對話進度總結（2026-04-25 對話框）

## 1. 發生了什麼事

教練在「頂級特助分工群」對話框中對 @openclaw_macbook4_bot、@CoachWu_openclaw_bot、@coachwu_lenovo_bot 三個 bot 宣布「本群一律禁用語音，立即執行」，引發一系列診斷和修復工作。

## 2. 解決了什麼問題

### 問題 A：TTS 語音功能未關閉
- **原因**：`openclaw.json` 沒有 `messages.tts` 設定，語音功能處於「未設定」狀態
- **解決**：執行 `openclaw config set messages.tts.enabled false`
- **結果**：寫入成功，gateway 已重啟生效

### 問題 B：三個 bot 在群組中出現 `not-allowed` 阻擋
- **原因**：`channels.telegram.accounts` 下的 `groupPolicy` 設定不正確，導致 bots 被群組訊息阻擋
- **解決**：在 `bot_main`、`bot_kong`、`bot_peipei` 三個帳號下，分別加入 `groupPolicy: "open"` 和 `groups: {"-1003877502911": {requireMention: true}}`
- **結果**：Logs 顯示從 `reason: "not-allowed"` 變成 `reason: "no-mention"`，代表 bot 已不再被 groupPolicy 阻擋

### 問題 C：教練身份確認規則
- **原因**：教練強調每次新對話都要知道「這就是大樹教練」
- **解決**：在 `~/.openclaw/workspace/USER.md` 中新增「教練身份確認（2026-04-25 新增）」區塊，寫入四條核心規則：
  1. 不要捏造資源
  2. 給可驗證的指令
  3. 區分「確定的」和「猜測的」
  4. 方案要可執行
- **結果**：已 commit 到 git：`6e8437e`

## 3. 目前狀態（處理到什麼階段）

### ✅ 已完成
- TTS 語音功能已停用（`messages.tts.enabled: false`）
- `groupPolicy not-allowed` 修復（三個 bot 都能正常接收群組訊息）
- 教練身份規則寫入 USER.md 並 commit
- SOUL.md 協作規則已寫入（main/kong/peipei 三個 SOUL.md 都已更新）

### 🔍 目前狀態
- Sessions 已成功建立（kong/peipei 不再是空的）
- 三個 bot 都在同一個 unified gateway 程序運行
- `requireMention: true` — 只有被 @ 到的 bot 才會回應
- `reason: "no-mention"` — 正常行為，代表 bot 收到了訊息但因為沒被 @ 所以不回

### ⚠️ 仍未解決（下一棒需要處理）
- **Bot 之間無法透過 Telegram 互相溝通**：當一個 bot 在群組發言，其他 bot 因為 `requireMention: true` 不會被觸發。Telegram 平臺限制 bot 無法接收其他 bot 的訊息。
- **解決方案方向**：透過 `sessions_spawn` / `sessions_send` 在同一個 gateway 程序內呼叫其他 agent（不是靠 Telegram 群組訊息）
- **選項 A**：把 `requireMention` 改成 `false`，代價是每次教練說話，三個 bot 都會同時回覆
- **選項 B**：維持 `requireMention: true`，讓 main 在收到教練指令時主動用 `sessions_spawn` 呼叫 kong/peipei

## 4. 關鍵設定值（供下一棒參考）

| 項目 | 值 |
|------|-----|
| 群組 ID | `-1003877502911` |
| main bot | `@openclaw_macbook4_bot` / `bot_main` |
| kong bot | `@CoachWu_openclaw_bot` / `bot_kong` |
| peipei bot | `@coachwu_lenovo_bot` / `bot_peipei` |
| Gateway config | `~/.openclaw/openclaw.json` |
| Gateway restart | `openclaw gateway restart` |
| TTS 停用 | `messages.tts.enabled: false` |

## 5. Git Commit 歷史（本對話框）

- `6e8437e` — Add coach identity confirmation and 4 core rules to USER.md

---

**下一棒教練的任務**：決定三個 bot 的協作模式（選項 A 或 B），然後執行修復。
