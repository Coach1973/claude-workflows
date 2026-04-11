---
name: session-wrap
description: 對話結束前的總結技能。自動整理本次完成的任務、犯過的錯、繞過的彎，寫入記憶系統，確保下次對話有完整背景。
triggers:
  - "/session-wrap"
  - "對話總結"
  - "結束這次對話"
  - "幫我做個總結"
---

# Session Wrap 技能

每次對話結束前執行，確保知識不流失。

## 執行步驟

### Step 1：讀取現有記憶
讀取 `C:\Users\bymyw\.claude\projects\E--\memory\MEMORY.md` 和 `feedback_lessons_learned.md`，了解目前已記錄的內容。

### Step 2：回顧本次對話，整理以下四類資訊

**A. 完成的任務**（更新對應的 project_*.md）
- 新建立的腳本、設定、帳號連接
- 具體路徑、帳號名稱、設定值都要寫清楚

**B. 犯過的錯與修正**（追加到 feedback_lessons_learned.md）
格式：
```
| 錯誤描述 | 正確做法 |
```

**C. 繞過的彎**（追加到 feedback_lessons_learned.md）
- 走錯方向後重做的部分
- 原因是什麼、怎麼修正的

**D. 新確立的原則**（追加到 feedback_lessons_learned.md）
- 這次對話中確認「以後應該這樣做」的規則

### Step 3：更新 MEMORY.md 索引
- 確認所有新增的 memory 檔案都有對應的索引行
- 修正索引中已過時的描述（如數字、路徑、發送管道等）

### Step 4：輸出本次總結給用戶確認
用清單格式呈現：
```
## 本次對話總結

### 完成的事
- ...

### 犯的錯 & 修正
- ...

### 下次注意
- ...

### 記憶已更新
- 修改：xxx.md
- 新增：xxx.md
```

### Step 5：備份記憶與技能到 E 槽
執行備份腳本，確保記憶和技能在 C 槽還原後仍然存在：
```
powershell -ExecutionPolicy Bypass -File "E:\Claude-Data\scripts\backup_memory.ps1"
```
這會將 memory\ 和 skills\ 同步到 `E:\Claude-Data\memory-backup\` 和 `E:\Claude-Data\skills-backup\`。

### Step 6：提醒用戶
告知可以關閉此對話框，新對話框說「開始工作囉」即可繼續。

---

## 注意事項
- 記憶要具體，不能只寫「已完成」，要寫路徑、帳號、設定值
- 錯誤要寫清楚「為什麼會犯這個錯」，下次才能真正避免
- 數字類資訊（頻道數、token 數）要確認後才寫，不能靠印象
