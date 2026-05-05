# 小龍蝦 Relay 使用手冊

> 建立日期：2026-05-05
> 目的：讓小龍蝦知道怎麼呼叫終端機（Claude Code）執行任務

---

## 一、三種呼叫方式

### 方式A：執行固定測試腳本
```bash
bash /Users/bymyway/.openclaw/workspace/scripts/relay_hello_test.sh
```
輸出：經典問答示範，驗證 relay 暢通

---

### 方式B：執行帶任務的自訂腳本（推薦）
```bash
bash /Users/bymyway/.openclaw/workspace/scripts/relay_claude_task.sh "任務內容"
```
範例：
```bash
bash /Users/bymyway/.openclaw/workspace/scripts/relay_claude_task.sh "幫我讀取 HEARTBEAT.md，告訴教練今天完成了什麼"
```
```bash
bash /Users/bymyway/.openclaw/workspace/scripts/relay_claude_task.sh "分析 scenes_master_v1.md，找出教練最常強調的核心價值"
```

---

### 方式C：直接呼叫 claude 執行一次任務
```bash
claude --print "任務內容" >> /Users/bymyway/.openclaw/workspace/terminal-notes/relay_output.md
```
適合在終端機助教自己執行任務時用。

---

## 二、輸出結果在哪裡找

**所有任務結果都存在這裡：**
```
terminal-notes/relay_output.md
```

格式：
```markdown
## [2026-05-05 17:20:28] 任務：你的任務描述

Claude 的輸出內容
---
```

---

## 三、小龍蝦應該如何回報給教練

### 標準流程：
1. 呼叫 relay 腳本
2. 等待完成（約幾秒到幾十秒）
3. 讀取 `relay_output.md` 的**最後一筆**
4. 把結果濃縮成一句話，傳回 Telegram 給教練

### 回報範例：
```
教練，任務完成。
Claude 說：「老闆只要動嘴，AI 全自動完成。」
```

### 複雜任務的回報範例：
```
教練，已執行完畢。
要点：1) HEARTBEAT.md 更新了244個場景合併進度  2) relay自動化已實作  3) archive/已整理
需要我進一步說明哪一項嗎？
```

---

## 四、relay_claude_task.sh 的工作原理

```
小龍蝦 call relay_claude_task.sh "任務"
  → claude --print "任務"
  → 結果寫入 relay_output.md
  → 小龍蝦讀取並回報教練
```

---

## 五、注意事項

- **等待時間**：Claude 啟動約需 3-5 秒，請耐心等待，出現 `✅ 完成` 後才算結束
- **不要中斷**：執行中請勿按 Ctrl+C，否則輸出會不完整
- **結果追蹤**：所有結果都累積在 `relay_output.md`，不怕 session 中斷
- **每日獨立檔案**：`relay_output_YYYYMMDD.md` 會按日分割，`relay_output.md` 是最新整合版

---

## 六、常見範例

| 情境 | 指令 |
|------|------|
| 問候測試 | `bash scripts/relay_hello_test.sh` |
| 問頂級特助定義 | `bash scripts/relay_claude_task.sh "什麼是頂級特助，不超過30字"` |
| 查 HEARTBEAT 狀態 | `bash scripts/relay_claude_task.sh "讀取HEARTBEAT.md，告诉我今天完成了什麼"` |
| 分析場景庫 | `bash scripts/relay_claude_task.sh "scenes_master_v1.md有多少個場景？分類統計？"` |
| 翻譯一段文字 | `bash scripts/relay_claude_task.sh "把下一段話翻譯成英文：[文字]"` |
| 生成代碼 | `bash scripts/relay_claude_task.sh "幫我寫一個Python腳本：[功能描述]"` |

---

## 七、測試記錄

| 日期 | 時間 | 測試指令 | 輸出結果（前50字）| 結論 |
|------|------|---------|-----------------|------|
| 2026-05-05 | 17:20 | `relay_claude_task.sh "什麼是頂級特助"` | 老闆只要動嘴，AI 全自動完成。 | ✅ 通（claude） |
| 2026-05-05 | 17:29 | 直接 `claude --print` | Not logged in（hermes 模式） | ❌ 不通（hermes） |
| 2026-05-05 | 19:50 | `relay_claude_task.sh 成長時間軸50字` | 教練從懷疑AI能力，進化為建立四助教分工系統... | ✅ 通（claude） |

**最終結論**：
- `hermes` 是 MiniMax CLI（tmux封裝），不支援直接 `hermes "prompt"` 語法
- `claude --print "prompt"` 是正確的執行方式（Claude Code CLI）
- relay_claude_task.sh 已修正為使用 `claude --print`
