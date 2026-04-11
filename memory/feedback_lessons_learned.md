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

## 2026-04-06｜Plaud.ai 評估 + HiNotes vs Plaud 比較

### 犯過的錯

| 錯誤 | 正確做法 |
|------|----------|
| 建議用「日期」決定 Plaud 轉錄策略（前20天下載、後10天用配額） | 應依**錄音長度**決定：短錄音用配額、長錄音下載；且應先用配額再改下載，不是反過來 |
| 以為 Plaud 分享連結可以當 NotebookLM URL 來源 | 分享頁面是 JS 渲染的音頻播放器，NotebookLM 爬蟲讀不到文字內容，不可用 |
| 點擊「生成連結」按鈕被教學遮罩擋住，多次點擊無效 | 遇到遮罩用 JavaScript 直接 click 目標按鈕，繞過 DOM 層疊問題 |

### 繞過的彎

- **Plaud 分享連結測試：** 以為分享連結可以解決「不需下載」的問題，實際導航後發現頁面只有音頻播放器，沒有可讀文字，NotebookLM 無法使用
- **Plaud vs HiNotes 比較：** 一開始只評估 Plaud 的使用方式，後來進入 HiNotes 才發現用戶有大量已轉錄完成的筆記，直接顛覆了原本的策略方向

### 確立的原則

1. **錄音工具評估先問用量**：用戶每月 60～90 筆錄音，Plaud 300分鐘只夠 5～10 筆，必須先確認量才能給策略
2. **HiNotes 是主力錄音工具**：自動轉錄、無限制、已有摘要。不穩定是 3.0 過渡期問題
3. **Plaud 分享連結不能當 NotebookLM URL 來源**：記住這個限制，未來不要重複評估
4. **JS 遮罩擋按鈕時**：用 `Array.from(document.querySelectorAll('button')).find(b => b.textContent.includes('xxx')).click()` 直接執行

---

## 2026-04-07｜HiNotes 逐字稿 → NotebookLM 帳號切換全流程

### 犯過的錯

| 錯誤 | 正確做法 |
|------|----------|
| 在 seabiscuitclub 帳號下直接建立新 notebook（如 64f722e1、900a5f2f、2ff30833） | 先確認目標帳號與現有 notebook，**加入現有 cumulative notebook**，不要每次新建 |
| 以為 `nlm login switch` 完全失敗（因為顯示 UnicodeEncodeError） | switch 邏輯在 save_config() 完成後才 crash（顯示確認訊息時），**帳號其實已切換成功** |
| 誤判 `nlm login switch bymyway7` 為有效 profile 名稱 | profile 名稱是 `default`（bymyway7@gmail.com）和 `public`（seabiscuitclub@gmail.com）|

### 繞過的彎

- **Unicode bug 卡了很久**：Windows cp950 無法顯示 `✓`（U+2713），`rich` library 在 legacy Windows console 模式下崩潰。最終修法：編輯 `notebooklm_tools/cli/main.py` lines 539 & 544，將 `✓` 換成 `[OK]`
- **re-auth 順序**：切換 profile 後必須執行 `nlm login -p default` 重新驗證 token，再執行 `mcp__notebooklm-mcp__refresh_auth` 讓 MCP 載入新 token

### 確立的原則

1. **帳號切換 SOP**：`nlm login switch <profile>` → `nlm login -p <profile>`（若 token 過期）→ `refresh_auth` → `notebook_list` 驗證
2. **Unicode bug 已修**：`notebooklm_tools/cli/main.py` 的 `✓` 已改為 `[OK]`，往後 `switch` 指令可正常顯示
3. **兩帳號 profile 對應**：`default` = bymyway7@gmail.com、`public` = seabiscuitclub@gmail.com
4. **window._copiedText 跨對話存活**：只要 HiNotes 分頁未重新載入，`window._copiedText` 在下一個 Claude 對話仍然存在，可直接讀取不必重新複製
5. **逐字稿存檔再上傳**：用 JS 把 `window._copiedText` 寫回剪貼簿（`navigator.clipboard.writeText`），再用 PowerShell `Get-Clipboard | Set-Content` 存為 .txt，用 `source_add(source_type=file)` 上傳
6. **累積型 notebook 不要新建**：每週戰報、曜董指導、嬿婷有約、咖啡會議都是長期累積，每次只 add source，不 create notebook

### 已知未完成的事項（等 4/11 額度重置後再繼續）

> 2026-04-07：HiNotes/NotebookLM 流量與額度已用完，所有操作型任務暫停至 4/11。

| 任務 | notebook ID | 帳號 |
|------|-------------|------|
| Rec81 董事諮詢逐字稿 → 加入來源 + 生成簡報 | e825fe7e（曜董指導-資料匯整） | bymyway7 (default) |
| Rec82 每週戰報逐字稿 → 加入來源 + 生成簡報 | ece171f9（每週戰報資料匯整） | bymyway7 (default) |
| Rec83 咖啡會議 → 轉錄後加入來源 | 1b99339b（咖啡會議） | seabiscuitclub (public) |
| 刪除錯誤建立的 notebook | 64f722e1、2ff30833（seabiscuitclub 帳號） | seabiscuitclub (public) |
| Rec81 逐字稿（17906 chars）目前還在 HiNotes 分頁的 `window._copiedText` | — | — |

---

---

## 2026-04-12｜記憶自動同步 + 全域 CLAUDE.md

### 完成的建設

| 項目 | 內容 |
|------|------|
| `sync_memory_to_github.ps1` | 每次執行：複製 memory\ + skills\ 進 repo → git push |
| Task Scheduler `ClaudeMemorySync` | 每 30 分鐘自動觸發上述腳本 |
| 全域 `CLAUDE.md` | 每次新對話自動 git pull + 讀取最新記憶，不需使用者提醒 |

### 犯過的錯

| 錯誤 | 正確做法 |
|------|----------|
| 30 分鐘自動同步上線後，以為記憶已完整，卻沒把「本次對話的新建設」寫進 .md | 自動同步只推已存在的 .md，寫入 .md 本身還是需要 Claude 主動執行 |
| 完成重要任務後問「要不要執行 session-wrap？」 | 直接寫記憶、直接 push，不問 |

### 確立的原則

1. **除錯成功、新方法確立 → 立刻寫進記憶 → 立刻 push**，不等對話結束
2. **自動同步 ≠ 自動寫記憶**：排程只推檔案，寫檔靠 Claude 主動執行
3. **CLAUDE.md 是對話起點**：每次新對話從 git pull 開始，記憶永遠最新
4. **不問用戶才能實現偉大目標**：記憶維護是 Claude 的本職，不是需要確認的事

---

*每次對話結束請執行 `/session-wrap` 補充此檔*
