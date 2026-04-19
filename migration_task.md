# NotebookLM 雙向搬家任務
> 由 Claude 助教整合小龍蝦助教規格後產出
> 終端機助教請依序執行，不需教練居中傳話

---

## 執行前：先讀這些檔案建立背景（必做）

在開始任何任務之前，請先讀取以下檔案，了解完整的歷史背景與系統現況，讓你的判斷能力對齊 Claude 助教：

```
/Users/bymyway/.openclaw/workspace/HEARTBEAT.md
/Users/bymyway/.openclaw/workspace/memory/project_vps_isolation_and_ux_20260418.md
/Users/bymyway/.openclaw/workspace/memory/project_vps_day1_fullreport_20260419.md
/Users/bymyway/.openclaw/workspace/windows-memory/project_notebooklm_workflow.md
```

讀完後你會知道：
- 整個系統的架構與三助教分工
- notebooklm-py 工具的使用方式與已知問題
- 兩個 Google 帳號的定位與分類鐵則
- 今天已經做過哪些事、踩過哪些坑

背景建立完成後，再往下執行任務。

---

## 第一步：修復 Python 版本問題

notebooklm-py 需要 Python 3.10+，請用 Homebrew 的 3.11 重新安裝：

```bash
/opt/homebrew/bin/python3.11 -m pip install notebooklm-py --upgrade
```

安裝完成後，確認工具可用：

```bash
/opt/homebrew/bin/python3.11 -m notebooklm --help
```

若出現指令說明代表成功，繼續下一步。

---

## 第二步：切換帳號並列出筆記本清單

**大樹帳號（bymyway7 / profile: default）：**
```bash
/opt/homebrew/bin/python3.11 -m notebooklm login switch default
/opt/homebrew/bin/python3.11 -m notebooklm list
```

**海餅乾帳號（seabiscuitclub / profile: public）：**
```bash
/opt/homebrew/bin/python3.11 -m notebooklm login switch public
/opt/homebrew/bin/python3.11 -m notebooklm list
```

把兩邊的清單截圖或記下來，確認哪些筆記本在錯誤的帳號。

---

## 第三步：雙向搬家邏輯（小龍蝦助教確認規格）

### 分類鐵則
| 關鍵字 | 歸屬帳號 |
|--------|---------|
| BNI、分會、戰報、MSP、區域管理、真鑫、真愛、真誠 | 大樹帳號（default） |
| 海餅乾守則、香蕉隊、克服恐懼、AI賦能、心靈、個人品牌 | 海餅乾帳號（public） |

### 動作 A：大樹帳號 → 海餅乾帳號（個人品牌筆記本）
需搬移的筆記本（在 default 帳號但屬於個人品牌）：
- 《海餅乾守則》
- 《香蕉隊》
- 《克服恐懼》
- 《突破領導者心靈障礙》
- 《大樹教練的人才聚散哲學》
- 《五項原則》
- 《信不由你的節目整理》

### 動作 B：海餅乾帳號 → 大樹帳號（BNI 筆記本）
需搬移的筆記本（在 public 帳號但屬於 BNI）：
- 《真誠分會》
- 《BNI真愛分會》

---

## 第四步：執行搬移

每個筆記本的搬移流程：

```bash
# 1. 切到來源帳號，讀取內容
/opt/homebrew/bin/python3.11 -m notebooklm login switch [來源profile]
/opt/homebrew/bin/python3.11 -m notebooklm use [notebook_id]
/opt/homebrew/bin/python3.11 -m notebooklm source list

# 2. 切到目標帳號，建立新筆記本
/opt/homebrew/bin/python3.11 -m notebooklm login switch [目標profile]
/opt/homebrew/bin/python3.11 -m notebooklm create "筆記本名稱"

# 3. 加入來源（依 source list 的結果）
/opt/homebrew/bin/python3.11 -m notebooklm source add [來源內容]
```

---

## ⚠️ 安全鐵則（小龍蝦助教確認）

**絕對不刪除任何原本的筆記本。**

只做「複製到另一邊」，待教練肉眼確認兩邊內容完整後，才能考慮刪除。

---

## 回報格式

每完成一個筆記本搬移，請在終端機印出：
```
✅ 已複製：[筆記本名稱] → [目標帳號]
```

全部完成後回報：
```
搬家完成。請教練確認以下清單：[列出所有已搬移的筆記本]
```

---

## 錯誤處理機制

遇到任何錯誤，請將錯誤訊息寫入：
`/Users/bymyway/Desktop/migration_error.txt`

格式如下：
```
[時間] 執行步驟：第幾步
[時間] 錯誤訊息：（貼上完整錯誤）
[時間] 已執行的指令：（貼上那行指令）
```

寫完後繼續等待。**Claude 助教會自己去讀這個檔案、診斷問題、把修正方案更新回 migration_task.md。**
你不需要通知教練，也不需要等教練，只需要定期重讀 migration_task.md 看是否有新的修正指示。
