---
name: NotebookLM 自動化工作流
description: 會議錄音→NotebookLM→簡報的全自動流程設定
type: project
---

## 神級指令（每次生成簡報都用這個）

```
依談話內容生成相應的風格漫畫，以日式寫實為輔
```

## 工作流程

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

## 自動化狀態

- 腳本：待建立（`E:\Claude-Data\scripts\notebooklm_auto.ps1`）
- 觸發方式：心跳機制監控 Downloads 資料夾
- 狀態：規劃中
