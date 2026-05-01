# LINE 群組身份問題根因與修復

> 建立時間：2026-05-01
> 建立者：終端機助教（Claude CLI）
> 最後更新：2026-05-01

---

## 問題現象

LINE 群組中，Bot 被用戶錯誤貼上標籤（如「你是佩佩老師的助理吧？」），Bot 就順著自我介紹，聲稱自己是 3 號機（學妹）/ 佩佩老師的助理。

---

## 根本原因

`~/.openclaw/hooks/group-identity/handler.js` 在 LINE 群組 session 觸發時：
1. **只注入了「小龍蝦是誰」**（學長/學弟/學妹）
2. **沒有注入「群組裡每個人是誰」**

導致 LLM 只能從對話內容猜測身份，用戶先貼標籤後，Bot 就順著說。

---

## 修復方式

在 `handler.js` 中加入 LINE session 偵測：

```javascript
function isLineGroupSession(event) {
  const sessionKey = (event && event.sessionKey) || (event && event.context && event.context.sessionKey) || '';
  return sessionKey.toLowerCase().includes('line:group');
}
```

當偵測到 `line:group` session 時，額外注入：
1. **LINE 群組成員身份說明**（大樹教練=訓練者，其他人=群组成员）
2. **LINE 版自我介紹鐵律**（「只說大樹教練的 LINE 特助，不引用 Telegram 機器人身份」）
3. **LINE_SOUL.md** 完整內容

---

## 修改的檔案

- `~/.openclaw/hooks/group-identity/handler.js`（已修改，timestamp: 18:50）
- Gateway 已重啟

---

## 預防措施

LINE 群組的成員身份是在 webhook 層級由 LINE 顯示名稱提供，不需要用户另外提供 LINE ID。
Bot 應該嚴格依照顯示名稱判斷是誰說話，「大樹教練」這個顯示名稱對應到「訓練者」角色，絕不認錯人。