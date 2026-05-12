---
name: 指揮所考古報告 — relay 系統真相
description: 2026-05-08 考古完成，relay 系統實況與五大根因假設；明天「補缺階段」直接從這份開始
type: project
originSessionId: 3ef91e84-d39c-4b85-a6af-416598fead38
---
# 指揮所考古報告（2026-05-08 完成）

## 一、現有 relay 架構（真相）

**設計目的**：讓「三隻小龍蝦 bot」之間能互相觸發發言，外加讓小龍蝦呼叫終端機跑 Claude。
**範圍**：只覆蓋 Mac mini 上的程序，**完全沒有 Windows 軍師大腦的位置**。

### 三段式架構
```
教練 → 小龍蝦 Telegram → RELAY_QUEUE.json → relay_poll.py（cron 每 10 秒）→ claude --print
                                                              ↓
                                              terminal-notes/relay_output_YYYYMMDD.md
```

### 已實作的 task type
- `claude_exec`：執行 `claude --print "prompt"`，輸出寫入 relay_output 檔
- 其他 type：尚未實作

### 關鍵檔案位置（Mac 端）
- 佇列：`/Users/bymyway/.openclaw/workspace/shared-context/RELAY_QUEUE.json`
- 寫入腳本：`scripts/relay_submit.py`
- 輪詢腳本：`scripts/relay_poll.py`
- 一鍵呼叫：`scripts/relay_claude_task.sh "任務"`
- 輸出：`terminal-notes/relay_output.md` + 每日檔 `relay_output_YYYYMMDD.md`

---

## 二、時間軸（從檔案 mtime + 文件內容推出）

| 日期 | 事件 |
|------|------|
| 2026-04-25 | TASK_SHARED_QUEUE_RELAY.md 設計稿建立，目的是三隻小龍蝦互相觸發 |
| 2026-04-30 | relay_submit.py / relay_poll.py 實作完成 |
| 2026-05-05 | 擴展到「小龍蝦呼叫終端機跑 Claude」，寫了 USER_GUIDE 和 SETUP |
| 2026-05-05 16:54 | **第一次成功測試**（test-001：「讀 HEARTBEAT.md 用一句話告訴我」） |
| 2026-05-05 19:50 | 連續三次測試都通 |
| 2026-05-06 17:52 | CLAUDE.md、RELAY_QUEUE.json、CLIENT_PROFILE.md 最後更新 |
| **5/6 之後** | **沒有新檔、沒有新測試記錄、教練仍在當人肉搬運工** |

---

## 三、五大根因假設（為什麼系統沒持續運轉）

### 假設 A：架構少了軍師大腦這條路徑（最強假設）⭐
- relay 只覆蓋「三小龍蝦 + 終端機」，**Windows 軍師完全在 loop 外**
- 教練的真實工作流：軍師寫指令 → 教練手貼到終端機
- 這條路徑 relay 根本沒設計到，所以 relay 跑通了也救不了主要痛點

### 假設 B：是單向不是雙向
- 現有：「小龍蝦 → 終端機」單向
- 缺：「終端機 → 軍師審查 → 小龍蝦回報」反饋路徑
- 教練要的不是叫終端機跑東西，是「AI 之間互相對話」

### 假設 C：cron job 可能沒實際在跑
- SETUP.md 寫了 cron 範例，但沒記錄是否真的設了
- 如果 cron 沒跑、輪詢就停，整個系統死掉
- **明天要先驗證這個**：去 Mac 端看 cron 設定

### 假設 D：沒跨機器
- 所有路徑都是 `/Users/bymyway/...`，純 Mac
- Windows 軍師連不到 RELAY_QUEUE.json
- 沒有 GitHub/SSH 跨機通道

### 假設 E：沒嵌進日常 workflow
- 教練的日常還是「在 Telegram 跟學長講 → 學長轉給軍師 → ...」
- relay 是備胎不是主動脈
- 教練可能根本沒養成「先丟到 RELAY_QUEUE」的習慣

---

## 四、明天「補缺階段」的工作清單

按優先順序：

### 第 1 步：先驗證假設 C（最便宜，最關鍵）
寫一份指令給 Mac 終端機，驗證：
- Mac 上的 cron 有沒有在跑 relay_poll？
- RELAY_QUEUE.json 最後一次被修改是何時？
- 用 `relay_claude_task.sh "ping"` 跑一次，看現在還通不通

### 第 2 步：補軍師大腦的位置
寫一份提案：軍師（Windows）如何寫進 RELAY_QUEUE.json？三條路：
- A) 透過 GitHub repo（軍師 push、Mac pull cron 自動拉）
- B) 透過 SSH 直連 Mac 寫檔
- C) 透過小龍蝦 Telegram 中繼

每條路的優缺點，給教練選。

### 第 3 步：擴展 task type（從假設 B 補缺）
- `military_advisor_review`：軍師審指令
- `desktop_claude_plan`：桌面版規劃
- `terminal_exec`：終端機執行（已有 = claude_exec）
- `liaison_report`：小龍蝦回報教練

### 第 4 步：寫一份「端到端示範」
教練動一次嘴 → 走完整鏈路 → 回到教練
讓教練親眼看見「不用搬運工」是怎麼一回事。

---

## 五、明天絕對不要做的事

1. **不要重寫 relay_submit.py / relay_poll.py**——能用就改，不要重寫
2. **不要設計新的目錄結構**——沿用 `shared-context/` 和 `terminal-notes/`
3. **不要動 RELAY_QUEUE.json 的 schema**——只新增 task type，不改現有欄位
4. **不要寫長篇大論**——教練要看到的是「下一個動作」，不是「完美架構」

---

## 六、給教練的一句話總結

> **過去的人沒有失敗，他們只是搭了一半的橋。我們不是設計師，是接橋人。**
