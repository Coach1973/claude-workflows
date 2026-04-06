---
name: 歷次對話教訓總結
description: 每次對話結束後累積的錯誤、繞彎、修正紀錄，供下次對話參考
type: feedback
---

## 2026-04-06｜心跳機制 + GitHub + E槽架構

### 犯過的錯

| 錯誤 | 正確做法 |
|------|----------|
| 建議用 D 槽存資料，沒先問硬碟拓撲 | 先確認 C/D/E 是否同一顆硬碟，再建議儲存位置 |
| PowerShell 腳本內嵌中文字串（here-string）| 中文內容一律抽出到獨立 .txt 檔，腳本本身全英文 |
| 用 schedule 技能（雲端 Agent）建立心跳 | 雲端 Agent 無法存取本機檔案，本機自動化要用 Windows Task Scheduler |
| 完成任務後沒立即寫記憶，等到對話結束才補 | 每完成一個重要任務，立刻寫進對應的 memory 檔案 |
| YouTube 記憶寫「發 Gmail」，實際是 Telegram | 寫記憶前先確認實際行為，不能憑印象 |
| 記憶寫 30 個頻道，@sensebar 加了沒更新數字 | 數字型記憶要即時同步更新 |

### 繞過的彎

- **D 槽 → E 槽**：原本建立 D:\Claude-Data\，做到一半才知道 C/D 同顆硬碟，全部搬到 E 槽重做
- **schedule 技能 → Task Scheduler**：評估了雲端排程方案後才發現不適用，改用本機排程
- **PowerShell 編碼問題**：連續兩次因中文字串導致腳本 parse 失敗，第二次才徹底改成全英文

### 確立的原則

1. **PowerShell 腳本全英文**，中文內容存獨立 .txt 檔
2. **記憶即時寫**，不留到對話結束
3. **問清楚再動手**：儲存位置、硬碟拓撲、發送管道（Gmail/Telegram）先確認
4. **本機自動化 = Task Scheduler + claude -p**，遠端自動化才用 schedule 技能

---

*每次對話結束請執行 `/session-wrap` 補充此檔*
