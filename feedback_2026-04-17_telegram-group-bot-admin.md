# Telegram 群組 Bot 無回應：隱私模式踩坑紀錄

日期：2026-04-17
來源：大樹教練 Claude 助教（主工作階段）

---

## 問題描述

為佩佩老師建立 Telegram 群組「佩佩老師的小龍蝦助理」後，
Bot (@coachwu_lenovo_bot) 在群組中完全沒有回應，
即使明確用 @username 提及也沒有反應。

## 排查過程（走了很多冤枉路）

以下是**無效**的排查方向，不要再重複：
- ❌ 改 `requireMention: false` → 不是問題所在
- ❌ 重啟 OpenClaw process → 不是問題所在
- ❌ 檢查 Kimi API 是否正常 → API 正常，不是問題
- ❌ 檢查 getUpdates pending count → 顯示 0，誤判為「有收到訊息」
- ❌ 懷疑 polling 卡死 → 實際上是根本沒有讀取訊息的權限

## 根本原因

**Telegram Bot 的「群組隱私模式」（Group Privacy Mode）**

Telegram bot 預設在群組中只能讀取：
1. 以 `/` 開頭的指令
2. 明確 @mention bot 的訊息（但也不保證，視設定而定）

在群組成員資訊頁面會顯示：
> 「佩佩老師的特助 — 沒有存取訊息權限」

Bot 確實在群組中，也確實消耗了 getUpdates，但訊息內容被過濾掉，根本看不到。

## 解決方法

**把 Bot 設為群組管理員（Admin）**

管理員擁有完整訊息讀取權，可繞過隱私模式限制。

操作步驟（Telegram Desktop）：
1. 進入群組 → 右上角「...」→「資訊」
2. 點「編輯」→「管理員」→「新增管理員」
3. 選擇 Bot → 儲存（保留預設權限即可）

## 未來建立新群組的 SOP

每次為新用戶建立「XXX 的小龍蝦助理」群組後，**必須立刻執行**：
1. ✅ 加用戶 Telegram ID 到 `allowFrom`
2. ✅ 建立群組（教練 + 用戶 + Bot）
3. ✅ **把 Bot 設為群組管理員** ← 這步不能漏！

## 備注

- DM（私訊）模式不受此限制影響，Bot 在 DM 中一直正常運作
- 在群組中把 Bot 設為管理員不會影響任何 OpenClaw 設定
- `requireMention: false` 在 Bot 有讀取權限後才真正生效

