---
name: 讀取 Telegram 回應不截圖
description: 教練要求用 session 檔案讀取，不要截圖消耗 Token
type: feedback
---

讀取 OpenClaw Telegram 回應時，**直接讀 JSONL session 檔案**，不要用截圖。

**Why:** 截圖每張消耗 1000-3000 Token；讀文字檔趨近於零。教練明確說過「截圖會消耗太多 Token」

**How to apply:** 需要確認小龍蝦是否回應時，用以下流程：
1. 讀 sessions.json 取得 sessionFile 路徑
2. 讀 JSONL 檔案取得最新訊息
3. 不需開 Chrome、不需截圖
