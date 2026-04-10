---
name: NotebookLM 自動化工作流
description: 會議錄音→NotebookLM→簡報的全自動流程設定
type: project
---

## 神級指令（每次生成簡報都用這個）

```
依談話內容生成相應的風格漫畫，以日式寫實為輔
```

## 來源工具評估（2026-04-06 確認）

### ✅ 主力：HiNotes（hinotes.hidock.com）
- **自動轉錄，無限制**，每月 60～90 筆錄音全部自動轉好
- 已含摘要 + 標籤，無需手動觸發
- 目前不穩定原因：正在轉換到 3.0 版（過渡期），之後會改善
- **最佳流程：** HiNotes 錄音 → 複製轉錄文字 → 貼入 NotebookLM 文字來源

### ⚠️ 備用：Plaud.ai（web.plaud.ai）
- Starter 方案：**每月 300 分鐘**轉錄配額（不夠用，僅能轉 5～10 個長錄音）
- 分享連結（`web.plaud.ai/s/...`）：頁面是 JS 渲染，NotebookLM 無法當 URL 來源
- 建議用途：HiNotes 無法錄音的場合補充使用
- 若 Plaud 還有配額：優先用配額轉短錄音（<30分鐘），長錄音改下載音檔上傳

## 工作流程

### A. HiNotes 流程（主力，日常使用）
1. 用 HiNotes 錄音（自動轉錄）
2. 打開 HiNotes 筆記 → 點進 .HDA 檔案 → **右側三個點 → 複製導出** → 系統顯示逐字稿 → 左下角「複製」
   - ⚠️ 不要用 DOM 抓文字，要走「複製導出」路徑才能取得完整逐字稿
3. NotebookLM → 新增來源 → 貼上文字
4. 用神級指令生成漫畫風格簡報

### B. 下載音檔流程（備用，Plaud 配額用完時）
1. 將會議錄音（.mp3/.m4a）或文字檔（.txt）存到 Downloads 資料夾
2. 以中文命名檔案（例如：4月6號跟張三的對話.m4a）
3. 系統自動：
   - 以檔名建立 NotebookLM 筆記本
   - 加入音檔/文字來源
   - 用神級指令生成漫畫風格簡報（Slides）
   - 下載 .pptx，中文檔名存到指定資料夾

## 輸出設定

- 格式：Slides（簡報）→ 匯出 PDF
- 下載路徑：D:\Users\Downloads\NotebookLM簡報檔\
- 檔名規則：與來源檔案相同的中文名稱（去掉副檔名）

## NotebookLM 帳號

- 主要使用：public（seabiscuitclub@gmail.com）← 預設帳號
- 個人筆記備用：default（bymyway7@gmail.com）

## NotebookLM 資料夾分類規則

- **曜董相關會議** → 放入「董事諮詢會議」資料夾

## HiNotes 已知問題（2026-04-07）

- 轉錄按鈕按下後有時完全無反應（不是操作錯誤）
- 原因：可能是伺服器過渡期 / 無限制使用導致伺服器忙碌
- 已持續約一週，屬於已知問題，遇到時不必反覆重試
- HiNotes 3.0 過渡中，穩定性待改善

## 帳號切換 SOP（已修復 Unicode bug）

```
# 切換到 bymyway7（default）
nlm login switch default
# 切換到 seabiscuitclub（public）
nlm login switch public
```

- Unicode bug 已修：`notebooklm_tools/cli/main.py` lines 539 & 544 的 `✓` 已改為 `[OK]`
- 若 token 過期（出現 400 Bad Request）：執行 `nlm login -p <profile>` 重新驗證
- 每次切換後必須呼叫 `mcp__notebooklm-mcp__refresh_auth`，MCP 才會載入新 token
- 切換成功驗證：呼叫 `notebook_list`，看到正確帳號的筆記本

## Cumulative Notebooks（累積型，只加來源，不新建）

| 名稱 | ID | 帳號 | 類型 |
|------|----|------|------|
| 曜董指導-資料匯整 | e825fe7e | bymyway7 (default) | 董事諮詢會議錄音 |
| 每週戰報資料匯整 | ece171f9 | bymyway7 (default) | BNI 每週戰報會議 |
| 嬿婷有約: 品牌顧問諮詢 | 60006d9f | bymyway7 (default) | 嬿婷諮詢錄音 |
| 咖啡會議 | 1b99339b | seabiscuitclub (public) | 咖啡會議錄音 |

⚠️ 這些 notebook 有 20+ 個來源，每次錄音只要 **add source**，絕對不要新建 notebook

## 自動化狀態

- 腳本：待建立（`E:\Claude-Data\scripts\notebooklm_auto.ps1`）
- 觸發方式：心跳機制監控 Downloads 資料夾
- 狀態：規劃中
