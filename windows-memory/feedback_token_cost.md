---
name: 排程任務設計原則：避免 token 浪費
description: 因設計錯誤導致用戶多花 $10 的教訓，排程任務必須用腳本而非 Claude 讀取大量內容
type: feedback
---

## 錯誤描述
設計 YouTube RSS 監測排程時，讓 Claude 用 WebFetch 一個一個讀取 30 個 RSS 頁面的 XML 內容，每個頁面送進 Claude 處理，導致 token 爆炸性消耗，任務卡死、用戶多花約 $10。

**Why:** 每個 WebFetch 回傳的 XML 都送進 Claude context，30 個頻道 = 30 次大量 context 輸入。這不是 Claude 應該做的事，這是腳本的工作。

## 正確做法：排程任務的設計原則

**任何需要「重複抓取資料 + 簡單處理」的排程任務，必須用腳本（PowerShell / Python / Bash）完成，Claude 只負責執行腳本，不讀內容。**

| 工作類型 | 正確工具 | 錯誤做法 |
|---------|---------|---------|
| 抓 RSS / API / 網頁資料 | PowerShell / Python | WebFetch × N |
| 解析 XML / JSON | 腳本內建解析器 | 讓 Claude 讀 |
| 發送通知（Telegram / Email） | 腳本直接 HTTP POST | 讓 Claude 組裝 |
| 資料過濾 / 排序 | 腳本邏輯 | 讓 Claude 判斷 |

## How to apply
- 設計任何排程任務前，先問：「這個工作 Claude 必須理解內容嗎？」
- 如果是純資料抓取 + 格式化 + 發送，一律寫成腳本，排程任務只執行一行 `powershell.exe -File xxx.ps1`
- Claude 的 token 只用在「需要判斷、理解、生成」的地方
- 預估 token 時，WebFetch × N 是最危險的模式，必須警示用戶
