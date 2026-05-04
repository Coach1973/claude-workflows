# 終端機指令：讀取 Telegram 全量歷史對話

## 任務目標
讀取 `.openclaw/workspace/memory/` 內**所有日期**的對話紀錄（YYYY-MM-DD.md），不只今天，否則歷史對話全部漏掉。

## 操作步驟

### 第一步：確認有多少天的紀錄
```bash
ls /Users/bymyway/.openclaw/workspace/memory/*.md | grep -E "^[0-9]{4}-[0-9]{2}-[0-9]{2}" | wc -l
```
或直接：
```bash
ls /Users/bymyway/.openclaw/workspace/memory/2026-0*.md /Users/bymyway/.openclaw/workspace/memory/2026-04-*.md /Users/bymyway/.openclaw/workspace/memory/2026-05-*.md
```

### 第二步：從最早日期依序讀到今天
對話格式（每個檔案結構相同）：

**教練訊息**辨識方式：
```
👤 教練："chat_id": "telegram:6124913915",
```
下一個 `🦞 小龍蝦：` 出現之前的所有文字 = 教練說的話

**小龍蝦回覆**辨識方式：
```
🦞 小龍蝦：[回覆內容]
```

### 第三步：場景提煉格式
每發現一個有價值的互動場景，寫入 `terminal-notes/distillation/cases/個案研究.md`，格式：
```
【場景 #XX】
日期：[來自檔案抬頭]
教練說：...
小龍蝦說：...
結論：...
價值標籤：[教學互動 / 幽默表達 / 疑難排除 / 價值觀展示 / ...]
```

### 第四步：讀完當天就寫，別等到全部讀完
每個 memory/ 檔案讀完馬上寫心得進 TERMINAL_LEARNINGS.md，不要累積。

### 第五步：Commit 憑證
當天進度完成後：
```bash
cd /Users/bymyway/.openclaw/workspace
git add terminal-notes/TERMINAL_LEARNINGS.md terminal-notes/distillation/cases/個案研究.md
git commit -m " distill: 讀取 Telegram 全量歷史 [日期] — 共 XX 個場景"
git push origin main
```

## 重點提醒
- **不是只讀今天**：memory/ 裡所有 YYYY-MM-DD.md 都要讀
- **不是只蒸餾場景**：讀的過程中任何有價值的發現，馬上寫 TERMINAL_LEARNINGS.md
- **commit hash = 唯一憑證**：說「讀完了」但沒 hash = 沒做

## 觸發暗號
「開工，先讀 Telegram 全量歷史」
