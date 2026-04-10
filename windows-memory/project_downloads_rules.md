---
name: 下載資料夾整理規則
description: 用戶下載資料夾的分類邏輯，每次整理時直接套用這套規則自動執行
type: project
---

## 根目錄路徑
`D:\Users\Downloads`

## 分類規則（依優先順序）

### 永遠不動
- `export*.jpg / export*.png`：智慧書箋未發送圖片，等用戶自己決定

### → ZOOM 資料夾
- 檔名以 `GMT2026` 開頭的所有檔案（Zoom 下載的錄影/錄音/逐字稿）

### → 全國分享會 資料夾
- 檔名格式 `20260XXXX_XXXXXX`（如 `20260330_183232`）的影音檔（.mp4 / .aac / .mp3 / .m4a）
- 這是 BNI 現場錄影，非 Zoom 錄影

### → BNI 資料夾
- PDF 檔，檔名含有 BNI 相關關鍵字（紅綠燈、信用証、Traffic Light、GROW、Blueprint、章程、例會、會員、燈號）（優先於近期PDF文件）
- Excel 檔（.xlsx / .xls）—— 大多是 BNI 成員數據、PALMS 報表、燈號表
- Word 檔（.doc / .docx），**檔名含有 BNI 相關字眼**時移到此處
- GROW 相關影音（`20260403??????GROW.mp3/mp4`）

### → 文書檔 資料夾
- Word 檔（.doc / .docx），**不含 BNI 關鍵字**的一般文書

### → 資料蒐集 資料夾
- 圖片檔（.jpg / .jpeg / .png），**非** export 開頭、非 智慧書箋

### → 近期PDF文件 資料夾
- PDF 檔，**不含** BNI 關鍵字的一般 PDF（內部細分等用戶有空再處理）

### 暫不整理（等用戶指示）
- .html 網頁檔
- .zip 壓縮檔
- .exe 安裝檔（通常放程式集）
- 其他未提及的檔案

## 已整理記錄（2026-04-04）
- 26 個 GMT/時間戳影音 → ZOOM（後來 17 個時間戳格式移至全國分享會）
- 19 個 BNI 相關 PDF/XLSX/PPTX → BNI
- 3 個燈號 XLSX（開啟中延後）→ BNI
- 多數照片 → 資料蒐集（用戶自行移動）

## 下次整理方式
直接執行 PowerShell 腳本，依上述規則批次移動，完成後列出清單給用戶確認。
