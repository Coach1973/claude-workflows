# NotebookLM 搬家開發指令與規格書 (交給 Claude 助教)

## 📌 任務背景
目前教練需要將 `bymyway7` 帳號中的 NotebookLM 筆記本（例如《海餅乾文化》以及個人品牌相關筆記本），完整轉移到 `seabiscuit` 帳號。
根據三助教分工，小龍蝦（我）負責統籌規劃，現在需要 **Claude 助教** 負責系統底層的程式設計，並產出可執行的腳本供「終端機助教」執行。

## ⚙️ 系統環境與限制
- **作業系統**：Mac mini (M4)
- **工具限制**：NotebookLM 目前沒有官方公開的 API。之前在 Windows 上使用的 `notebooklm_tools` MCP 無法直接在 Mac 上無縫執行，或者我們需要一個更純淨的本機自動化腳本。
- **解決方案**：開發一個基於 Node.js + Puppeteer (或 Playwright) 的本地爬蟲腳本。

## 🎯 Claude 助教開發需求清單

### 階段一：備份與下載腳本 (`nlm_backup.js`)
請設計一個 Node.js 腳本，達成以下目標：
1. **避開登入驗證**：腳本啟動時，直接調用 Mac 本機已登入 Google 帳號的 Chrome 瀏覽器設定檔（User Data Directory），避免被 Google 擋下。
2. **自動導航**：前往 `https://notebooklm.google.com/`。
3. **目標定位**：根據提供的筆記本名稱（初期以《海餅乾文化》作為壓力測試目標），自動點擊進入該筆記本。
4. **內容爬取**：
   - 進入「來源」區塊，逐一展開並讀取來源文件的純文字內容。
   - 將抓取到的文字，自動在 Mac 的 `/Users/bymyway/Desktop/NotebookLM_Backup/` 建立對應資料夾，並存成 `.txt` 檔案。
5. **防呆機制**：考慮到 FB 與 Google 經常變動網頁代碼 (DOM)，請加入適當的 `waitForSelector` 與 Try-Catch 機制，若找不到元素，必須在終端機印出明確的錯誤提示，而不是死當。

### 階段二：上傳與重建腳本 (後續計畫)
（待階段一確認能完美抓下《海餅乾文化》後，再由 Claude 助教設計將 `.txt` 檔案自動新建至 `seabiscuit` 帳號的腳本。）

---
**對 Claude 助教的指示**：
請評估此流程的技術可行性。若可行，請直接提供 `nlm_backup.js` 的完整程式碼，並附上終端機助教所需的安裝與執行指令（例如 `npm install puppeteer` 等）。