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

## 2026-04-06｜Netlify遷移 + GitHub Pages + NotebookLM + Facebook下載

### 犯過的錯

| 錯誤 | 正確做法 |
|------|----------|
| Netlify API 下載檔案用 Invoke-WebRequest，結果存到 JSON 元資料而非真正 HTML | 用 `curl.exe -o` 下載，保留原始位元組，不經 PowerShell 重新編碼 |
| Netlify 第一次下載（JSON）推上 GitHub 後，第二次修復腳本沒有真正替換舊檔案 | 先完全刪除資料夾再重建，git 才會偵測到變更 |
| 用 Cookie 登入 Facebook 後 yt-dlp 下載反而失敗 | Facebook 公開 Reel 不需要 Cookie，Cookie 反而讓 Facebook 起疑心 |
| 開啟 Claude Chrome 工具後才發現 tabId 型別問題（string vs number）| 使用 Chrome MCP 工具前先確認 tabId 格式為 number |
| Netlify 帳號有 21 個網站，之前只從瀏覽器看到 12 個 | 重要清單一律用 API 取得，不能靠瀏覽器翻頁 |

### 繞過的彎

- **Netlify 下載三次才成功**：第一次存 JSON→第二次 Invoke-WebRequest 編碼壞→第三次 curl.exe 才正確
- **GitHub Pages 快取問題**：頁面其實已正確部署，但用戶瀏覽器快取舊版，Ctrl+Shift+R 才解決
- **Facebook 影片清單抓不完整**：yt-dlp 不支援粉專頁面爬蟲，Chrome 自動化只能抓到當前載入的 9-10 支

### 確立的原則

1. **下載 HTML 用 `curl.exe`**，不用 PowerShell Invoke-WebRequest（會重新編碼破壞中文）
2. **清單型資料用 API 取得**，不靠瀏覽器介面（可能分頁、不完整）
3. **GitHub Pages 看不到先讓用戶 Ctrl+Shift+R**，再排查部署問題
4. **Facebook 公開影片不需要 Cookie**，用 Cookie 反而失敗
5. **Token 評估原則**：Chrome 瀏覽器操作每頁約 2000-3000 tokens，API 指令約 200-300 tokens，能用 API 就不用瀏覽器

---

*每次對話結束請執行 `/session-wrap` 補充此檔*
