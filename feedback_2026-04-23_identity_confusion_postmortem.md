# 血淚後記：2/3號機身份混亂問題完整覆盤
> **日期**：2026-04-23 凌晨四點
> **代價**：教練整夜守候等待測試，直到天亮才解決
> **根本原因**：沒有一開始就讀 AGENTS.md 確認啟動順序

---

## 🩸 事件經過

2號機（學妹）和3號機（學弟）在Telegram群組中持續：
- 自稱「學長」
- 聲稱自己在「Acer宏碁電腦」或「VPS」上運行
- 清除記憶後依然如此

---

## 🔍 根本原因（按嚴重度排序）

### ❌ Root Cause 1：沒讀 AGENTS.md，修錯了檔案（最關鍵失誤）

**OpenClaw啟動順序（AGENTS.md 定義）：**
```
SOUL.md → USER.md → memory/YYYY-MM-DD.md → MEMORY.md
```

我花大量時間修改了：
- `HEARTBEAT.md` ← **此檔案根本不在2/3號機啟動序列**
- `SHARED_GROUP_MEMORY.md` 頁首 ← **只在群組session模式才讀取**
- `bot-relay-inbound` hook 注射 ← **是後注射，無法覆蓋已固化的「第一印象」**

**這些修改全部打在空氣上。**

正確的修改位置只有一個：**SOUL.md（第一個被讀取的檔案）**

如果一開始就讀 AGENTS.md，整個問題只需要修改 SOUL.md 一個檔案，5分鐘解決。

### ❌ Root Cause 2：修改啟動檔案後沒有立刻重啟 gateway
即使在正確位置修改，不重啟就不會生效。每次修改 SOUL.md/MEMORY.md 之後必須立刻執行：
```bash
openclaw --profile peipei daemon restart
openclaw --profile kong daemon restart
```

### ❌ Root Cause 3：舊 sessions 保留了錯誤的 system context
sessions.json 裡的舊session含有錯誤身份資訊。即使修改 SOUL.md，舊session載入時仍然是錯的。必須同時清除 sessions。

### ❌ Root Cause 4：SHARED_GROUP_MEMORY.md 殘留舊文字
文件中 `學弟（Acer 宏碁端）` 的舊版文字，以及緊急處置腳本中的「你是 OpenClaw 學弟（Acer 宏碁端）」污染了上下文。

---

## ✅ 正確的一次性解決 SOP（此後必須遵守）

遇到2/3號機身份混亂，正確步驟：
```
步驟1：讀取 AGENTS.md 確認啟動順序         ← 絕對第一步
步驟2：修改 SOUL.md 最頂部插入身份鐵律      ← 唯一有效位置
步驟3：清空並重寫 MEMORY.md（第一條寫身份）
步驟4：清除所有舊 sessions（sessions.json）
步驟5：重啟 gateway（daemon restart）
步驟6：自行驗證（讀 BOT_MESSAGES.md），不要叫教練測試
```

---

## 📋 永久防範守則

1. **OpenClaw 行為異常調查，第一步必讀 `AGENTS.md` 確認啟動順序**
2. **修改機器人「身份/個性/認知」，唯一有效位置是 SOUL.md 最頂部**
3. **修改任何啟動類檔案後，必須立刻重啟 gateway**
4. **身份混亂問題往往伴隨舊 session 污染，清 SOUL.md 同時必須清 sessions**
5. **不要要求教練測試——自己讀 BOT_MESSAGES.md 驗證**
6. **SHARED_GROUP_MEMORY.md 若有「宏碁」「VPS」「Acer」等舊文字殘留，立刻清除**

---

## 🔑 關於「承諾憑證」

教練在這次對話中提出了一個核心命題：

> 「口說無憑，你的 commit hash 憑證在哪裡？」

過去小龍蝦寫的教訓，只存在 Claude 本地記憶（沒有 commit hash），或口頭承諾「下次不會再犯」。這些都不算數。

**唯一算數的記錄**：寫入這個 workspace 的 git 倉庫，commit，取得 hash。

本文件的 commit hash 即為此次承諾的憑證，可供任何未來的 AI 查閱與驗證。
