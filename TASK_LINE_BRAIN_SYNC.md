# TASK_LINE_BRAIN_SYNC.md — 終端機接手任務單

> 建立時間：2026-05-01
> 說明：LINE_SOUL.md 和 LINE_CORE_RULES.md 已建立完成，終端機執行以下步驟完成同步

---

## 已完成（不需重做）

- [x] `LINE_SOUL.md` 已建立於 `workspace/LINE_SOUL.md`
- [x] `LINE_CORE_RULES.md` 已建立於 `workspace/LINE_CORE_RULES.md`
- [x] `LINE_MASTER_GUIDE.md` 已建立於 `workspace/LINE_MASTER_GUIDE.md`

---

## 架構說明（執行前必讀）

LINE 頻道與 Telegram 共用同一個 1號機 instance 和 workspace。
LINE_SOUL.md **不是**直接取代 SOUL.md，而是：
1. 供 LINE 頻道讀取的專屬規則參考檔
2. 未來若 LINE 獨立為另一 agent 時直接使用

**目前需要做的事**：確認 TEAM_IDENTITY.md 裡的 LINE 媒體鐵律是否仍是最新版本，若有更新則同步進去。

---

## 步驟一：Git commit + push

```bash
cd /Users/bymyway/.openclaw/workspace
git add LINE_SOUL.md LINE_CORE_RULES.md LINE_MASTER_GUIDE.md TASK_LINE_BRAIN_SYNC.md
git commit -m "add: LINE 版 SOUL/CORE_RULES/MASTER_GUIDE 建立

- LINE_SOUL.md：LINE 版靈魂核心（含兩俱樂部原文 + LINE 角色定位）
- LINE_CORE_RULES.md：LINE 版 12 條守則（含媒體 HTTPS 鐵律）
- LINE_MASTER_GUIDE.md：散錄資料彙整（架構/設定/歷史/待辦）

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
git push origin main
```

---

## 步驟二：確認 TEAM_IDENTITY.md 的 LINE 媒體鐵律是最新版本

```bash
# 確認媒體路徑轉換規則是否完整
grep -A 5 "媒體傳送" /Users/bymyway/.openclaw/workspace/TEAM_IDENTITY.md
```

預期看到：`/Users/bymyway/.openclaw/media/` → `https://media.bymyway.com/`

若沒有，執行步驟二補充（否則跳過）：
在 TEAM_IDENTITY.md 的 LINE 媒體區塊確認以下規則存在：
```
/Users/bymyway/.openclaw/media/ → https://media.bymyway.com/
~/.openclaw/media/ → https://media.bymyway.com/
```

---

## 步驟三：（選做）確認 LINE Webhook 仍正常運作

```bash
# 確認 gateway 正在運行
curl -s --connect-timeout 3 localhost:18789

# 確認 LINE webhook 路由存在
curl -s --connect-timeout 3 localhost:18789/line/webhook -X POST \
  -H "Content-Type: application/json" \
  -d '{"events":[]}' | head -20
```

---

## 完成後回報格式

```
✅ LINE 大腦文件同步完成
- LINE_SOUL.md：已推上 GitHub ✅
- LINE_CORE_RULES.md：已推上 GitHub ✅
- LINE_MASTER_GUIDE.md：已推上 GitHub ✅
- TEAM_IDENTITY.md 媒體鐵律：已確認 ✅
- Commit Hash：[填入]
```
