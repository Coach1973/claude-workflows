# 身份修復完整報告
> 撰寫時間：2026-04-26
> 執行者：Claude 助教（本次 session）

---

## 問題描述

三隻 bot 在 Telegram 群組與私訊中，2號（bot_kong）和 3號（bot_peipei）都自稱是「學長（1號機）」，身份完全錯誤。

---

## 第一輪修改（前一個 session，昨天下午）

### 修改內容
1. **`group-identity/handler.js`** — 原本用 `hostname.includes('mac')` 判斷身份（三台機器都在同一台 Mac，所以全部都說自己是學長）。改為用 `agentId` 對照 `IDENTITY_MAP`。
2. **`openclaw.json`** — 補上缺失的 `hooks.internal.entries` 區塊（之前被 gateway 覆蓋掉了）。
3. **`handler.ts`** — 發現 `handler.ts` 和 `handler.js` 並存，gateway 優先讀 `.ts` 但 `.ts` 用 ES module 語法導致靜默失敗。將 `handler.ts` 改名為 `handler.ts.bak`。

### 結果
昨天下午修完後，1號=學長、2號=學弟、3號=學妹，個別問和群組問都正確。

---

## 第二輪問題（本次 session，今天）

### 症狀
- 私訊 bot_kong → 回答「我是學長（1號機）」❌
- 私訊 bot_peipei → 回答「我是學長（1號機）」❌
- 群組訊息 → 完全沒有回應（已讀不回）

### 調查過程

#### 調查 1：config-health 自動還原？
`config-health.json` 顯示 `size-drop-vs-last-good:6818->3367`，懷疑 gateway 自動還原舊備份。
**結論：誤判。** 閱讀 `io-5pxHCi7V.js` 原始碼後確認，自動還原只在 config 格式為 `{"update":{"channel":"..."}}` 時才觸發，我們的 config 不符合，所以沒有被還原。

#### 調查 2：hook 注入目標錯誤？
發現 hook 原本寫入 `event.context.inject`，但 `applyBootstrapHookOverrides` 只讀 `event.context.bootstrapFiles`。
**已修復：** 改為寫入 `event.context.bootstrapFiles`（unshift 一個帶 content 的物件）。

#### 調查 3：isGroupSession 判斷失敗？
hook 的 `isGroupSession()` 原本讀 `ctx.chatType`、`ctx.chatId` 等欄位，但這些欄位在 `agent:bootstrap` 事件中根本不存在。
**已修復：** 改為解析 `event.sessionKey`，找 "group"/"supergroup"/"channel" 字段。

#### 調查 4：找到真正根本原因 ✅

閱讀 `group-identity-debug.log`，發現：
```
sessionKey=agent:main:telegram:bot_peipei:direct:6124913915 ctx.agentId=main
sessionKey=agent:main:telegram:bot_kong:direct:6124913915   ctx.agentId=main
```

**關鍵發現：所有私訊都路由到 `main` agent！**

原因：`openclaw.json` 的 bindings 只有群組規則（`peer.kind=group, peer.id=-1003877502911`），沒有私訊規則。私訊找不到 binding → fallback 到預設 `main` agent → 讀 main 的 SOUL.md → 說自己是學長。

---

## 最終修復（本次 session）

### 修改 1：`openclaw.json` 新增 DM bindings

```json
{
  "agentId": "kong",
  "match": {
    "channel": "telegram",
    "accountId": "bot_kong"
  }
},
{
  "agentId": "peipei",
  "match": {
    "channel": "telegram",
    "accountId": "bot_peipei"
  }
}
```

這兩條規則沒有 `peer` 限制，會匹配所有來自 bot_kong/bot_peipei 的訊息（包含私訊）。群組訊息因為有更精確的 peer binding，仍然優先匹配群組規則。

### 修改 2：刪除舊的錯誤 DM sessions

從 `~/.openclaw/agents/main/sessions/sessions.json` 刪除：
- `agent:main:telegram:bot_kong:direct:6124913915`
- `agent:main:telegram:bot_peipei:direct:6124913915`

這樣下次私訊時會建立新 session，觸發 bootstrap，讀到正確 agent 的 SOUL.md。

### 修改 3：重啟 gateway

Gateway 熱重載偵測到 bindings 變更並套用。

---

## 修復後的路由邏輯

| 訊息來源 | 路由到 | 讀取的 SOUL.md | 身份 |
|---------|--------|---------------|------|
| 私訊 bot_main | main agent | `~/.openclaw/workspace/SOUL.md` | 學長 ✓ |
| 私訊 bot_kong | kong agent | `~/.openclaw/agents/kong/SOUL.md` | 學弟 ✓ |
| 私訊 bot_peipei | peipei agent | `~/.openclaw/agents/peipei/SOUL.md` | 學妹 ✓ |
| 群組 bot_main | main agent | + GROUP_IDENTITY hook | 學長 ✓ |
| 群組 bot_kong | kong agent | + GROUP_IDENTITY hook | 學弟 ✓ |
| 群組 bot_peipei | peipei agent | + GROUP_IDENTITY hook | 學妹 ✓ |

---

## 待驗證

下一台終端機接手後，請：
1. 私訊 bot_kong 問「你是誰？」→ 應回答學弟（2號機）
2. 私訊 bot_peipei 問「你是誰？」→ 應回答學妹（3號機）
3. 群組問三隻 bot → 各自回答正確身份

如果仍有問題，檢查：
- `~/.openclaw/logs/group-identity-debug.log` — 看 agentId 是否正確
- `~/.openclaw/agents/main/sessions/sessions.json` — 看 session key 是否包含 bot_kong/bot_peipei

---

## 關鍵檔案位置

- Hook 主程式：`~/.openclaw/hooks/group-identity/handler.js`
- 設定檔：`~/.openclaw/openclaw.json`
- 主 agent sessions：`~/.openclaw/agents/main/sessions/sessions.json`
- Kong agent workspace：`~/.openclaw/agents/kong/`
- Peipei agent workspace：`~/.openclaw/agents/peipei/`
- Debug log：`~/.openclaw/logs/group-identity-debug.log`
- Gateway log：`~/.openclaw/logs/gateway.log`
