---
name: notebooklm-setup
description: >
  連接 Claude Code 與 Google NotebookLM 的完整安裝技能。
  當使用者說「幫我連接 NotebookLM」、「安裝 NotebookLM」、「設定 NotebookLM MCP」、
  「我想讓 Claude 操控 NotebookLM」、「NotebookLM 懶人包」時，立即觸發此技能。
  自動執行環境檢查、安裝 nlm 工具、Google 登入、MCP 設定、建立資料夾、驗證連接，
  全程用白話中文引導，不需要使用者有任何技術背景。
---

# NotebookLM 連接技能

## 你在做什麼

幫使用者在電腦裡裝一個叫 `nlm` 的「翻譯官」，讓 Claude Code 能透過它去操控 Google NotebookLM。

```
Claude Code ←(MCP)→ nlm（翻譯官）←(Google 登入)→ NotebookLM
```

整個過程分六個步驟，有些需要使用者手動點幾下，你會在適當時候暫停並說明。

---

## 先備條件（開始前先確認）

在執行任何步驟之前，先告訴使用者確認以下三點：
1. Claude Code 桌面版已安裝且能正常使用（Pro 方案以上）
2. 有 Google 帳號（用來登入 NotebookLM）
3. 電腦有網路連線

確認好了就開始。

---

## 步驟零：環境檢查

**不要假設環境正常，每一項都要確認。**

依序執行並回報結果：

1. **確認作業系統**：執行系統指令，確認是 Windows / macOS / Linux
   - 後續所有指令根據實際作業系統選擇正確版本

2. **確認 Git 已安裝**：執行 `git --version`
   - 若未安裝：
     - Windows：`winget install --id Git.Git --accept-source-agreements --accept-package-agreements`
     - macOS：`xcode-select --install`
     - Linux：`sudo apt update && sudo apt install git -y`

3. **確認 uv 已安裝**：執行 `uv --version`
   - 若未安裝，步驟一會自動安裝

4. **確認網路連線**：嘗試 ping 外部網站（如 google.com）

5. **確認 Claude Code 版本**：確保是最新版本

全部通過後告知使用者：「✅ 環境檢查完成，所有條件都符合，開始安裝。」
若有不通過的項目，列出問題清單並逐一引導解決。

---

## 步驟一：安裝 uv 與 nlm 工具

### 1-A：安裝 uv（如果步驟零確認尚未安裝）

**Windows（PowerShell）**：
```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

**macOS / Linux**：
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

安裝完後重開終端機（Windows：重開 PowerShell；macOS：執行 `source ~/.zshrc`）

### 1-B：安裝 notebooklm-mcp-cli

```bash
uv tool install notebooklm-mcp-cli
```

### 1-C：確認安裝成功

```bash
nlm --version
```

若出現 `nlm: command not found`：
- 重開終端機再試
- 若仍失敗，告知使用者可能需要手動將 uv 路徑加入系統 PATH

---

## 步驟二：登入 Google 帳號

執行以下指令，會自動開啟瀏覽器讓使用者登入：

```bash
nlm login
```

> 🖐️ **暫停，需要使用者手動操作**
> 瀏覽器會開啟 Google 登入頁面，請使用者登入他的 Google 帳號。
> 登入成功後，告訴我，我會繼續執行下一步。

登入完成後，確認狀態：

```bash
nlm doctor
```

若 `nlm doctor` 顯示未認證：重新執行 `nlm login`
若瀏覽器沒有自動開啟：請使用者手動開啟瀏覽器，登入 Google 後回來繼續

---

## 步驟三：設定 Claude Code 的 MCP 連接

執行以下指令（不需要手動編輯任何設定檔）：

```bash
nlm setup add claude-code
```

確認設定成功：

```bash
nlm setup list
```

應該能看到 `claude-code` 出現在已設定的客戶端清單中。

---

## 步驟四：建立本地資料夾

> 🖐️ **暫停，需要詢問使用者**
> 在建立資料夾之前，先問使用者：
> 「請問您希望 NotebookLM 的資料夾放在哪裡？
> 例如：桌面（Desktop）、D槽、文件資料夾（Documents）都可以，
> 請告訴我您希望的位置。」
>
> 等使用者回答後，再繼續建立資料夾。

根據使用者指定的路徑，建立以下目錄結構：

```
（使用者指定的路徑）/
  └── NotebookLM/
      ├── slides/          ← 簡報（可匯出 .pptx）
      ├── infographics/    ← 資訊圖表
      ├── audio/           ← 音訊概覽（Podcast）
      ├── video/           ← 影片概覽
      ├── docs/            ← Google 文件匯出
      ├── sheets/          ← Google 試算表匯出
      ├── mindmaps/        ← 心智圖
      └── quizzes/         ← 測驗與閃卡
```

建立完成後，告知使用者資料夾的完整路徑。

---

## 步驟五：重啟 Claude Code 並驗證連接

> 🖐️ **暫停，需要使用者手動操作**
> 請完全關閉 Claude Code 桌面版，然後重新開啟。
> 開好了告訴我，我會繼續測試。

重新開啟後：
1. 嘗試列出使用者的 NotebookLM 筆記本清單
2. 若成功顯示清單（即使是空的），代表連接成功

---

## 步驟六：功能測試

連接成功後：
1. 在 NotebookLM 中建立一個新的 notebook，名稱為「測試筆記本」
2. 確認建立成功
3. 建立成功後，刪除這個測試筆記本
4. 告知使用者：「✅ 全部完成！你的 Claude Code 已成功連接 NotebookLM。」

---

## 完成後可以這樣用

| 使用者說的話 | NotebookLM 會做的事 | 存放位置 |
|------------|-------------------|---------|
| 「幫我用這份 PDF 建一個 notebook」 | 建立 notebook + 上傳 PDF | — |
| 「幫我產生教學簡報」 | 生成 Slide Deck（可匯出 .pptx） | slides/ |
| 「幫我做一張資訊圖表」 | 生成 Infographic | infographics/ |
| 「幫我產生 Podcast」 | 生成 Audio Overview | audio/ |
| 「幫我產生影片概覽」 | 生成 Video Overview | video/ |
| 「幫我產生心智圖」 | 生成 Mind Map | mindmaps/ |
| 「幫我出測驗題」 | 生成 Quiz / Flashcards | quizzes/ |

---

## 如果安裝失敗，如何重來

當使用者說「NotebookLM 懶人包執行失敗，幫我重來」，自動執行以下復原步驟：

```bash
nlm setup remove claude-code
uv tool uninstall notebooklm-mcp-cli
nlm logout
```

確認環境乾淨後，從步驟零重新開始。

---

## 常見問題速查

| 問題 | 解法 |
|------|------|
| `nlm: command not found` | 重開終端機，或確認 uv 安裝路徑已加入 PATH |
| `uv: command not found` | Windows 重開 PowerShell；macOS 執行 `source ~/.zshrc` |
| 登入後 `nlm doctor` 顯示未認證 | 重新執行 `nlm login` |
| 瀏覽器沒有自動開啟 | 手動開啟瀏覽器登入 Google，或嘗試 `nlm login --manual` |
| Claude Code 看不到 NotebookLM 工具 | 確認有執行 `nlm setup add claude-code`，並完全關閉再重啟 Claude Code |
| Windows 上指令格式錯誤 | 確認使用 PowerShell 而非 CMD |

---

## 參考連結

- [notebooklm-mcp-cli GitHub](https://github.com/jacob-bd/notebooklm-mcp-cli)
- 對應懶人包：01-連接-NotebookLM.md（v0.2）
